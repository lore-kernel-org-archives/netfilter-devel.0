From: =?ISO-8859-2?Q?Krzysztof_Ol=EAdzki?= <ole@ans.pl>
Subject: PATCH: add PRE_ROUTING and POST_ROUTING to filter table
Date: Fri, 10 Jan 2003 14:23:11 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0301101422160.5200-101000@dark.pcgames.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="-842857922-1008661402-1042065228=:32462"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Content-ID: <Pine.LNX.4.33.0301101422161.5200@dark.pcgames.pl>
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

---842857922-1008661402-1042065228=:32462
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.33.0301101422162.5200@dark.pcgames.pl>

Hello,

This patch adds support for NF_IP_PRE_ROUTING and NF_IP_POST_ROUTING for
filter table.

Now, on linux router, it is possible to block with one rule all traffic
from specific source or to specific destination. Previously, in such
situations, two rules were required (one in FORWARD and one in
INPUT/OUTPUT).

This patch was tested with 2.4.20 and 2.4.50 kernels.

Best regards,


=09=09=09=09Krzysztof Ol=EAdzki

---842857922-1008661402-1042065228=:32462
Content-Type: APPLICATION/OCTET-STREAM; NAME="iptable_filter.patch.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.33.0301082333480.32462@dark.pcgames.pl>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME="iptable_filter.patch.gz"

H4sIADENAT4CA+VXbW/aSBD+bP+KUSr1cGwDNi8JJD0lJaSl5QARev2QQz7H
rGGFsZFf0rxc/vD9iptdY2KCMempOp1U3hZ7Z5595plZe6yqKpSiwC8FvlVy
qBvdqXqxVqzWSi4JS3R5W2V/bOqExMfD0LxxiBEfFi1hNIugb4VQ0aCsNat6
U6+DXi7roizLUMy2vyAWaA1mX642K8ex/dkZqLqiaSDjbwPOzkSAQxjNaAD4
CWcEXRoN8Mk3n4YEPBs6A7ikeGw6yHqqgEkXOILt+TAnvksc0IuV4l2RAXGw
lre89+l0FkKhJcVwAzNy4M9hFIT3vwAOAXEceAu/UWtmIsCnIvRIxOBFGUHw
C+27kLgTMoHQA1wZbHpLYC0QzDxvHsDNPXz2H+6DhxB59p2/Jw9zyr3fmwG6
ei4P6H0Ll/r4FRbehNrUMkOKE+iQiLYw3alDihYjXxJlEd5Q13KiCYFTnqcS
OkZoMPt1e2rNyOAZpEuDYwbcWFTfTIhNXQKXne6oPTR+P+92LoyP/f7nKygU
NDg9hd6l0RkY3X7rvGt0ehL8Benzl/3h1/PhxcvTsXn/y0iSRPm1awyGbWOI
Pp3eB4b3hygLggD42kUk2yJFKQ+CkdtpMuhfjdZcJBQKSodwFZruxPQnQNzQ
vy+yXEAQ+hFWPWbKCFbTcQUfKboOcqWmVGq8hoWUJfF9z8c8+FMSQjyciPCE
X5ZcxAmptUIW4XHT1ydLx7QIsPFEVIUMApwfJcF1ZXyC0eVZ1NBimxpguSwY
I6AuDanpxDUDhsGOJ2Zoiuo7eMT3QVxbB0pGchWoKqIK/BXQB+LZhQwqEm6G
CsgZFpyKtIZ4hOvNChhDGSeF642sj/OWSpmva2C8h5sOT/8LCvJrBK+j3WsE
r+UKLr+INrUvxwIGLAsvZRByI5ZfCiQIewLeWoOptMepknJKb999flWu7s8X
chwxFjD0vnS7Csb+tD79iLhsxIteSgl+8xFineJ3GT2yh4OD+Lt5thx/uOJC
rGsGVX55lXZMboiMEAxaSRZ5ipGTZMbvzmBk4Cb50CvsRltdjCWJseYwz2iC
igqft1rtwQhU0FYyJfokBcHvBj9KHODisPtIva7UQT4+UrRqfBvJlwSyJYH/
QpLnkkmV4k9ZM5AlULyzkh2GMrWHw/6Q6cPyjBk+AlnT6jiwPPOGY4S94TfP
n4PlLQi2vy7MiE/A9r3Fc6dZtJJOhLcNkRvQqYu9JXVDUWV8WSdaSJ/mvSnG
zNsJLwrJThOsm1Xgwdy4iWwbDg+XwfyGz1ieG4TJPNIxJuSWYmdySN38eVwy
Lu5GHLSeBP3E4t4Zh+NZ2Imgc35EsdnuiFimdwbFJvfElWuyDk3TakoDY6tW
Fa22FVziaXOehrcMeGXheD1OWqvH1XWZ/bLaSlKpwAAv+L32SHnRESvrNrpj
xM3BunX5DrTVDeu7wTazs4MkXhPWnUwWyHM1bgGk7kN8F2fRk3fTy0Fe6/dj
YRMh/wXqcwnn6vgj2aav2bzKt6FXTyi8ums15Riru1FW9HJ8X6I2FHx8nDmF
ssT8px4+F1sOMd1oyZfU+OONwGzescr3yZQG7LmUb9W3Sf1XxhJ7aNmAkzPg
dLR6BVz1lXAVBgcMLvJdfLgKOdtNkyZ64kqRm0t9k+U+H535wKZQTSSS56Nt
+5Sb4j/4991mvxEAAA==
---842857922-1008661402-1042065228=:32462--
