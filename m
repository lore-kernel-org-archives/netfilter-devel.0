From: =?big5?B?qkzgSK54?= <murphyhtlin@msn.com>
Subject: why we need find_appopriate_src? rether than just check in_range?
Date: Fri, 5 Dec 2003 11:40:31 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001301c3bae1$88c362e0$2501a8c0@murphy>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0010_01C3BB24.967BAC10"
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

------=_NextPart_000_0010_01C3BB24.967BAC10
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

1.find_appropriate_src(const struct ip_conntrack_tuple *tuple,
       const struct ip_nat_multi_range *mr)
{
 unsigned int h =3D hash_by_src(&tuple->src, tuple->dst.protonum);
 struct ip_nat_hash *i;

 MUST_BE_READ_LOCKED(&ip_nat_lock);
 i =3D LIST_FIND(&bysource[h], src_cmp, struct ip_nat_hash *, tuple, =
mr);
 if (i)
  return &i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src;
 else
  return NULL;
}

static inline int
src_cmp(const struct ip_nat_hash *i,
 const struct ip_conntrack_tuple *tuple,
 const struct ip_nat_multi_range *mr)
{
 return (i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum
  =3D=3D tuple->dst.protonum
  && i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip
  =3D=3D tuple->src.ip
  && i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all
  =3D=3D tuple->src.u.all
# ??? Is code marked by RED colour  is somewhat a kind of pre-designed =
idea for certain SECURITY mechanism, that is not clear so far ??? ...   =
Murphy Hsu-ting Lin ( Taiwan )
  && in_range(tuple,
       &i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
       .tuple.src,
       mr));
}








=20

------=_NextPart_000_0010_01C3BB24.967BAC10
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
<DIV><FONT size=3D2>1.</FONT><FONT size=3D2>find_appropriate_src(const =
struct=20
ip_conntrack_tuple *tuple,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; const =
struct=20
ip_nat_multi_range *mr)<BR>{<BR>&nbsp;unsigned int h =3D=20
hash_by_src(&amp;tuple-&gt;src, tuple-&gt;dst.protonum);<BR>&nbsp;struct =

ip_nat_hash *i;</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT =
size=3D2>&nbsp;MUST_BE_READ_LOCKED(&amp;ip_nat_lock);<BR>&nbsp;i =3D=20
LIST_FIND(&amp;bysource[h], <STRONG><EM><FONT color=3D#ff0000=20
size=3D5>src_cmp</FONT></EM></STRONG>, struct ip_nat_hash *, tuple,=20
mr);<BR>&nbsp;if (i)<BR>&nbsp;&nbsp;return=20
&amp;i-&gt;conntrack-&gt;tuplehash[IP_CT_DIR_ORIGINAL].tuple.src;<BR>&nbs=
p;else<BR>&nbsp;&nbsp;return=20
NULL;<BR>}</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>static inline int<BR><FONT color=3D#ff0000=20
size=3D5><STRONG><EM>src_cmp</EM></STRONG></FONT>(const struct =
ip_nat_hash=20
*i,<BR>&nbsp;const struct ip_conntrack_tuple *tuple,<BR>&nbsp;const =
struct=20
ip_nat_multi_range *mr)<BR>{<BR><FONT color=3D#ff0000>&nbsp;return=20
(i-&gt;conntrack-&gt;tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum<BR>=
&nbsp;&nbsp;=3D=3D=20
tuple-&gt;dst.protonum<BR>&nbsp;&nbsp;&amp;&amp;=20
i-&gt;conntrack-&gt;tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip<BR>&nbsp;&=
nbsp;=3D=3D=20
tuple-&gt;src.ip<BR>&nbsp;&nbsp;&amp;&amp;=20
i-&gt;conntrack-&gt;tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all<BR>&nbs=
p;&nbsp;=3D=3D=20
tuple-&gt;src.u.all</FONT></FONT></DIV>
<DIV><FONT size=3D2><FONT color=3D#ff0000><FONT size=3D4><STRONG><EM># =
??? Is=20
code&nbsp;marked&nbsp;by RED colour &nbsp;is somewhat a kind of =
pre-designed=20
idea for&nbsp;certain&nbsp;SECURITY mechanism, that&nbsp;is&nbsp;not =
clear so=20
far ??? ...</EM></STRONG></FONT>&nbsp;&nbsp;&nbsp;Murphy Hsu-ting Lin=20
(&nbsp;Taiwan )<BR></FONT>&nbsp;&nbsp;&amp;&amp;=20
in_range(tuple,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
&amp;i-&gt;conntrack-&gt;tuplehash[IP_CT_DIR_ORIGINAL]<BR>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=20
.tuple.src,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
mr));<BR>}</FONT></DIV>
<DIV><FONT size=3D2><BR></FONT><FONT size=3D2>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV><BR></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_0010_01C3BB24.967BAC10--
