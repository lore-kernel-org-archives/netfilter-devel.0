From: "Hsiao Kevin" <kevinhsiao@msn.com>
Subject: iptables 1.2.7a bug report for conntrack
Date: Mon, 25 Nov 2002 16:53:31 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <DAV60HW2Qxc0fHqr8k600025ce4@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="----=_NextPart_001_0000_01C294A3.2F7DF840"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


------=_NextPart_001_0000_01C294A3.2F7DF840
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: quoted-printable

TO WHOM IT MAY CONCERN,

I found some error in =20

iptables-1.2.7a/extensions/libipt_conntrack.c
Line#437: printf("%sctreplsrc ", optpfx);
Line#447: printf("%sctrepldst ", optpfx);

Sincerely,

Kevin=A6b=BA=F4=B8=F4=A4W=A8=CF=A5=CE=A7=F3=A6h=A5\=AF=E0=A1C=A4U=B8=FC=A7=
K=B6O MSN Explorer: http://explorer.msn.com.tw/intl.asp

------=_NextPart_001_0000_01C294A3.2F7DF840
Content-Type: text/html; charset="big5"
Content-Transfer-Encoding: quoted-printable

<HTML><BODY STYLE=3D"font:10pt verdana; border:none;"><DIV>TO WHOM IT MAY=
 CONCERN,</DIV> <DIV>&nbsp;</DIV> <DIV>I found some error in <BR><BR>ipta=
bles-1.2.7a/extensions/libipt_conntrack.c</DIV> <DIV>Line#437: printf("%s=
ctreplsrc ", optpfx);</DIV> <DIV>Line#447: printf("%sctrepldst ", optpfx)=
;</DIV> <DIV>&nbsp;</DIV> <DIV>Sincerely,</DIV> <DIV>&nbsp;</DIV> <DIV>Ke=
vin</DIV></BODY></HTML><br clear=3Dall><hr>=A6b=BA=F4=B8=F4=A4W=A8=CF=A5=CE=
=A7=F3=A6h=A5\=AF=E0=A1C=A4U=B8=FC=A7K=B6O <a href=3D'http://explorer.msn=
.com.tw/intl.asp'>MSN Explorer</a><br></p>

------=_NextPart_001_0000_01C294A3.2F7DF840--
