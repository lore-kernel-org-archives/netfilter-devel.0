From: lepton <ytht.net@gmail.com>
Subject: [Openswan dev]
Date: Fri, 13 Jan 2006 13:24:54 +0800
Message-ID: <1cafb3070601122124l11f06130i@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============10126208614827159=="
Cc: netfilter-devel@lists.netfilter.org
Return-path: <dev-bounces@openswan.org>
To: dev@openswan.org
List-Unsubscribe: <http://lists.openswan.org/mailman/listinfo/dev>,
	<mailto:dev-request@openswan.org?subject=unsubscribe>
List-Archive: <http://lists.openswan.org/pipermail/dev>
List-Post: <mailto:dev@openswan.org>
List-Help: <mailto:dev-request@openswan.org?subject=help>
List-Subscribe: <http://lists.openswan.org/mailman/listinfo/dev>,
	<mailto:dev-request@openswan.org?subject=subscribe>
Sender: dev-bounces@openswan.org
Errors-To: dev-bounces@openswan.org
List-Id: netfilter-devel.vger.kernel.org

--===============10126208614827159==
Content-Type: multipart/alternative;
	boundary="----=_Part_23444_6883104.1137129894606"

------=_Part_23444_6883104.1137129894606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi!
   After install openswan, I found my transprent ftp proxy can't work any
more.
   With openswan's default configuration, my route table looks like this:

Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use
Iface
192.168.100.0   0.0.0.0         255.255.255.0   U     0      0        0 eth1
192.168.100.0   0.0.0.0         255.255.255.0   U     0      0        0
ipsec0
192.168.2.0     0.0.0.0         255.255.255.0   U     0      0        0 eth0
0.0.0.0         192.168.100.1   128.0.0.0       UG    0      0        0
ipsec0
128.0.0.0       192.168.100.1   128.0.0.0       UG    0      0        0
ipsec0
0.0.0.0         192.168.100.1   0.0.0.0         UG    0      0        0 eth1

So the packet out from my linux server will first go out from ipsec0 device,
and finally
go out from eth1 device. There is no any encrypt tunnel indeed, so the same
skb will
go through ip_nat_seq_adjust function twice. When somet helper like
ip_nat_ftp need
change the seq of some packet, the seq will be changed twice, then the
packet will be send
out with the incorrect seq.

The following patch will fix this, How do you think about this?
Thanks

diff -pru linux-2.6.14-orig/include/linux/skbuff.h
linux-2.6.14/include/linux/skbuff.h
--- linux-2.6.14-orig/include/linux/skbuff.h	2006-01-12 13:36:28.000000000 =
+0800
+++ linux-2.6.14/include/linux/skbuff.h	2006-01-13 12:32:23.000000000 +0800
@@ -261,7 +261,8 @@ struct sk_buff {
 				nohdr:1,
 				nfctinfo:3;
 	__u8			pkt_type:3,
-				fclone:2;
+				fclone:2,
+				seq_changed:1;
 	__be16			protocol;

 	void			(*destructor)(struct sk_buff *skb);
diff -pru linux-2.6.14-orig/net/ipv4/netfilter/ip_nat_helper.c
linux-2.6.14/net/ipv4/netfilter/ip_nat_helper.c
--- linux-2.6.14-orig/net/ipv4/netfilter/ip_nat_helper.c	2005-10-28
08:02:08.000000000 +0800
+++ linux-2.6.14/net/ipv4/netfilter/ip_nat_helper.c	2006-01-13
12:39:17.000000000 +0800
@@ -365,6 +365,9 @@ ip_nat_seq_adjust(struct sk_buff **pskb,
 	this_way =3D &ct->nat.info.seq[dir];
 	other_way =3D &ct->nat.info.seq[!dir];

+	if((*pskb)->seq_changed)
+		return 1;
+
 	if (!skb_make_writable(pskb, (*pskb)->nh.iph->ihl*4+sizeof(*tcph)))
 		return 0;

@@ -398,6 +401,7 @@ ip_nat_seq_adjust(struct sk_buff **pskb,
 		return 0;

 	ip_conntrack_tcp_update(*pskb, ct, dir);
+	(*pskb)->seq_changed=3D1;

 	return 1;

 }

------=_Part_23444_6883104.1137129894606
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi!<br>
&nbsp;&nbsp; After install openswan, I found my transprent ftp proxy can't =
work any more.<br>
&nbsp;&nbsp; With openswan's default configuration, my route table looks li=
ke this:<br>
<br>
Kernel IP routing table<br>
Destination&nbsp;&nbsp;&nbsp;&nbsp;
Gateway&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Genmask&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Flags Metric
Ref&nbsp;&nbsp;&nbsp; Use Iface<br>
<a href=3D"http://192.168.100.0"></b></font></b></font><font color=3D"red">=
<b>MailScanner has detected a possible fraud attempt from "192.168.100.0" c=
laiming to be</b></font> <font color=3D"red"><b>MailScanner has detected a =
possible fraud attempt from "192.168.100.0" claiming to be <font color=3D"r=
ed"><b>MailScanner warning: numerical links are often malicious: 192.168.10=
0.0</a>&nbsp;&nbsp;
<a href=3D"http://0.0.0.0"></b></font></b></font><font color=3D"red"><b>Mai=
lScanner has detected a possible fraud attempt from "0.0.0.0" claiming to b=
e</b></font> <font color=3D"red"><b>MailScanner has detected a possible fra=
ud attempt from "0.0.0.0" claiming to be <font color=3D"red"><b>MailScanner=
 warning: numerical links are often malicious: 0.0.0.0</a>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href=3D"http://255.255.255.0"></b></font></b></font><font color=3D"red">=
<b>MailScanner has detected a possible fraud attempt from "255.255.255.0" c=
laiming to be</b></font> <font color=3D"red"><b>MailScanner has detected a =
possible fraud attempt from "255.255.255.0" claiming to be <font color=3D"r=
ed"><b>MailScanner warning: numerical links are often malicious: 255.255.25=
5.0</a>&nbsp;&nbsp; U&nbsp;&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 eth1<br>
<a href=3D"http://192.168.100.0"></b></font></b></font><font color=3D"red">=
<b>MailScanner has detected a possible fraud attempt from "192.168.100.0" c=
laiming to be</b></font> <font color=3D"red"><b>MailScanner has detected a =
possible fraud attempt from "192.168.100.0" claiming to be <font color=3D"r=
ed"><b>MailScanner warning: numerical links are often malicious: 192.168.10=
0.0</a>&nbsp;&nbsp;
<a href=3D"http://0.0.0.0"></b></font></b></font><font color=3D"red"><b>Mai=
lScanner has detected a possible fraud attempt from "0.0.0.0" claiming to b=
e</b></font> <font color=3D"red"><b>MailScanner has detected a possible fra=
ud attempt from "0.0.0.0" claiming to be <font color=3D"red"><b>MailScanner=
 warning: numerical links are often malicious: 0.0.0.0</a>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href=3D"http://255.255.255.0"></b></font></b></font><font color=3D"red">=
<b>MailScanner has detected a possible fraud attempt from "255.255.255.0" c=
laiming to be</b></font> <font color=3D"red"><b>MailScanner has detected a =
possible fraud attempt from "255.255.255.0" claiming to be <font color=3D"r=
ed"><b>MailScanner warning: numerical links are often malicious: 255.255.25=
5.0</a>&nbsp;&nbsp; U&nbsp;&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 ipsec0<br>
<a href=3D"http://192.168.2.0"></b></font></b></font><font color=3D"red"><b=
>MailScanner has detected a possible fraud attempt from "192.168.2.0" claim=
ing to be</b></font> <font color=3D"red"><b>MailScanner has detected a poss=
ible fraud attempt from "192.168.2.0" claiming to be <font color=3D"red"><b=
>MailScanner warning: numerical links are often malicious: 192.168.2.0</a>&=
nbsp;&nbsp;&nbsp;&nbsp;
<a href=3D"http://0.0.0.0"></b></font></b></font><font color=3D"red"><b>Mai=
lScanner has detected a possible fraud attempt from "0.0.0.0" claiming to b=
e</b></font> <font color=3D"red"><b>MailScanner has detected a possible fra=
ud attempt from "0.0.0.0" claiming to be <font color=3D"red"><b>MailScanner=
 warning: numerical links are often malicious: 0.0.0.0</a>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href=3D"http://255.255.255.0"></b></font></b></font><font color=3D"red">=
<b>MailScanner has detected a possible fraud attempt from "255.255.255.0" c=
laiming to be</b></font> <font color=3D"red"><b>MailScanner has detected a =
possible fraud attempt from "255.255.255.0" claiming to be <font color=3D"r=
ed"><b>MailScanner warning: numerical links are often malicious: 255.255.25=
5.0</a>&nbsp;&nbsp; U&nbsp;&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 eth0<br>
<a href=3D"http://0.0.0.0"></b></font></b></font><font color=3D"red"><b>Mai=
lScanner has detected a possible fraud attempt from "0.0.0.0" claiming to b=
e</b></font> <font color=3D"red"><b>MailScanner has detected a possible fra=
ud attempt from "0.0.0.0" claiming to be <font color=3D"red"><b>MailScanner=
 warning: numerical links are often malicious: 0.0.0.0</a>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href=3D"http://192.168.100.1"></b></font></b></font><font color=3D"red">=
<b>MailScanner has detected a possible fraud attempt from "192.168.100.1" c=
laiming to be</b></font> <font color=3D"red"><b>MailScanner has detected a =
possible fraud attempt from "192.168.100.1" claiming to be <font color=3D"r=
ed"><b>MailScanner warning: numerical links are often malicious: 192.168.10=
0.1</a>&nbsp;&nbsp; <a href=3D"http://128.0.0.0"></b></font></b></font><fon=
t color=3D"red"><b>MailScanner has detected a possible fraud attempt from "=
128.0.0.0" claiming to be</b></font> <font color=3D"red"><b>MailScanner has=
 detected a possible fraud attempt from "128.0.0.0" claiming to be <font co=
lor=3D"red"><b>MailScanner warning: numerical links are often malicious: 12=
8.0.0.0</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
UG&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 ipsec0<br>
<a href=3D"http://128.0.0.0"></b></font></b></font><font color=3D"red"><b>M=
ailScanner has detected a possible fraud attempt from "128.0.0.0" claiming =
to be</b></font> <font color=3D"red"><b>MailScanner has detected a possible=
 fraud attempt from "128.0.0.0" claiming to be <font color=3D"red"><b>MailS=
canner warning: numerical links are often malicious: 128.0.0.0</a>&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; <a href=3D"http://192.168.100.1"></b></font></b=
></font><font color=3D"red"><b>MailScanner has detected a possible fraud at=
tempt from "192.168.100.1" claiming to be</b></font> <font color=3D"red"><b=
>MailScanner has detected a possible fraud attempt from "192.168.100.1" cla=
iming to be <font color=3D"red"><b>MailScanner warning: numerical links are=
 often malicious: 192.168.100.1</a>&nbsp;&nbsp;
<a href=3D"http://128.0.0.0"></b></font></b></font><font color=3D"red"><b>M=
ailScanner has detected a possible fraud attempt from "128.0.0.0" claiming =
to be</b></font> <font color=3D"red"><b>MailScanner has detected a possible=
 fraud attempt from "128.0.0.0" claiming to be <font color=3D"red"><b>MailS=
canner warning: numerical links are often malicious: 128.0.0.0</a>&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; UG&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 ipsec0<br>
<a href=3D"http://0.0.0.0"></b></font></b></font><font color=3D"red"><b>Mai=
lScanner has detected a possible fraud attempt from "0.0.0.0" claiming to b=
e</b></font> <font color=3D"red"><b>MailScanner has detected a possible fra=
ud attempt from "0.0.0.0" claiming to be <font color=3D"red"><b>MailScanner=
 warning: numerical links are often malicious: 0.0.0.0</a>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href=3D"http://192.168.100.1"></b></font></b></font><font color=3D"red">=
<b>MailScanner has detected a possible fraud attempt from "192.168.100.1" c=
laiming to be</b></font> <font color=3D"red"><b>MailScanner has detected a =
possible fraud attempt from "192.168.100.1" claiming to be <font color=3D"r=
ed"><b>MailScanner warning: numerical links are often malicious: 192.168.10=
0.1</a>&nbsp;&nbsp;
<a href=3D"http://0.0.0.0"></b></font></b></font><font color=3D"red"><b>Mai=
lScanner has detected a possible fraud attempt from "0.0.0.0" claiming to b=
e</b></font> <font color=3D"red"><b>MailScanner has detected a possible fra=
ud attempt from "0.0.0.0" claiming to be <font color=3D"red"><b>MailScanner=
 warning: numerical links are often malicious: 0.0.0.0</a>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
UG&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 eth1<br>
<br>
So the packet out from my linux server will first go out from ipsec0 device=
, and finally<br>
go out from eth1 device. There is no any encrypt tunnel indeed, so the same=
 skb will<br>
go through ip_nat_seq_adjust function twice. When somet helper like ip_nat_=
ftp need<br>
change the seq of some packet, the seq will be changed twice, then the pack=
et will be send<br>
out with the incorrect seq.<br>
<br>
The following patch will fix this, How do you think about this?<br>
Thanks<br>
<pre>diff -pru linux-2.6.14-orig/include/linux/skbuff.h linux-2.6.14/includ=
e/linux/skbuff.h<br>--- linux-2.6.14-orig/include/linux/skbuff.h	2006-01-12=
 13:36:28.000000000 +0800<br>+++ linux-2.6.14/include/linux/skbuff.h	2006-0=
1-13 12:32:
23.000000000 +0800<br>@@ -261,7 +261,8 @@ struct sk_buff {<br> 				nohdr:1,=
<br> 				nfctinfo:3;<br> 	__u8			pkt_type:3,<br>-				fclone:2;<br>+				fclo=
ne:2,<br>+				seq_changed:1;<br> 	__be16			protocol;<br> <br> 	void			(*des=
tructor)(struct sk_buff *skb);
<br>diff -pru linux-2.6.14-orig/net/ipv4/netfilter/ip_nat_helper.c linux-2.=
6.14/net/ipv4/netfilter/ip_nat_helper.c<br>--- linux-2.6.14-orig/net/ipv4/n=
etfilter/ip_nat_helper.c	2005-10-28 08:02:08.000000000 +0800<br>+++ linux-2=
.6.14
/net/ipv4/netfilter/ip_nat_helper.c	2006-01-13 12:39:17.000000000 +0800<br>=
@@ -365,6 +365,9 @@ ip_nat_seq_adjust(struct sk_buff **pskb,<br> 	this_way =
=3D &amp;ct-&gt;nat.info.seq[dir];<br> 	other_way =3D &amp;ct-&gt;nat.info.=
seq
[!dir];<br> <br>+	if((*pskb)-&gt;seq_changed)<br>+		return 1;<br>+<br> 	if =
(!skb_make_writable(pskb, (*pskb)-&gt;nh.iph-&gt;ihl*4+sizeof(*tcph)))<br> =
		return 0;<br> <br>@@ -398,6 +401,7 @@ ip_nat_seq_adjust(struct sk_buff **=
pskb,
<br> 		return 0;<br> <br> 	ip_conntrack_tcp_update(*pskb, ct, dir);<br>+	(*=
pskb)-&gt;seq_changed=3D1;<br> <br> 	return 1;<br><br> }<br></pre>
<br>

------=_Part_23444_6883104.1137129894606--

--===============10126208614827159==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Dev mailing list
Dev@openswan.org
http://lists.openswan.org/mailman/listinfo/dev

--===============10126208614827159==--
