From: "Gael Mauleon" <gmauleon@free.fr>
Subject: Concerning ULOG and the MAC logging bug
Date: Thu, 5 Dec 2002 22:27:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003101c29ca5$289c8b40$0200a8c0@KevlarPC>
Reply-To: "Gael Mauleon" <gmauleon@free.fr>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_002E_01C29CAD.8A3D3EA0"
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

------=_NextPart_000_002E_01C29CAD.8A3D3EA0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi, I am new here so excuse me first for my bad english and then for all
mistake i can make :))

So I found a bug in ULOG concerning the logging of MAC Address, =
searching the
list archive i  found a patch from Harald  Welte but I think a better =
one can be=20
written in this, but since i am new to kernel/netfilter coding perhaps =
that's not the way to
do it .....

(ipt_ULOG.c) :

---------------------------------------------
Line 210

        pm =3D NLMSG_DATA(nlh);
        memset(pm, 0, sizeof(ulog_packet_msg_t));
=20
        /* copy hook, prefix, timestamp, payload, etc. */=20
        pm->data_len =3D copy_len;
        pm->timestamp_sec =3D (*pskb)->stamp.tv_sec;
        pm->timestamp_usec =3D (*pskb)->stamp.tv_usec;=20
        pm->mark =3D (*pskb)->nfmark;
        pm->hook =3D hooknum;
        if (loginfo->prefix[0] !=3D '\0')=20
                strncpy(pm->prefix, loginfo->prefix, =
sizeof(pm->prefix));
=20
        if (in && in->hard_header_len > 0
            && (*pskb)->mac.raw !=3D (void *) (*pskb)->nh.iph
            && in->hard_header_len <=3D ULOG_MAC_LEN) {
                memcpy(pm->mac, (*pskb)->mac.raw, in->hard_header_len);
                pm->mac_len =3D in->hard_header_len;=20
        }=20

        if (in)=20
                strncpy(pm->indev_name, in->name, =
sizeof(pm->indev_name));
=20
        if (out)=20
                strncpy(pm->outdev_name, out->name, =
sizeof(pm->outdev_name));
=20
        if (copy_len)=20
                memcpy(pm->payload, (*pskb)->data, copy_len);=20

------------------------------------------------

Since the payload can also be exploited with wrong data , i would prefer =
a memset
solution like this to the else solution proposed. And we can then erase =
all the else.

Please let me know, what do you think of it.
And let me know if there is a better way to tell about bugs and put some =
code changes.

Thx.



------=_NextPart_000_002E_01C29CAD.8A3D3EA0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2719.2200" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hi, I am new here so excuse me first =
for my bad=20
english and then for all</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>mistake i can make :))</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>So I found a bug in ULOG concerning the =
logging of=20
MAC Address, searching the</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>list archive i&nbsp; found a patch from =

Harald&nbsp; Welte but I think a better one can be </FONT></DIV>
<DIV><FONT face=3DArial size=3D2>written in this, but since i am new=20
to&nbsp;kernel/netfilter coding perhaps that's not the way =
to</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>do it .....</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>(ipt_ULOG.c) :</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial=20
size=3D2>---------------------------------------------</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Line 210</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pm =3D=20
NLMSG_DATA(nlh);<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
memset(pm, 0,=20
sizeof(ulog_packet_msg_t));<BR>&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;=20
/* copy hook, prefix, timestamp, payload, etc. */=20
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pm-&gt;data_len =3D=20
copy_len;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
pm-&gt;timestamp_sec =3D=20
(*pskb)-&gt;stamp.tv_sec;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
pm-&gt;timestamp_usec =3D (*pskb)-&gt;stamp.tv_usec;=20
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pm-&gt;mark =3D=20
(*pskb)-&gt;nfmark;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
pm-&gt;hook =3D=20
hooknum;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if =
(loginfo-&gt;prefix[0]=20
!=3D '\0')=20
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=20
strncpy(pm-&gt;prefix, loginfo-&gt;prefix,=20
sizeof(pm-&gt;prefix));<BR>&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;=20
if (in &amp;&amp; in-&gt;hard_header_len &gt;=20
0<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
&amp;&amp; (*pskb)-&gt;mac.raw !=3D (void *)=20
(*pskb)-&gt;nh.iph<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;=20
&amp;&amp; in-&gt;hard_header_len &lt;=3D ULOG_MAC_LEN)=20
{<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;=20
memcpy(pm-&gt;mac, (*pskb)-&gt;mac.raw,=20
in-&gt;hard_header_len);<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
pm-&gt;mac_len =3D in-&gt;hard_header_len;=20
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } </FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (in)=20
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=20
strncpy(pm-&gt;indev_name, in-&gt;name,=20
sizeof(pm-&gt;indev_name));<BR>&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;=20
if (out)=20
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=20
strncpy(pm-&gt;outdev_name, out-&gt;name,=20
sizeof(pm-&gt;outdev_name));<BR>&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;=20
if (copy_len)=20
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=20
memcpy(pm-&gt;payload, (*pskb)-&gt;data, copy_len); <BR></DIV>
<DIV>------------------------------------------------<BR></DIV></FONT>
<DIV><FONT face=3DArial size=3D2>Since the payload can also be exploited =
with wrong=20
data , i would prefer a memset</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>solution like this to the else solution =
proposed.=20
And we can then erase all the else.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Please let me know, what do you think =
of=20
it.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>And let me know if there is a better =
way to tell=20
about bugs and put some code changes.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Thx.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_002E_01C29CAD.8A3D3EA0--
