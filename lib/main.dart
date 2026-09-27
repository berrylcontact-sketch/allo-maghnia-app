import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// ⚠️ Remplace cette URL par l'URL réelle de ton backend une fois déployé
// (ex: https://allo-maghnia-api.onrender.com)
const String kApiBaseUrl = 'https://allo-maghnia-api-production.up.railway.app';

const String kAhmedBenaliPhotoBase64 = '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCADXANIDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9QP7JbP8Ax/XOfqP8KDpD5/4/7n/vof4VoGgUAZ39lPn/AI/7r/vof4Uv9lN/z/XP/fQ/wrQPvQKAM86Uw/5fbn/vof4UHSWP/L9dD/gQ/wAK0etJigDOOjuf+Yhdf99L/hR/Y7gf8hC6/wC+l/wrRBx1FKRnmgDN/sd/+ghdf99D/ClGkPj/AI/7r/vof4VoHijqKAM7+yHP/L/df99D/Cj+x3P/ADELr/vof4VoikzQBn/2O3bULr/vpf8ACgaO/wDz/wB1/wB9D/CtEHFFAGd/ZD/8/wDdf99D/Cl/sl/+f66/76H+FaHtS7aAM7+yWH/L9c5/3h/hR/ZTd765/wC+h/hWhjmigCh/ZTf8/wBc/wDfQ/wpP7IY/wDL/dD/AIEP8K0c8cUdaAM/+yXz/wAf91/30P8ACg6S/wDz/wB1/wB9D/CtDnpSEelAGf8A2S3P+nXP/fQ/wo/spv8An+uf++h/hWgc44owPxoAz/7JfP8Ax/XP/fQ/wo/sps/8f1z/AN9D/CtCk70AUP7Jb/n+uf8Avof4UVf3H0ooACATTsGmgYp2cigBDx2oz/8Aqpc560h4oAOntQB+FKBnGaSgBSMUYyKD05oDUAIBzS5AoJA6DP0rnPFXxB8OeC7Yza3rllpagZ2zzAOfovUn6UAdGzAU3cDXy/47/b/+HnhWd7exttU12ZRw8MQgiz6EyEH8hXiPiX/gqHqcTldF8I6db+93dvM35KoH61EZKXwlSXJ8Wh+hxZQOtNMi561+Veu/8FNvipchhZLoVjnoF09pMf8AfUlcyv8AwUk+N6PuGs6Hj0bRAR/6NrZRbMHUR+vodSKGcCvyOt/+CpHxj05h9pHhjUB6PpUkf6rN/SvWfhv/AMFWzrLxW3ijwtZ210eDNZ3TJGT7BgcfiamScVdlxkpuyP0XU7jT6+cdC/bn+HF3Eh1SW90PcM+bNF50X/fUZP8AKvX/AAT8WfCHxFtfP8NeJtM11e6WdyrOv1TOQfYis4TjNXizWcJQdpI6/wClIf1pu/PP3T6GkDZqyB3480YxSAZNLzmgABPSlHI4pM80o60AAJHakLUucim9PpQA7cfSim5FFAB3p2RikAz1pTgj6UAGMCj3oBwKCc80AHfIoI70dvb1rm/HfxC8P/DPw3da74l1SDSNKt/vTzt989lQdWY9gMk0AdEWBIHf0ri/GXxZ0DwYzQz3Qur4dLO2IZx/vHov418NfGH9vvUvGl5NYeFFm8P6ACV85ji7uR6sR/qx/sjn1I6V5NbfGxmU7pSWPJJOST60pKXRGPtodz6++Inx18TeJIZbewu/7Cs242WTYlI95Ov5Yr4z+N/jqTw1cR6dZ3LPrd6pllunYvJDF0Lbjklj0GfrWmfi6JTzLx35r5v1/wAS3HivxXq+r3DFnuJykYP8Ea8Ko/CiCd/eI+J3QXl48pOWZierMxJP1J61mzngnNWcFhUEqe1dNyGrGVcSFSSfzr1j4cfAm68VaPJqOt2msWdrMqtZNYxoTIO7MG6D09a8tmiDEjH519d+C/j54f1fwtavcS6fob2jLbTwXt4FZY0QYkUY+YHGMCvkeJMXj8Lho/UY3u9Wt12+/wDrc+w4YwWAxmKksdK1lons+/3f1sfJet6b4d8OfErVdH1hNYl0W0kaEGPZHdq2AQXHIIBPQdeKZ8SvA8Pw/wDE0NpaXM11ZXNpDe28lxHskCSAkKw9Riu6n8f/AA0vPHN54mn8Nare6lNdGdTd3CG18zOA5Qc7eAcc1vfH/wCHU+q2Oo+MP7Wu9RuLBLcXMtxAsdrNFJyhtSv8Kk4KnJ75rOjmNWli6EMSpQUo2fNa0paLS17avV3V7rTdroq5ZSrYHETwzjNxlzLlveMdd27X0Wis7Weutn5FpHi24gh+yyzuYDxgN0+lJcS3em3keqadeTQ3EZ3Jd20rRzRn2dSGH4GuQklMZ681ZtNXlgbAOVPBB6GvspQi9VufDwnJb7H2x+zT+3Z8WvDl5BYa3fjxxoYwnk6tgXKAf3LhRk/8DDZ9a/SX4ZfG7w98SrWH7PI+m6g6gmwvcK+f9kjhvwNfkj+zfa2WuQzFABc20g8xO+D0I/WvsTR7RbTTk2jDAZGOoNfMV8dVo13C2iPrcNgaVfDqd9X1PvMEZx3oAr5K8DftEa94O1GGx1xJNa0UnbvJ/wBJg91b+Mex59D2r6k0DxFp/ifS4dQ0y6S7tJR8roeh9COoI9DXr0a0a0bxPFq0pUpWZoZwaM/nS8UjHHIroMBM/nRnjpSjrQeaADj0oo4ooABQRzk0YxQRjGaADHpSHOOad1rP1zV49HsJLh1MjgYSMdXbsKAOF+OHx18PfAzwo2ra1I091LlLHTIWHnXkmOgz0Ud2PAH5V+TPx/8Ajd4v+OPicap4ivCYoiRZaZbki2s0PZF7nHVz8x9hxX1X+0b8MNY8e6zd+IdTvJbm+K7Y0J/dwxjpGi9lH6nk18cX3hy4k14Wbrh0baaqMl0OKpJy06HK29rdlBnOfSnvaXyjcBxXvfh34KSanbI/IyM9OtbMnwJkjG0ZJ+laqojz5Re6Pm23juxZ3M0hbGPLUfXqfyrD03T/ACLffJzJIzP9MmvS/HNtHpT3VlBg+SXTcOhI6muLazW0tlaSQBVUZZjisnK7bPVpQ5YJMpOAB0qq2W6citW30i7vzvVBbW/XzpxgkeoXr+JxWDrPjLw94cdoYt2uXo4IB/dg+/b+dVsNq4s8RY/IC7eijNY15pVxcvlreQ47mM8Vj6p8Q/EepxtHahdPgPSO3ATj3PWsIJrFyS8sskpPXc5P9aOePcFSk+h10thLbxpmGTJbGdvFR6n4q1ZtJj0ifU71tMibeljJMxhQjoQhOBXGzPqNtuws6kdwTVZfFWoW58uZmlT+5Ou4frzQ1CVm0nbYa9pC6TavozbMnmE09Pl5rPttZs7sjen2Rz3XlP8AEVoKrKQDyDyCOQRW17mDTR7N+yl4gktvi3Z6eDiPUIJYWB6ZVd4P5r+tfoxplqq6cPXHWvzH/Z9i+yfG7wZNuKI9+sbH/eVh/Wv1IggEdhwOMV8lmkbYhPuj7DKZ/wCzOPZ/5HNX9mGuASBiuu+HXi2+8Ga0kllL+5lIE0DH5JB7j19+teZeNPFS6M+CdoHesXwf49Gq+JLS3WTIZq0o35U0cddpTaZ+iOga9Br1glxAcZHzIeqn0Nao5FeXfD+SS2tI5oz/AA8j1HpXpdpdx3cIkjOR0I7g+le1TnzLXc8ucbPQlxQeOKXPpSE9j1rUgXaKKSigBcetA5pM4zSHjntQASyLEjO52qoySa5nUmGpSh3GVHCqewrK8TeMIbjWG0m3lB+zsPtGD/F1C/hV2CdHiU7h0qWxJp6HB/ETRYJNNnLKCdp7V+feuaHGPiVMuAF8yv0M+It6iabMMjO018HamBcfEiXAyfMNStGc1RHvngbTLcWEYC4O0dq0/E8lponh3VdRcLi0tZZzkd1QkfrioPBkbJbICOMVxH7TXiJfDHwe8SXbtsV4lh+oLDI/IVp0OWO6PiPxJf3mqSNFZWj3d1MTudjtjjycks39BzTfsth4XtP7S1y7W6uU+6SuEQ4+7Gnr7nn6Vg/CC98T+LlltLayjuLq+uWe2aeTYqg+oA6CrnxG+DXijSdQ8zXrhbqUDgQA+Wg9AO1YSxNKk+WT1Pcp4OtWjzxjoec+OPiDqfiuV7a23Wmn5x5an5n/AN4/0rm9N00QsCwya3dRhtNLfy2YGQcECrWkWdrqDg+cqg9icVM6rlG9tDWnRjCXK3qJa2UbKPl5+lbFvp0TIMLzXc6B8O0vbdWjZXBHUVYvPAU1gchcge1eTKur2PoaeFfKmjgLjRo3UjB5rG1DwtHJG2AD7EV6fJ4buGTHlH6gVi6j4duolb5D+VEK7T3HUwl1seKap4b+zOXiGwjt2o0nUWtG8uQFkzyh/mK7LV7J4ywkX2ri9WtfIJdc5Fe3Rq8y1PlsTQ5Hoem/C7V0sfiH4UukIeNNUtjnuP3g6/nX6vWVwstg+fevxa8K+IX0bXLC9IZkt7iOV0H8QVg358V+wHgDxPYeMvB9lrekzi506+iEsUgGMjuCOxByCPUV5WZxfNGVj0MsklGcb9meWfGq1e4hk8s7TnqK474LaRLb+MLCWZmcs+MHpXo/xPti8LkjvXN/DcCHxJp2f+elXR/hWOPEa1bn334JG3SkwP4aS68Uv4VvzcSZa1JxMo/u+o9xS+BZg+mxj/ZrE+IqAWUzexrojeysTLqew2F3FfWkNxBIssEqh0kU5DA9DVjHNfNf7M3xaWTWL7wRqU3zIzT6YzHqOrxfh1H419KBty57Gu45IyU1dBk0UnNFBY7I6Vx/xW8f23w08Baz4huCCbOE+TGf+WkzcRqPqxFdazYBPeviL/goR8Q7prvw74TtG2W0AOoXjKfvSH5YlP0GWqZS5VcaVzj/AAP8aJbaWWXUrvdeTytNK7n7zsck/n+gFer2vx7skjQNdJz/ALVfCRvbyYDac/hQYtWmX5QxHtXH7R3F7FJaM+x/HvxltLqwlZblTkcKD1r5ni8SofFZvHb771w082pWq4mDgD1zXO6trEyEMrEODmt4K6uctRtOx9peE/iHHshhVw7yEKoHcnpWH+074Tm+LXweuNN0DUbTUruO8ikube1k3HYudy/73tXzv8KfFmoXHjTQ4LhsW73Kqcn1Bx+uK+rfhf4MsPDPw9GqX99HY3t7cNORO20MoOFHNeHmONq4WpGFPqrs+vyLKsNj8PUrVm7qUUkvNN/ofOH7K/hyGT4mJbeTt+xWjtsI+6eFFe0fHnwhNf6BPBYxIk1x8r3BGWVfatX4DeAVtfiV8QteVFFs9yttbsvQg/OxH5iup+KmhX+oWzrZEK+OC3TNePiKjdRVV5Hv4SklF0JPqz8/9Q+A+k2czfb77ZI3P7yQKTXHa58HtNgJNhriRvnhHYEfoa998WfBnxVbX7302s+VBKGEp09QLnpxtdwcDOM4xxXhWneD9fHiaK1126u7PT0c+fdtKz7kA7ZzknivYw1epUV/a69jzMXhaVKXKqLa7jfCmj+KfC96rWt+LmDuiPkEfQ17/oBl1HRIJb6HbckfOpFeOeFbHUYdXmhty0kKHcrsMK65447GvpbQ7K0Hg9JrhMXBXk1w4yvJyV7XPTwGFjCL5b27M43XdU07RdLeeWJFCDnivHtd+MmgvO0IgkJxyyrxV/4oeJPOuJbOJC8YzuXoMV5GJ9GtZHkvtPDJt35+cceowORXbhaUZR5ppv0POx2InTlyUpJepe13xVpepbjGrLnplaxLPRB4iDLbgu2cEY5FdNYQ+DtZgzFaGIH/AJaRylsfX0/EVt+CvBE2keMrG40+Vp7CQlZVYdFwea9JVIQi1FNPzPElSq1JKU2pJ9jxafR5dP1aezKM0kZIKqMnjmvvH/gnj41ub7w/4k8JXG6W2sSt9auf+WYkJDr9MgH8TXlP7Jfg1PFvxm17xHeW6y2Fg0kUYdcq8rkjHvhc/nX3v4O8A+HvA2lXp8PaLZ6Obx/MuDaRbPNb3/w6VOMxMXF0WrvQzwmFlze2TstfuOF+KkkcVu/IrhfAD+Z4l07bz89bPxfuJQjgZJzXOfCrzP8AhJbFphtUPU0v4VzkxGlWx9/fD9mXTo8/3RWN8TbxY9NuM8fKa3fBEsf9lx4Gcr1rD8daa1/DKu3cDnitU7RQNXbPjXTtU1S08fQ6lpSyrc2t0JYpEHRgf8j8a/STwjry+JfDun6mq+X9piV2jP8AA38Q/A5r5c0L4a+Vcea0QXLZ6V9CfDD/AECxl09j8qnzYx6Z6iuqNXmdrHHToOkm29zueKKbuorcsbMdq5PA71+d37U9o2u+JtV1GX5pJZ/l9lXgD9K/QnV7gW2mXcp/hjb+VfDXx509ZHduDk1x1+htT2Z4H4b8LJPEhdc5rvbDwZCyIEQH8KraII7eJFIwa3bXURDMMP37VhFJsym3E5bxr4EVIGKxjO3PSvnXW9GdNdFqBwT0r6+8QanFLYYYgnbXz1qllFdeMkKjPIrak7NmVZe6mW/BngaWK+sblVIMUqSA49CDX0B448PXniTxbpeiFmisGCKjfwqp5J+tZ/hbRUFlG2wdB2r2fS7C31PwyZJP3jzHa2B+8jccZU/ka8DN6bqqEl0PtOGMUsLKpF9bW/K/yuSeB7Gw8PWt/plkD5VveOnJyTgKASfpW7qenR3tucgYx3rzvwbcm21vXbZzIPLuFP737x+UDJru7e6W4BDuQo7eteWpXVmexKDUuZM8k+IXheK5DwSRlsjKsvBrwjUvg1Lqt2VhluGUn+NuB+dfYGt2trcL8ygjHUiuBu5raxlZTgc8cVDbp6pnpU7VUk0eSeGf2fINLw+4y3LjBY9BXVeMfBcfh/w6ioPlVCM16rpU8d2IYooTukH38cVj/FHT5DoMkUi/wnB9awadT3mzog1CSgkfnx4w0c6h4juCF3oThkPGawte8CRa3b2sNzJPbC3jMMRByqoTkr9M16Rqtr9m8UyQOvzMTtBHWurstDSeIFk3Z7Y6170cRKlFWZ4E8HCvOSkr6nzpqHw6eytdPi04QwTWxY+fHnfNns/qK9e+GWmzWdo4uVCyLExwOgODXav4LtQplEKq3XGKzLoLpFpfTKMLHbyH/wAdNN4mVayZzPBRw12kYnwE1K+8C6n4e0a2LzS6tdiadNoCKHOWJ4ySBX39Z4fTSPUV8RfBXTjrPjzStTdAkVhaA4x1kK7QPyya+3dFAfSgTzxXO5uVRt9TWvThTpQhDol955F8RdCW9mIYZBNc/wCGPD/2LW7NlUjDivTvE1ujT5Zc81n6VaRtqdthAPmr0435T5iolzM+kPAMjSWMQxwFFdNdaaLgnIBFY3ga12WUf0FdS3B5r0IK61OGT10MkaNGnUY+gq/o8Qsb+KRR32n6GlZvnNTxRdCOoq0knoQ22dXzRSRXUZiQk8lRRXZcwscp8U9TOk+EZpQ20vKifXJr4f8AjF4m893UtnmvsX4+hn8JWsanG65B/JTX5/8AxX82G5lyScHjNcFZ3nY6YfBcq6frXmQjntT31dYHDbq5vw4slzCAVOT2xVvXbCWO1YqpDAZrnd1oTZPVlzW/Foe3KBh0rz+2vwviKKZmzk8muY1bXrmOdoyGGDjmqhv5DscZznOa7aULJs4KtXndkfWnhLxNE1mqlh0re/4Ta602GRbKdUZuRuQMAfXFfJ8PxOt/Ctosuo38douM4duT9B1qk/7TUdxbXE2nWjyW0Xym9uvkjLegHVjWUqPtouEo3R20a8sPNVKcrM+vvh3NevbX1zd3BvLlpy8kxXbuz7e1d9HfmPCgZJGQBXiX7KfjxvGnw/ub6+kjlunuZAxRdowDgAD6V63ZXKS35BUCPopHU18diqapVpRXRn6Hg6rq0Yzlu0Vte1mWKJjzgCuc0HQbvxHdm5uQ0duDlQ3VqsfFTxppPw/0v7deqbmZztggA4Y+przLwV8ddb8UNdNa6blI+AV4T/dye9ZRpSmuZ7HofWIwahHdnc+NviX4y8Gavb6bonhmDUrOMAtNJL5WV7hW6BvYjmud+Inx2QaW0V/MiPty0TAAr7Vz/jHUPGuu2U7t9ktcqWSLz13t7AetfP3jTT/Fd/4UmubvTp0nikYKXjO4D1ziuylR57LmMqmI9mnLk19DWbxRpXjG8e6to5UuY5cIzoVLH1HqK9X0aBGtEk2jkc18z/CrxZbJcSW+pKYbxTjdIMA/4V9B6FrUbWxMbiSMjtzWmJpypPltoRgq8K8ea+rLut3kUUJGcHtiuE16J9WsZbKOQRNc/KzEZ+Uct/hV7xDqDvM2TgelUdIdzcSXEsDmJV2xyMvyH15+tOjBvVGGKrQT956I7b4QWJsLlE2bDnoR26CvrPQnxpC59K+V/hrqaXOpsxO5mavpzT7gw6Op7Yq6kXCr6HlQq+3pc76u5geKJVEvJHWsrSbkLqluc8bq57x14ha1vMZIGax9I8T7ruMg8g5FelB+6jw6llNo+1vBmqxLYxgkZxWxe+IoIAcuBXzzovj64tNPyqknbWFffEfUbu4K52AnHJrdV9LGHsr6n0Jc+NbdJsBxirMPjeDy87wPxr5tfXbmUbnn/Ko28USKQpuOB70Kqw9mfUEXxBiESDePuiivlVvFjqxH2phg4xmin9YY/Yo+sfjqjHw3ZsASBc8/98mvhL4r2glu3Hcmvvb45uIvAF1Mf+WMsbZ9OcV+f3xG1MXWqBEIJZu1dNVfvDkT9wqeE9CmCq6oMfSt3W9Mc2rZQEgdhXWfD/RFuNLTON2Kva7oWyGUHnis5JsmEUfIvjDRhHdSPtxzXF+J9ZXwx4anvVQPcfdiBHAP94/SvbfiFpMNvFM8hEaDJLHtXhHje3i1rQb23gYPuiIjx7c11YfVanJUpcsrnjGl6bf/ABB8SxQvI88srbpJXOQi9zXQfEC9t7G8i0izASzsECKo7t3Y+9dD8E9ONhol/dOq+fK+zd3AHaoNI8M22oeMtVv9QjE9vZKJvKf7rMWwC3qBjpWuKxEcNSlVktF/wx25fg547Eww1N2cnu9l1b+SVz6d/Zikn8NfBnwxrH2byrTUru6t5HAwCwkJRjx3AI/CvpPSr2OdI3yASQdw/irnPgbodn4u/Zl0q1vsbb9ZrhXRQPLYysUZR2xxWF4B8Rf2XrF14f1iREvrc/Kx6Sp2df6ivzytUdWcptWd2fpVKkqEVTg7paX/AK7mh8W/Bp+I1xb2KvsgQfM+PX0ri7f9mdfD9mP7G8Rapp8Od0lrFcHYT/eUHODXs6+Vd3P+iSLK/wDEo5xUGtW9+bdkjjYtjoBWMK1SOieh1QjBSUranz/r3w48WaGoudJ8WyakoGDFdfLIPbHINcL4juviXFaYu1uJbb1SVRn68VofGbx14o8D6ixWAC3PTzEOfzrjPD/xW1vxpCILq3lVCcZTIQj1r2IUpOCqpKxvPMMJzewk5KRzepyyalP9nvfD0xv2+7NAq78+pIrqfhhbajol9qEF3IxtBGHXf/Cc9K6zT7CK0zKwHmN1P9KxvFGqNCrRw/KW+8RWrqupH2aWjPBqUYQn7a+qI9c1eOdpZi4jgj6ueg967C9itm8KWg0+5ju7fyQRLEcqxPJP5184/Ejxf/xKptFtpQbuZD5hH8I9PxrN+AHxFufD2pNouozs2mXB27XP+qfsRXt4XDONPmPkMxxSq1FHt+Z9PfCBZv7XbqRvr7E0aPzdEG4dFr5k+EmnINQLJggtkGvqWwQRaQRn+GuepFSm5E0Kkow5Dw/4n6YZLgEHHNcZpVu8OoQjcT83Su4+KGrQ2ch3EcE9a4rw7dpqepxMn96tIuNrGM4TT5mj3bQdNe40rdt/hryX4jeI7jwrJI4iZguelfQnhOzCaSMj+Gvn/wDaBCATLgDrRCCclcKk5KDseY/8Lqv71D5UEmO1Yd18VtY+1opjddzY5NSeE7BJYDlAfwpviLTIoZ7dtoH7wV2qEE7WPNdWdtWa58X6w5LKpIPI60V694e+HyXmgaZcfZSfNtYpM465QGio9iux1e0fc+9/jTpM+r/CzxVb2wBuP7Plkjz/AHlG7+hr8nNN8cDxBrcRZjzgnNfsreRrNH5ciho2BV1boVPBH5Gvw7+K2jz/AAq+NnjHw8w8s6bqkyRgcZiZt8ZHttb9K7uRSdznnJxR9nfDzVre3sI90gzirvifxPaCNwrAkjtXyT4d+Mc8MARCzEDoKt6x8XZLbTp724yxQfLDu+Zz7CuSUHsawqaC/tFrqmtafYWOkvHCtxOWuJpGwEQD8z9K8nj02PRYUhjna5+X55H6sfWtKb4oWviy4JluQX6eWeMfhUdxZ2t8A4m298qa6aceSPKRJ875jnNFiPh3VblE4sbxt6j+4/cfjUtvG13q1/YwEB9UtntUJ7yj5ox+JBH41a1JIIofLj3EdCTzmuUmv3hK7ZSkqsGSYDBBBBB+o61GIpe3pSp9/wA+n4nRgq7wmIhWXR/g9Gvmro/QX9nfU/I+CXhnTwdslrbeVIh6qwJyDXMfFfwxJfXkWoWrGG8t23xzr1U9/qD0Irz34G/F63nUiWVILhwPtlrnAEnTzU9VbqfQ17te31rq1pkFTuHXrX5rL2lOs+dWaZ+spUpUl7N80GtH5f5/kz57+Gvx41Hwd42udM1yNbeXzckuflIPQj1Br6Xg+P8A4fuYUkMQjV+FLHlz7e1eLfEz4EWvxE0nz7WRbPVrfLW9wBx/ut6g18m+MdT8X+AdSXT9YtLi2Nt8qSYJjYeqsODmvoaFKjjIpxdpdV/kfK4itWwMnzLmj0f+Z9kfFb4g+H/EMrQXVpDJkf6sgHP1rzq11Lw5oYhgEUcEL527eie1fMDfEq81C586Vyx+tQeIfH892E2OVC9ya745Y0uW5xPOI35ktT6b8ReMdD0u1kmEytgcAHvXmer+Jm1iFzZYCAZkuCMhc9h6mvJtBtdT8Z3S+bK8WnofnlP8Xsv+Ndz4ju47DSrbSbFQrzOsSKvpnkn8KiWHhh/dTu/yNaWJqYt80laPTuzya8hmsvEt6lxIZZQ5JcnqDyKZayiHXfMUYGN2ak8QXCXXiXUbiNsxGTYp9QoA/pT9NiV3aRgMsMD6V9LQcnTi5b2R8ji4wp4ipGGsU2l6XPuL9mvxANa0O0uVkDyIBHIO4Ycc19YQamg0g7mA+WvzK/Z+8dS/DrxYz3NwV0i5XbNGBkA/wtj2r691L4pRJpXmpOHhZdylTwRXl16Moydup14erF25uhynxz1Z5bh1gk5BNYfwe1J01ONJ3ySeK4Dx78QY9Qu5XYkDnGa5jwX8RxZa/Ad+FD4rmoYSpq5HqYzHUXTUIH6b6DeAaGGHPy18v/tGalJiUhscnivTPAvxGju9CT94CCnc14j8ddUi1F5PnBJzgCm/ac1oo5IKlKN6j0OM8Fa232facVa8S3Ut55KRKWkaQKoHqeB+prz3w/rB0678pmwpNfQfwD8FQ/Ez4peE9LO54GvkuJyn8McXzt/IV3LmjbmR5k4Rk/ceh+kngf4WaZY+CvD9tPEBPDp9vHJ8o+8I1B/UUV25jDktnGecZorrEWZELA96/Nn/AIKUfB6z0T4i6L8QBZyzprkAsblU4QTwglC3uyE/lX6WHivIv2oPhH/wuv4NeIvDcLBNTeIXWnSMM7LmP5o/zxtP1qkJq6Pxe1PW72G3eKzs0tExxtIBrkxqt1fB/MaOIp94vkmrV/qN1bXk1vdwvbzxSNFNC4w0TqxVlPuCCPwrJ1e3PlNKnGRzitkl0Oa/cwNSc6heBrcbJEPMq8E1fsfEGsaXu2n7VEgyd3XFZuiTBLt1Y9fWuihg8pmAGY5BjPpTdrBHUWH4sRTJ5U1uI27selGo642t2VslnJBEkLmQxD/lqx6kn6cYrzvWNPOn6yVbiNm/Sta10G52tJaNl15KDuPWs7I0OtOoSaQIZradfmGdiN88Z7g16F4J/aW1bw48dpfN/aFouABI22VR7N3/ABrxiz1NGdrS8hMVweFcjGT6UrWK3RXdgkcVhWw1KurVI3Omhi6+Hd6U2v67H234T/ae8K3sDJc3UlhIw6XEZ25/3hmo9d+JHhXxXBLFJd2VwjcHJ3KM9M8cfj1r4oOnXdrkQkuh6c1b8H6je2Gs3doD8moWktrMjHhhjcufoRkV4dbKaVOLqU21Y+iwudVqtSNKrFO+h7R4u8G+F7MtMY7ZAxyMYGa88mstCimPkW0DNngnmuct7edJtOOoTPFaTfM8jybikan5j9cdBUPjnxhD4q1jzrKyj03ToIxb2ltEuCsa9Cx7uepPvXVSoVIzVLmbVtX0X/DnPWxNKpSdfkUXdJLq+78kv19Trpdeh02LYrogHoQMVh3/AInjWGaW3fzL6RTGsv8ADAp67fVj69q4OWSR2zyfrUsKyEZc8eldqwcL+9qec8xqpe4rfp6FjyFbCoCxJwAO9TIWQ8nbjtUK3aWciOTypBAFU72/Ny5aNSgbkjPeu++p5Nro0311rIfKxJ9K9e8JfE2yl8K2unSzyJcopz5vQ5J4BrwVoifmPJNbOmsixhnPT+EUrc24bbHX+Kr+ae5dskxnoR0NZ3hZXbVEYk9c0W3iHZiL7OJI+mH5rc0pLX7Qlz5TW/PIHIq+hme2+G/HNzpOnCMSFQBjrXOeI/GpvpnaaTd9TWHe3yHTi9vIsigfwnkV53farJJK4JJ5rGEVds1m2lY19U8R4ui6HaAeK/Rv/glV4WudcsvE/ja+gIt42XSrCVxwz/emKn24U/WvzE03Q9S8UazY6ZpsDXWoX06W1tAoyXldgqj8z+Vfv/8As3fBy0+BXwa8L+CrfDzaZaj7VMBjzrl/mlf3yxI+gFVNIKWruek+UfSirOKKyOkTPaoJIi3I69qmyBSjrmgD8of+CkX7OL/D74gt8Q9JtseHvE0oF4ka4W1v8c5x0WUDI/2lI718TXl7FFbMjuAMetf0C/Fv4ZaN8Xvh9rfhHXofN03VYDE7D70LdUkQ9mVsEH2r8A/jh8LPEPwR+KWueC/EduyXtg+Y5yuEuoT/AKudPVWH5EEdq2jLSxzzjZ3OB88xagGU/LntXc6XeJLAowXY8BR3rzwZMp45zXdeEV2hWY5f19Kb2FHQyvHOkTmNJ2VVx2Hb8aTRJpUsopEfbKowjHofVTXaeJLNb3S5BjJArh/DsqpJNZy4ww4z2NJaofUluddt53H22z2yKeGAz+VZE2pMJXaJSqE5AJq3cS/M0bx7gCQVPUGqb2yMu6Fs4/gbrQlYTYHXbnbjdgVt/DmyXX/GunW8/wA0JcyTf7gHP+FcrMrocFcZr0b4DaPLea7qt4OBb2wjViOMsc/yFebmNX2OEqTvbT89D3Mjw6xOZUKbV1zJv0Wr/I7P45eDYdK0HxRfwaOdKt01C0jtQoxGYivJTvgnrXgcDRgfNnNfWv7SsU83woZgcgfY2K18jpDIR8wAHvXkcO4qeLwbnPdSt9yiup7nF+Cp4HMI0qasnFPtvKT6FkzxL0GTVea6dz8vAppdVbA596aQW4A4NfUnw9iBgZG55JqeNSq8jIp8cWCT6VKqDGBTQ2yJyT9K0rGPEeTVIRZbAq/DvVPu/lTIZagIjbNacWrSRoFXAFZCOO/B96swgE+tVcmxoNrctrlwTk8bV71ZjjXV7RrjYsc6HkL0YetYUp3Su3VUGB9a9Q/Z0+E2v/Gz4kaP4P0GFnnu333NwV+S0twf3kznsFHT1JAqHpqikr6H1n/wS7/ZwbxZ40l+KOtW+NJ0GRrfSVkXie9Iw0g9RGpx/vH2r9WoxhBk5PrXLfDL4daP8LfBGj+FtCtlt9K0uBYIQB8zEfedvVmOST711RXFZSfM7nRGKirIXdRTciipLFI4FKeg5pM5+lA60ANmjLjFfOX7ZH7IOk/tPeBkRPJsfGmko76PqbjAOeWt5SOTE+B/unBHSvpDpSMoYYPHvTvYT1P5rvGHg3VfAvivU9B1ywm0zVtPna3ubS4XDxODyD6+oI4III4Nanh5vL29q/Yz9t39iTSv2mdDOs6N5GkfETT4ttpfuNsV/GORb3BHb+6/VSe4JFfkBrfhLX/hx4nvfDviXSrnRtasX2T2d0m10PYjsynswyDW100c7i4s2LmXfbMBzkV5des9lrW8cDdXpEbGSAepFcV4jscXO/HepRTJNSsW1G2FxD/rV5+tURb+fFuKjcOo6H863vDkqmMq35VW1uAWFx5qD90/UelUuwnrqYL2jORukOF6K1fQX7M3h+OXQPEN06kk3McQwMn7np9TXhTEsoYYdD2PavqP9l0JbeAdVumRph/aJBRBkn5ABXyXE9R08uly9XFfifecEU1POoOXSMn+Fv1Knx48XaC3gO68OSTSrrZtICsPlHbkHON3rivk26UlsEgD0Fes/tBzu3xO1WED7iRIB/wGvMDabHxjc57DtXTw/hIYTAQcG/ftJ37tLbyOPi3H1MbmtVTStTbgrdot2v5mekBZuBxU8cGT6CtVdN8qLL8dzVIP5s5AHyivpD47UjkjEa8dTTFB+lWJV3uFFTi03DpTJK0MeZBzzWikXy9KhjiEf1q7GmUHFK47EBi4zSDEaljxgZq5FD5mRWz4U+G3iP4m+I7Lwz4W0qfWNb1B/Lgtbccn1Zj0VB1LHgfpRcErlXwJ4M1r4i+IdL8O+HdOm1bWtTnEVtaQj5nY+p/hUDkseAOa/cD9jz9lDSv2Yvh8LINFf+LNRCTaxqqr/rHA4hj7iJOgHc5J61z/AOxT+xZo/wCy94Z+26g0Gs+Pr+EJf6oq/u7dOv2e3zyEB6t1Y9eMCvqRflXAHFZylfQ1hC2ogAUcUA5o6igDioNRcLRTefaigBQdtGM4NFFACnHFNJwaKKAGPGJBzzXjX7RP7Kngv9pHQY7TxDbG01i2Uiw12zUC6tD6ZPDoeMo2R9KKKAPzO+Ov7K8f7OOsaXpPiXWZLx9TSR7O8sYV8qQIeQVJ3KcYODxzwa+ZvGml/YmKMQWPPFFFcVDnjiJQcm152/yO/ExpywsJqCTvbS+v4nN6XOYZcA1sXaC8tyrc5FFFeozx4nOTW726FC3GeK+sv2UF3/DfV8dV1Jh/44KKK+N4s/5Fj/xR/M/QeBX/AMLMf8MvyPJv2iNNEfxb1k9AwhPHulef29jHE5IXn1NFFezlDf8AZ2Hf9yP5I+ez5WzbFL+/L82ZuuXwUeWKg0+0HlFz1NFFeyfPdT0L4X/BO7+J9vf3cGrW2mx2kqxMs8TuWJBORj6VZ1LwPpPw6+JNjpHiW9Op6KpSS7mskaNthB4APOQcUUV8LSzDFYjOa+AlO1NLS1k1otb2v1P0Crl2Ew+RYfMY071HJXu207N6NXtbRXOu8Z/Dj4f6x8M9Q8VeB5tSB0+7jgnS/JwQxHAB+oOa8WkUxA0UV7WU88VXozm58k2k5O7tyxer+Z4mcqnL6vXhBQc6abUVZX5pLReiR6z+zF+zj4q/aY8aTaJ4cNra2tmQ2o6leSAJaoe4TO6RvQAY9SK/Zn9nb9l/wb+zf4aOneHbU3OqXCj7frd0oN1dn0JH3U9EXgUUV7knqeDBaXPX/LC9OlGecUUVBY4HFGAfrRRQAmT60UUUAf/Z';

void main() {
  runApp(const AlloMaghniaApp());
}

class AlloMaghniaApp extends StatelessWidget {
  const AlloMaghniaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allo Maghnia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// MODÈLES PARTAGÉS
// ---------------------------------------------------------------------------

class LivreurInfo {
  final String nom;
  final String prenom;
  final String? photoUrl;

  const LivreurInfo({
    required this.nom,
    required this.prenom,
    this.photoUrl,
  });
}

/// Commande de test partagée entre l'écran Client et l'écran Livreur.
/// En attendant que le backend gère la persistance de l'option domicile et
/// de l'adresse, cette instance unique simule la synchronisation entre les
/// deux écrans pendant une session de test sur le téléphone.
class CommandeTest {
  double fraisLivraisonDomicile = 0;
  double? latitude;
  double? longitude;
  String remarqueLivraison = '';
  int orderId;
  String codeTransaction;
  double totalDinars;
  double soldeInitial;
  LivreurInfo livreur;
  String adresse;

  bool livraisonADomicile;

  CommandeTest({
    required this.orderId,
    required this.codeTransaction,
    required this.totalDinars,
    required this.soldeInitial,
    required this.livreur,
    required this.adresse,
    this.livraisonADomicile = false,
  });

  double get soldeAffiche => soldeInitial;
}

// Instance unique de test : commande #1, client Mustapha, livreur Ahmed.
final CommandeTest commandeDeTest = CommandeTest(
  // 0 = aucune commande réelle créée dans cette session.
  orderId: 0,
  codeTransaction: '',
  totalDinars: 1500.0,
  soldeInitial: 3500.0,
  adresse: 'Cité 100 Logements, Bloc C, Maghnia',
  livreur: const LivreurInfo(
    nom: 'Benali',
    prenom: 'Ahmed',
    photoUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
  ),
);

// ---------------------------------------------------------------------------
// ÉCRAN D'ACCUEIL (MENU DE TEST)
// ---------------------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSeeding = false;

  Future<void> _initialiserDonneesTest() async {
    setState(() => _isSeeding = true);

    try {
      final response = await http
          .post(Uri.parse('$kApiBaseUrl/init-test-data'))
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        if (mounted) {
          _afficherPopup(
            titre: 'Succès',
            message: 'Données injectées avec succès sur Railway !',
            couleurIcone: Colors.green,
            icone: Icons.check_circle,
          );
        }
      } else {
        if (mounted) {
          _afficherPopup(
            titre: 'Erreur',
            message: data['detail']?.toString() ??
                data['erreur']?.toString() ??
                "Le serveur a répondu une erreur.",
            couleurIcone: Colors.red,
            icone: Icons.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _afficherPopup(
          titre: 'Réseau instable',
          message: "Impossible de contacter le serveur Railway. Vérifiez l'URL et votre connexion.",
          couleurIcone: Colors.orange,
          icone: Icons.wifi_off,
        );
      }
    } finally {
      if (mounted) setState(() => _isSeeding = false);
    }
  }

  void _afficherPopup({
    required String titre,
    required String message,
    required Color couleurIcone,
    required IconData icone,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(icone, color: couleurIcone, size: 48),
        title: Text(titre, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allo Maghnia — Menu de test'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Icon(Icons.delivery_dining, size: 72, color: Colors.orange),
            const SizedBox(height: 12),
            const Text(
              'Allo Maghnia',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),

            _buildBoutonMenu(
              context,
              label: 'Espace Commerçant',
              icon: Icons.store,
              couleur: Colors.green.shade700,
              destination: const CommercantScreen(),
            ),
            const SizedBox(height: 16),
            _buildBoutonMenu(
              context,
              label: 'Espace Livreur',
              icon: Icons.two_wheeler,
              couleur: Colors.blue.shade800,
              destination: LivreurScreen(commande: commandeDeTest),
            ),
            const SizedBox(height: 16),
            _buildBoutonMenu(
              context,
              label: 'Espace Client',
              icon: Icons.person,
              couleur: Colors.deepOrange.shade600,
              destination: ClientScreen(commande: commandeDeTest),
            ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 16),

            // Bouton discret pour initialiser les profils de test sur Railway
            TextButton.icon(
              onPressed: _isSeeding ? null : _initialiserDonneesTest,
              icon: _isSeeding
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload, size: 18),
              label: Text(_isSeeding ? 'Initialisation en cours...' : 'Initialiser les profils de test (Seed)'),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoutonMenu(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color couleur,
    required Widget destination,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
        style: ElevatedButton.styleFrom(backgroundColor: couleur),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ÉCRAN COMMERÇANT
// ---------------------------------------------------------------------------

class CommercantScreen extends StatefulWidget {
  const CommercantScreen({super.key});

  @override
  State<CommercantScreen> createState() => _CommercantScreenState();
}

class _CommercantScreenState extends State<CommercantScreen> {
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _tarifLivraisonController = TextEditingController();

  int? _commercantTestId;
  double _tarifLivraisonDomicile = 0;
  bool _isSavingTarif = false;

  bool _isLoading = false;
  String? _messageSucces;
  String? _messageErreur;

  @override
  void initState() {
    super.initState();
    _chargerTarifLivraison();
  }

  @override
  void dispose() {
    _telephoneController.dispose();
    _montantController.dispose();
    _tarifLivraisonController.dispose();
    super.dispose();
  }

  Future<void> _chargerTarifLivraison() async {
    try {
      if (_commercantTestId == null) {
        final seedResponse = await http
            .post(Uri.parse('$kApiBaseUrl/init-test-data'))
            .timeout(const Duration(seconds: 15));
        final seedData = jsonDecode(seedResponse.body) as Map<String, dynamic>;
        if (seedResponse.statusCode != 200 || seedData['success'] != true) return;

        for (final utilisateur in (seedData['utilisateurs'] as List<dynamic>)) {
          if (utilisateur['telephone']?.toString() == '0550112233') {
            _commercantTestId = (utilisateur['id'] as num).toInt();
            break;
          }
        }
      }

      if (_commercantTestId == null) return;

      final response = await http
          .get(Uri.parse('$kApiBaseUrl/boutique/tarif/$_commercantTestId'))
          .timeout(const Duration(seconds: 15));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && data['success'] == true && mounted) {
        final tarif = (data['tarif_livraison_domicile'] as num?)?.toDouble() ?? 0;
        setState(() {
          _tarifLivraisonDomicile = tarif;
          _tarifLivraisonController.text = tarif.toStringAsFixed(0);
        });
      }
    } catch (_) {
      // Le chargement du tarif n'empêche pas l'espace commerçant de fonctionner.
    }
  }

  Future<void> _enregistrerTarifLivraison() async {
    final tarif = double.tryParse(_tarifLivraisonController.text.trim());
    if (tarif == null || tarif < 0) {
      setState(() => _messageErreur = "Tarif de livraison invalide.");
      return;
    }

    if (_commercantTestId == null) {
      await _chargerTarifLivraison();
    }
    if (_commercantTestId == null) {
      setState(() => _messageErreur = "Boutique de test introuvable.");
      return;
    }

    setState(() {
      _isSavingTarif = true;
      _messageErreur = null;
      _messageSucces = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$kApiBaseUrl/boutique/tarif'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'commercant_id': _commercantTestId,
              'tarif_livraison_domicile': tarif,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && data['success'] == true) {
        setState(() {
          _tarifLivraisonDomicile = tarif;
          _messageSucces = "Tarif de livraison à domicile enregistré : ${tarif.toStringAsFixed(0)} DA";
        });
      } else {
        setState(() {
          _messageErreur = data['detail']?.toString() ?? "Impossible d'enregistrer le tarif.";
        });
      }
    } catch (_) {
      setState(() {
        _messageErreur = "Impossible de contacter le serveur. Vérifiez votre connexion.";
      });
    } finally {
      if (mounted) setState(() => _isSavingTarif = false);
    }
  }

  Future<void> _rechargerClient() async {
    final String telephone = _telephoneController.text.trim();
    final String montantTexte = _montantController.text.trim();

    setState(() {
      _messageSucces = null;
      _messageErreur = null;
    });

    if (telephone.isEmpty) {
      setState(() => _messageErreur = "Veuillez entrer le numéro de téléphone du client.");
      return;
    }

    final double? montant = double.tryParse(montantTexte);
    if (montant == null || montant <= 0) {
      setState(() => _messageErreur = "Montant invalide. Entrez un nombre supérieur à 0.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$kApiBaseUrl/recharge'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telephone_client': telephone,
          'montant': montant,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        setState(() {
          _messageSucces =
              "Recharge réussie ! Nouveau solde du client : ${data['nouveau_solde']} DA";
          _telephoneController.clear();
          _montantController.clear();
        });
      } else {
        setState(() {
          _messageErreur = data['detail']?.toString() ??
              data['erreur']?.toString() ??
              "Une erreur est survenue lors de la recharge.";
        });
      }
    } catch (e) {
      setState(() {
        _messageErreur =
            "Impossible de contacter le serveur. Vérifiez votre connexion 3G/4G et réessayez.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Commerçant'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Tarif de livraison à domicile de la boutique',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tarif actuel : ${_tarifLivraisonDomicile.toStringAsFixed(0)} DA',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _tarifLivraisonController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Tarif domicile (DA)',
                      hintText: 'Ex : 300',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_shipping),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isSavingTarif ? null : _enregistrerTarifLivraison,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isSavingTarif
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Enregistrer le tarif',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Recharger le solde d'un client",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _telephoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Téléphone du client',
                hintText: 'Ex : 0770778899',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _montantController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Montant à créditer au client (DA)',
                hintText: 'Ex : 2000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _rechargerClient,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green.shade700,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Confirmer la recharge', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 24),
            if (_messageSucces != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_messageSucces!, style: TextStyle(color: Colors.green.shade800)),
              ),
            if (_messageErreur != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_messageErreur!, style: TextStyle(color: Colors.red.shade800)),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ÉCRAN LIVREUR
// ---------------------------------------------------------------------------

class LivreurScreen extends StatefulWidget {
  final CommandeTest commande;

  const LivreurScreen({super.key, required this.commande});

  @override
  State<LivreurScreen> createState() => _LivreurScreenState();
}

class _LivreurScreenState extends State<LivreurScreen> {
  final TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  String? _messageErreur;
  bool _commandeDejaLivree = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _ouvrirItineraire() async {
    if (widget.commande.latitude == null || widget.commande.longitude == null) {
      setState(() {
        _messageErreur = "La position GPS du client n'est pas disponible.";
      });
      return;
    }

    final Uri uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${widget.commande.latitude},${widget.commande.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      setState(() => _messageErreur = "Impossible d'ouvrir l'application GPS.");
    }
  }

  Future<void> _validerLivraison() async {
    final String code = _codeController.text.trim();

    setState(() => _messageErreur = null);

    if (code.length != 4 || int.tryParse(code) == null) {
      setState(() => _messageErreur = "Entrez le code à 4 chiffres donné par le client.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http
          .post(
            Uri.parse('$kApiBaseUrl/order/validate'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'order_id': widget.commande.orderId,
              'code_saisi': code,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        setState(() => _commandeDejaLivree = true);
        if (mounted) _afficherPopupSucces();
      } else {
        setState(() {
          _messageErreur = data['detail']?.toString() ??
              data['erreur']?.toString() ??
              "Code incorrect ou commande introuvable.";
        });
      }
    } on TimeoutException {
      setState(() {
        _messageErreur = "Réseau instable. Le code sera validé dès le retour de la connexion.";
      });
    } catch (e) {
      setState(() {
        _messageErreur = "Réseau instable. Le code sera validé dès le retour de la connexion.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _afficherPopupSucces() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text(
          'Livraison validée !',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Paiement débloqué.', textAlign: TextAlign.center),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool domicile = widget.commande.livraisonADomicile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma livraison'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Commande #${widget.commande.orderId}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Total : ${widget.commande.totalDinars.toStringAsFixed(0)} DA',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade800)),
                  const SizedBox(height: 14),

                  // Bloc conditionnel : domicile (adresse visible) ou point relais (adresse masquée)
                  if (domicile) ...[
                    Row(
                      children: [
                        Icon(Icons.home, color: Colors.blue.shade800, size: 18),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text('Livraison à domicile', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.commande.latitude != null && widget.commande.longitude != null
                          ? 'Position GPS exacte enregistrée'
                          : 'Position GPS indisponible',
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                    if (widget.commande.adresse.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Indication : ${widget.commande.adresse}',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _ouvrirItineraire,
                        icon: const Icon(Icons.map),
                        label: const Text("Ouvrir l'itinéraire GPS"),
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Icon(Icons.storefront, color: Colors.grey.shade700, size: 18),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text('Déposer le colis au Point Relais de Maghnia'),
                        ),
                      ],
                    ),
                  ],

                  if (_commandeDejaLivree) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 6),
                        Text('Livrée', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Demandez le code au client devant la porte :',
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _codeController,
              enabled: !_commandeDejaLivree,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, letterSpacing: 12, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                counterText: '',
                border: OutlineInputBorder(),
                hintText: '0000',
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: (_isLoading || _commandeDejaLivree) ? null : _validerLivraison,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  disabledBackgroundColor: Colors.blue.shade200,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : Text(
                        _commandeDejaLivree ? 'LIVRAISON CLÔTURÉE' : 'VALIDER ET CLÔTURER LA LIVRAISON',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),

            const SizedBox(height: 20),

            if (_messageErreur != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _messageErreur!,
                  style: TextStyle(color: Colors.orange.shade900),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ÉCRAN CLIENT
// ---------------------------------------------------------------------------

class ClientScreen extends StatefulWidget {
  final CommandeTest commande;

  const ClientScreen({super.key, required this.commande});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  bool _isLoading = false;
  bool _isCreatingCommande = false;
  bool _commandeLivree = false;
  String? _messageErreur;
  double _tarifBoutique = 0;
  final TextEditingController _adresseManuelleController = TextEditingController();
  final TextEditingController _remarqueController = TextEditingController();
  double? _latitude;
  double? _longitude;
  bool _positionObtenue = false;

  @override
  void initState() {
    super.initState();
    _initialiserClient();
  }

  Future<void> _initialiserClient() async {
    setState(() => _isCreatingCommande = true);
    try {
      final seedResponse = await http
          .post(Uri.parse('$kApiBaseUrl/init-test-data'))
          .timeout(const Duration(seconds: 15));
      final seedData = jsonDecode(seedResponse.body) as Map<String, dynamic>;
      if (seedResponse.statusCode != 200 || seedData['success'] != true) {
        throw Exception('Impossible d’initialiser les profils de test.');
      }

      final utilisateurs = seedData['utilisateurs'] as List<dynamic>;
      int? clientId;
      for (final utilisateur in utilisateurs) {
        if (utilisateur['telephone']?.toString() == '0770778899') {
          clientId = (utilisateur['id'] as num).toInt();
          break;
        }
      }
      if (clientId == null) {
        throw Exception('Profil client introuvable.');
      }

      final tarifResponse = await http
          .get(Uri.parse('$kApiBaseUrl/boutique/tarif/1'))
          .timeout(const Duration(seconds: 15));
      final tarifData = jsonDecode(tarifResponse.body) as Map<String, dynamic>;
      if (tarifResponse.statusCode == 200 && tarifData['success'] == true) {
        _tarifBoutique = (tarifData['tarif_livraison_domicile'] as num?)?.toDouble() ?? 0;
      }

      final latestResponse = await http
          .get(Uri.parse('$kApiBaseUrl/order/latest/$clientId'))
          .timeout(const Duration(seconds: 15));
      final latestData = jsonDecode(latestResponse.body) as Map<String, dynamic>;

      if (latestResponse.statusCode == 200 &&
          latestData['success'] == true &&
          latestData['found'] == true) {
        final livreur = latestData['livreur'] as Map<String, dynamic>;
        setState(() {
          widget.commande.orderId = (latestData['order_id'] as num).toInt();
          widget.commande.codeTransaction = latestData['code_transaction'].toString();
          widget.commande.totalDinars = (latestData['total_dinars'] as num).toDouble();
          widget.commande.fraisLivraisonDomicile =
              (latestData['frais_livraison_domicile'] as num?)?.toDouble() ?? 0;
          widget.commande.latitude = (latestData['latitude'] as num?)?.toDouble();
          widget.commande.longitude = (latestData['longitude'] as num?)?.toDouble();
          _latitude = widget.commande.latitude;
          _longitude = widget.commande.longitude;
          _positionObtenue = _latitude != null && _longitude != null;
          _adresseManuelleController.text =
              latestData['adresse_texte']?.toString() ?? '';
          _remarqueController.text =
              latestData['remarque_livraison']?.toString() ?? '';
          widget.commande.remarqueLivraison =
              latestData['remarque_livraison']?.toString() ?? '';
          widget.commande.livraisonADomicile = latestData['livraison_domicile'] == true;
          widget.commande.adresse = latestData['adresse_texte']?.toString() ?? '';
          widget.commande.livreur = LivreurInfo(
            nom: livreur['nom']?.toString() ?? 'Benali',
            prenom: livreur['prenom']?.toString() ?? 'Ahmed',
            photoUrl: livreur['photo_url']?.toString(),
          );
          _isCreatingCommande = false;
        });
        commandeDeTest.orderId = widget.commande.orderId;
        commandeDeTest.codeTransaction = widget.commande.codeTransaction;
        commandeDeTest.totalDinars = widget.commande.totalDinars;
        commandeDeTest.fraisLivraisonDomicile = widget.commande.fraisLivraisonDomicile;
        commandeDeTest.latitude = widget.commande.latitude;
        commandeDeTest.longitude = widget.commande.longitude;
        commandeDeTest.livreur = widget.commande.livreur;
        commandeDeTest.livraisonADomicile = widget.commande.livraisonADomicile;
        await _actualiserStatut();
        return;
      }

      setState(() {
        _isCreatingCommande = false;
        _messageErreur = null;
      });
    } catch (e) {
      setState(() {
        _isCreatingCommande = false;
        _messageErreur = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _obtenirPositionGPS() async {
    setState(() {
      _messageErreur = null;
      _positionObtenue = false;
    });

    try {
      final serviceActive = await Geolocator.isLocationServiceEnabled();
      if (!serviceActive) {
        throw Exception('Activez la localisation sur votre téléphone puis réessayez.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Autorisation de localisation refusée.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Autorisation de localisation bloquée. Activez-la dans les réglages du téléphone.');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final double latitude = position.latitude;
      final double longitude = position.longitude;

      setState(() {
        _latitude = latitude;
        _longitude = longitude;
        _positionObtenue = true;
        widget.commande.latitude = latitude;
        widget.commande.longitude = longitude;
      });
    } catch (e) {
      setState(() {
        _messageErreur = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _creerCommandeReelle() async {
    if (widget.commande.livraisonADomicile &&
        (_latitude == null || _longitude == null)) {
      await _obtenirPositionGPS();
      if (_latitude == null || _longitude == null) return;
    }

    setState(() {
      _isCreatingCommande = true;
      _messageErreur = null;
    });

    try {
      final seedResponse = await http
          .post(Uri.parse('$kApiBaseUrl/init-test-data'))
          .timeout(const Duration(seconds: 15));
      final seedData = jsonDecode(seedResponse.body) as Map<String, dynamic>;
      if (seedResponse.statusCode != 200 || seedData['success'] != true) {
        throw Exception('Impossible d’initialiser les profils de test.');
      }

      int? clientId;
      int? livreurId;
      for (final utilisateur in (seedData['utilisateurs'] as List<dynamic>)) {
        final telephone = utilisateur['telephone']?.toString();
        final id = (utilisateur['id'] as num?)?.toInt();
        if (telephone == '0770778899') clientId = id;
        if (telephone == '0660445566') livreurId = id;
      }
      if (clientId == null || livreurId == null) {
        throw Exception('Profils client/livreur introuvables.');
      }

      final createResponse = await http
          .post(
            Uri.parse('$kApiBaseUrl/order/create'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'client_id': clientId,
              'livreur_id': livreurId,
              'commercant_id': 1,
              'total_dinars': 1500,
              'livraison_domicile': widget.commande.livraisonADomicile,
              'adresse_texte': widget.commande.livraisonADomicile
                  ? (_adresseManuelleController.text.trim().isEmpty
                      ? null
                      : _adresseManuelleController.text.trim())
                  : null,
              'latitude': widget.commande.livraisonADomicile ? _latitude : null,
              'longitude': widget.commande.livraisonADomicile ? _longitude : null,
              'remarque_livraison': widget.commande.livraisonADomicile
                  ? (_remarqueController.text.trim().isEmpty
                      ? null
                      : _remarqueController.text.trim())
                  : null,
              'frais_livraison_domicile': widget.commande.livraisonADomicile
                  ? _tarifBoutique
                  : 0,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(createResponse.body) as Map<String, dynamic>;
      if (createResponse.statusCode != 200 || data['success'] != true) {
        throw Exception(
          data['detail']?.toString() ??
              data['erreur']?.toString() ??
              'Impossible de créer la commande.',
        );
      }

      final livreur = data['livreur'] as Map<String, dynamic>;
      setState(() {
        widget.commande.orderId = (data['order_id'] as num).toInt();
        widget.commande.codeTransaction = data['code_transaction'].toString();
        widget.commande.totalDinars = (data['total_dinars'] as num).toDouble();
        widget.commande.soldeInitial = (data['solde_restant'] as num).toDouble();
        widget.commande.fraisLivraisonDomicile =
            (data['frais_livraison_domicile'] as num?)?.toDouble() ?? 0;
        widget.commande.latitude = (data['latitude'] as num?)?.toDouble();
        widget.commande.longitude = (data['longitude'] as num?)?.toDouble();
        widget.commande.livreur = LivreurInfo(
          nom: livreur['nom']?.toString() ?? 'Benali',
          prenom: livreur['prenom']?.toString() ?? 'Ahmed',
          photoUrl: livreur['photo_url']?.toString(),
        );
        _isCreatingCommande = false;
      });
      commandeDeTest.orderId = widget.commande.orderId;
      commandeDeTest.codeTransaction = widget.commande.codeTransaction;
      commandeDeTest.totalDinars = widget.commande.totalDinars;
      commandeDeTest.soldeInitial = widget.commande.soldeInitial;
      commandeDeTest.fraisLivraisonDomicile = widget.commande.fraisLivraisonDomicile;
      commandeDeTest.latitude = widget.commande.latitude;
      commandeDeTest.longitude = widget.commande.longitude;
      commandeDeTest.livreur = widget.commande.livreur;
      commandeDeTest.livraisonADomicile = widget.commande.livraisonADomicile;
    } catch (e) {
      setState(() {
        _isCreatingCommande = false;
        _messageErreur = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _actualiserStatut() async {
    setState(() {
      _isLoading = true;
      _messageErreur = null;
    });

    try {
      final response = await http
          .get(Uri.parse('$kApiBaseUrl/order/status/${widget.commande.orderId}'))
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        setState(() {
          _commandeLivree = data['statut'] == 'livree';
        });
      } else {
        setState(() {
          _messageErreur = data['detail']?.toString() ?? "Impossible de vérifier le statut.";
        });
      }
    } catch (e) {
      setState(() {
        _messageErreur = "Réseau instable. Réessayez dans un instant.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onToggleDomicile(bool value) {
    setState(() {
      widget.commande.livraisonADomicile = value;
      if (!value) {
        _latitude = null;
        _longitude = null;
        _positionObtenue = false;
        widget.commande.latitude = null;
        widget.commande.longitude = null;
        _adresseManuelleController.clear();
        _remarqueController.clear();
      }
    });
  }

  @override
  void dispose() {
    _adresseManuelleController.dispose();
    _remarqueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commande = widget.commande;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Ma commande'),
        backgroundColor: Colors.deepOrange.shade600,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (_isCreatingCommande)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        'Création de la commande réelle...',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Mon Solde : ${commande.soldeAffiche.toStringAsFixed(0)} DA',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 20),

              // Interrupteur "Livraison à domicile"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Activer la livraison à domicile'),
                        value: commande.livraisonADomicile,
                        onChanged: (_commandeLivree || _isCreatingCommande) ? null : _onToggleDomicile,
                        activeThumbColor: Colors.deepOrange.shade600,
                      ),
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          commande.livraisonADomicile ? Icons.home : Icons.storefront,
                          size: 18,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            commande.livraisonADomicile
                                ? 'Livraison à domicile — ${_tarifBoutique.toStringAsFixed(0)} DA'
                                : 'À récupérer au Point Relais',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (commande.livraisonADomicile) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _obtenirPositionGPS,
                          icon: Icon(
                            _positionObtenue ? Icons.check_circle : Icons.my_location,
                          ),
                          label: Text(
                            _positionObtenue
                                ? 'Position GPS enregistrée'
                                : 'Partager ma position GPS',
                          ),
                        ),
                      ),
                      if (_positionObtenue) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Le livreur recevra votre position exacte sur la carte.',
                          style: TextStyle(color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 12),
                      TextField(
                        controller: _adresseManuelleController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Adresse / indication (facultatif)',
                          hintText: 'Ex. près de la mosquée, maison portail noir...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.home),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _remarqueController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Remarque pour le livreur (facultatif)',
                          hintText: 'Ex. appelle-moi en arrivant, 2e étage...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.note_alt),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              if (!_isCreatingCommande && commande.orderId == 0) ...[
                const SizedBox(height: 8),
                Text(
                  'Commande : 1500 DA${commande.livraisonADomicile ? ' + ${_tarifBoutique.toStringAsFixed(0)} DA de livraison' : ''}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _creerCommandeReelle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Confirmer la commande',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],

              if (!_isCreatingCommande && commande.orderId > 0) ...[
                _commandeLivree ? _buildBlocLivree() : _buildBlocCode(commande),

                const SizedBox(height: 24),

                _buildCarteLivreur(commande.livreur),
              ],

              const SizedBox(height: 16),

              TextButton.icon(
                onPressed: (_isLoading || _isCreatingCommande) ? null : _actualiserStatut,
                icon: _isLoading
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh),
                label: const Text('Actualiser le statut'),
              ),

              if (_messageErreur != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _messageErreur!,
                    style: const TextStyle(color: Colors.orange, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlocCode(CommandeTest commande) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Commande #${commande.orderId} — ${commande.totalDinars.toStringAsFixed(0)} DA',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 16),
        Text(
          commande.codeTransaction.split('').join(' '),
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Text(
            'Donnez ce code au livreur UNIQUEMENT devant votre porte',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildBlocLivree() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: Colors.green.shade600, size: 80),
        const SizedBox(height: 20),
        Text(
          'Commande Livrée !\nBon appétit',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green.shade700),
        ),
      ],
    );
  }

  // Avatar avec repli propre si l'image réseau échoue à charger
  // (ex: environnement sandbox comme DartPad qui bloque certaines requêtes).
  Widget _buildAvatarLivreur(String? photoUrl) {
    const double taille = 56;

    Widget fallback() => Container(
          width: taille,
          height: taille,
          color: Colors.blue.shade100,
          child: Icon(
            Icons.person,
            size: 32,
            color: Colors.blue.shade800,
          ),
        );

    return ClipOval(
      child: Image.memory(
        base64Decode(kAhmedBenaliPhotoBase64),
        width: taille,
        height: taille,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback(),
      ),
    );
  }

  Widget _buildCarteLivreur(LivreurInfo livreur) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _buildAvatarLivreur(livreur.photoUrl),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Votre Livreur', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(
                  '${livreur.prenom} ${livreur.nom}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
