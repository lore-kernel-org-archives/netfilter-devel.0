From: "jesse" <jesse@deansoft.com.tw>
Subject: why find_appropriate_src so unneeded??
Date: Tue, 1 Jul 2003 15:24:52 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <004a01c33fa1$dd3553d0$0f01a8c0@jessepqrbax6uv>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0047_01C33FE4.EACD91E0"
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

This is a multi-part message in MIME format.

------=_NextPart_000_0047_01C33FE4.EACD91E0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

Excuse me, can I ask a question?
Since we've guaranteed that the adjusted tuple being uniche after we did =
dnat in NF_IP_PRE_ROUTING(even finding no rule will still do =
alloc_null_binding), why we should use find_appropriate_src to prove =
this once adjusted tuple's reusability rether than just check it's =
in_range?

------=_NextPart_000_0047_01C33FE4.EACD91E0
Content-Type: text/html;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dbig5">
<META content=3D"MSHTML 6.00.2600.0" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3D=B7s=B2=D3=A9=FA=C5=E9 size=3D2>Excuse me, can I ask a =
question?</FONT></DIV>
<DIV><FONT face=3D=B7s=B2=D3=A9=FA=C5=E9 size=3D2>Since we've guaranteed =
that the&nbsp;adjusted tuple=20
being uniche after&nbsp;we did dnat&nbsp;in NF_IP_PRE_ROUTING(even =
finding no=20
rule will still do alloc_null_binding), why we should&nbsp;use=20
find_appropriate_src to prove this&nbsp;once adjusted tuple's =
reusability rether=20
than just check it's in_range?</FONT></DIV></BODY></HTML>

------=_NextPart_000_0047_01C33FE4.EACD91E0--
