From: Jay Schulist <jschlst@linux-sna.org>
Subject: [PATCH] associate user defined name with rule match
Date: Tue, 17 Sep 2002 22:48:04 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44L.0209172244330.10390-102000@hunger.screamingdaemon.com>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="-1463811839-1663971492-1032326430=:10390"
Cc: netfilter-devel@lists.netfilter.org,
	<netfilter@lists.netfilter.org>, Jay Schulist <jschlst@linux-sna.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-ID: <Pine.LNX.4.44L.0209172244331.10390@hunger.screamingdaemon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-1663971492-1032326430=:10390
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.44L.0209172244332.10390@hunger.screamingdaemon.com>

Hello Harald,
Here is a new match which allows the user to associate a name with a rule.
It is a very simple match, but it is useful if the user needs an easy way
to track a rule by name.

Iptables userspace patch is against a clean iptables-1.2.7a
Kernel patch is against a clean linux-2.4.19

name v1.2.7a options:
 --n name                       name to associate with rule

Thanks,
jay-s.

---1463811839-1663971492-1032326430=:10390
Content-Type: APPLICATION/octet-stream; name="linux-2.4.19-name-match-2002091811.diff.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L.0209172248040.10390@hunger.screamingdaemon.com>
Content-Description: 
Content-Disposition: attachment; filename="linux-2.4.19-name-match-2002091811.diff.gz"

H4sICO4SiD0CA2xpbnV4LTIuNC4xOS1uYW1lLW1hdGNoLTIwMDIwOTE4MTEu
ZGlmZgClV3tz2jgQ/7t8ii3ptIB5N03zaDPhKCHpETdTnLmb6XU8wpaxipE9
spyWy+S730o25hVIcmXAI6/28dO+tLjM86AmEhMCxpNftXZ9v946qjkBJbzB
uBMkLm3orQan0mOBpMJm0e1+g0XS5mRK6/6K6FOFCrVa7TdsvviLuvCJOvC2
Ba2j42YTv7g4OCoYhvG/AGmNQxpB6xCareP24XHrCNrNZrtwdga1ZrUJRqt6
CGdnBWOPedylHtiX15Ztdq569gUSkcI4XSNmxuHDFuu2JKOAxnX/tGAUjFiK
xJEwBwV3BeOF4xMB6u2bUnx+Y3atyy+mfdX5WxkZ9MzvJwXjHn97lLvMg0Zl
GQJUGgV3V4wRUUNjyaE1uiH32LjO+Kofd3Fui+YumRfngkEnGQO00c/Hb4+O
9w9Sh2+EcKeatbhhMhwu4tZ+Vz0AA5/vVeQAwKXoc8FiSSSFNwDowL51AVMi
HR/iJIpCId9A94t5ftlHP9rmObra6l7YGeOrlS10dOePQW/4kGbLGjxBreJ6
uk7pRNM4fora7vXVcLhNs7Gp2VT59rhelVU78GL+fYPi6j6+mNbXTvfPIrz8
CEVehO8nIH3KlcAmEAwsp45kIYeU9jioodWx1lHlVregBWXdY88ujisywToP
6KMJOmd8RmnMRX6vMnItG4XRXiqMg7YqDHymhRGOftRelbb5tgzGR92VdETq
4Q5+7E+DXsfMJRKuj7tTJk3WXCRNcpQwtkqoNMz5df9G/QXYA0nEmMr4QWNW
52u/Z9lfe597XSuXTl9R/rmZkJt2Hg3JgvUZ2bAQesZl97ieRUa8fXf8rrlx
xb3f13ccXiMLwWO11hdVVo0yBBLHocNUgRJ9PcFPJn1ciySgdewwFfXDao5m
go19CSWnrG3BaAafyQyGjp8EWPbw4Ufs+EEsz2IyHZF6KManubjlsxgiEY4F
mYJDOIwoCOqimGCjROJxQgHTEEPHcJ3grSxUawE89zSG0FMvWlHfvIE+5VSQ
AK6TUcAcGDCH8hjhowVFiX1UgeCU/LmgFIahJ38SgW8haiaqJdU3UeFyGY/y
QphIIHwGKCwIlzMFkk2jQGGc07QiBDilAm94jt5lAUtZPSY5xS7v4ZpARIRk
ThLgFBAlIgrjJe8OEaWCu+N0nnYQHsKlkrAg1sINNWyszyboRhU6NYmsb8lZ
lM0o6zuJGz1IjyejxPMe3MLMdOktwsuGnkdnpPmEdvrseerqy6ebQc8eXHZ7
5rBXKvavB8XySWrUg+ZiaHOTSDAuvRK6CzO8CthG4nq9XgZNn2R0qMLent4r
q3kriOkTVMwns3TAwzRyAPkKhq6kkhNyrIFs8IsntnIbVNB9VVjZwpPaqdug
wnhVXeHqs5UHc3Cu4TZkLlS0Oca9MJdFFJiBXkzXOH1XVCGxcbt1YEvAzCcB
5StiFT+UrggjPNzdnI6FKRPBoXWSvWMLSbsF1oJE0+O6zrx75Qjc65IgUAWB
kwAksSpcwbDBYGthmLhClRBQLsUsrWOsM5WGqY5lPzo+dSaaMXOmnpgrOhFU
4uTAN/ylUotF6M9ohWebv9Qn4TEbc4StvKBZYvYv3c7ih+HEnpJ4suIpTL5S
LqymIjWwdwaXfbOkKKFXWvsnUC6X4W7ZiP5kuVlk/JYEiFnJvvyH6xRfY81i
01zs3G/GLYtN5twlCGkYFZBs+XEJzR2YN4NBVT/hvgr5RlEJFJcIr7XwMmER
uyVqqi5/tS4uh3ZayZD+01mOP9iYqAxh4qOkIvdQSqozCDrGNo2dIq2714vT
lNcOruNv2/QXqsXSZptq08HmCRrTnqoRltRDbWQ0pb6k1CPtP74W9yqGDwAA

---1463811839-1663971492-1032326430=:10390
Content-Type: APPLICATION/octet-stream; name="iptables-1.2.7a-name-match-2002091811.diff.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L.0209172248041.10390@hunger.screamingdaemon.com>
Content-Description: 
Content-Disposition: attachment; filename="iptables-1.2.7a-name-match-2002091811.diff.gz"

H4sICMERiD0CA2lwdGFibGVzLTEuMi43YS1uYW1lLW1hdGNoLTIwMDIwOTE4
MTEuZGlmZgCdVuFy2kYQ/i09xZZMEkACg+2SGNcZExtnaDB2ATedSTrMWTrg
Bumk0Z2waep37+4JYQx2Q8sY3+m0u7f77be7+GI8hkqS9kDEmt0GXFXq1f3q
O1bxAs7kHr/XXCoRSbV3yWZ8LAK+KfmcjF2pVHa3aF0kAlrpBOAIagfNw8Nm
vQb7tdq+7TjOLtdZX7gPAx5D/T3U6s39RvPnRmbg9BQqB24DnAP3CE5Pbbi+
GLX/GI4G3c7H5gmbghdJqRPmzcBXXgzck8BVDFMexDwB4YUxBFxO9BQCEQoN
IfPwm8wgTAMt4ijREN1JFI1nWi9iDkoz6bPEp43moNEofkOlQEf41QGkfgyp
NGjAea81hPPB2TW0z3rQvfoEl63+Z/w3+O2m3W+dt+Gy0+9f9aHfPu/022dD
3PxKy6B12YYBaQ/Pri8HAxheDeAGDVCIjbUYeSoahyaQeWPHUFYhkPPkbe6X
DbbzCnVmHCQLOcRMewghRRIsQIwh0lOCgo65AhbHgeB+1XbWUHdOSNV2bHgF
wymHcRQE0Z2QE7S7ABlpuEXDCVdcahduU40pCmPiHdoOgcnFHVtUnyTSORkO
u8gTExb66O9O6kDcosyIXKp6/0a1J4K70fuJiqHoOffgoA71o2athn+4aRz9
iOPbVtaI/q558P6R6DW3Bk7drdfeE9WdvTIMpixBDbSRsGQBzPcrkUQiri6k
PZ5m6VRpTCyoQnkP8yyQoqnP4RelfRFVpx/WzyTX/u3GmdIJpnHr0MfbNw4n
XEex3jjMXdo4DoRM7/fwPix0zZORiOeHeytESBalfWwDksN5++PNJ6jREQZ/
gUWmEUO4mwqkaYzeaQURMipVbMIh5IrWLFyqVuHBPBK+7VD1F2lbsp3vtmMZ
1XHRdgoGp/lrNBOTadX8Jgt4DJWKNBhalmVECFalIk9QD7gTWHNJGnAUdm2n
cz1sfey2B6Pf2/1B56pXOradB/J56QPimHp6eQMt6uufcALkyHcooAmou1Bz
4W39LTy4dFpD9YfjZdgdKbRggfjLVAxWFRbjMzEKFCsuryI4sdySxchIQzl0
sUMpMZFIHgwdynLsMazpJR5raibacijkOEIfi1tvSmHlg880Q++skIeK66IR
NhEodDIabyqVCBArvxL+PoHexdnopve5d/WlR68SrtNE5qg9k2mWKKQ29o0Q
G1meqmPI9JDzScqpW2GzcACAUsRkjvcaUBi57RhjRQLBc8HDeoJymSWTuWuA
EXLOE72J1jhgE+Ua4/jBEaM0bEINZbO8APRK+aUMlc36P/JRXGqu0kL6yFA0
WvRKhmWWxxQnejXpgax78SJLW+UDmXGBEPhKiEm/Uv/TJMyysrjx2nr2fJtw
NstusLBCGY6ZzGKWCKiR2MMqoUZtlVIhWYB4c292jAOKAIy5J8YLUFHI9ZQ6
zTapx6Q1MlrFJ7gaz5ZoYeaLP+UHlsXvBWKbJFFSvG71cawO2/3Rdf8KS/TS
hazi+T1ejs1jRZNC6VkiXj/2mFXtEWzPuGp6SnGLGyKGsoh/wJ1VmdKykqU4
ZRryRHjLSLe019hBoSNBXhApGdPrHFn2wAwPanevFXaiNVIYRHIpKJTWYBmw
OY0aRCSVVGN0zwob9NtULDV//DWQhNQ8cWwgiFuwgUJLL4K2C1o7IQMbn51x
WsVPAH0rvFbfCtsg5VafwerRvhmFS8+zH0w4AaB30+0u820SUVg+bI6Ux+NR
q9v51Cu+1Gn/q+AbGo35nkZIvjdtMn9YK8PVewo2f6AsLvc03vLhlRXGyEym
temb8IlQNPoNGsU3OY4P9j/MhBkJvgwAAA==
---1463811839-1663971492-1032326430=:10390--
