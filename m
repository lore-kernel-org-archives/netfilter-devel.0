From: "Chris Poon" <Chris.Poon@TELUS.COM>
Subject: sparc64 kernel, netfilter-20021115, iptables-1.2.7a - conntrack
 i ssue with expecting related connections, FTP
Date: Fri, 24 Jan 2003 14:20:05 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <771F217D7A4AF84494632457889470A412D778@bcmsg011.corp.ads>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="----_=_NextPart_001_01C2C3EE.5D0921AC"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
	<netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_001_01C2C3EE.5D0921AC
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit

Can't seem to find anything that is similar to my problem so here it goes. 
Please CC me - Thanks

Client runs PLD sparc64 kernel RPM 2.4.20-1.2 (modified enough to build),
iptables-1.2.7a-0.2 (based on iptables-1.2.7-0.2 RPM)

Problem: FTP data connection tracking
Here's the rule set for my test box
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -j LOG --log-level 6 --log-prefix "INP: " --log-ip-options --log-tcp-options
iptables -P INPUT DROP
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -P FORWARD DROP
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p tcp --dport 21 -j ACCEPT
iptables -A OUTPUT -p tcp -j LOG --log-level 6 --log-prefix "OUT: " --log-ip-options --log-tcp-options
iptables -P OUTPUT DROP

Active FTP:
/var/log/kernel
Jan 24 12:53:23 client kernel: INP: IN=eth0 OUT= MAC=client:server:08:00 SRC=server DST=client LEN=48 TOS=0x00 PREC=0x00 TTL=120 ID=24008 DF PROTO=TCP SPT=20 DPT=1025 SEQ=1615415503 ACK=0 WINDOW=16384 RES=0x00 SYN URGP=0 OPT (020405B401010402) 

/proc/net/ip_conntrack
EXPECTING: - use=1 proto=6 src=server dst=client sport=0 dport=1025

Passive FTP:
Jan 24 12:54:08 client kernel: OUT: IN= OUT=eth0 SRC=client DST=server LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=47178 DF PROTO=TCP SPT=1027 DPT=4636 SEQ=2882061530 ACK=0 WINDOW=5840 RES=0x00 SYN URGP=0 OPT (020405B40402080A001280030000000001030300)

EXPECTING: - use=1 proto=6 src=client dst=server sport=0 dport=4636

Now looking at the source code, it looks like the masking for putting in the
expected connection seems to be right, but since I'm no netfilter hacker,
I don't know where to look to make sure the connection tracking part is right.
I have the feeling that this is an endian/64 bit issue as I'm sure none of you
guys with 32 bit kernels have this problem. I restrict my outbound connection
to eliminate undesirable connections - I know that if I allow all outbound traffic,
passive FTP would work. In this scenario, making active FTP work essentially
defeats the purpose of stateful inspection, as I would need to open up at least
things coming from port 20 inbound. Maybe the sparc64 guys (DaveM) or ppc64
guys have seen this and posted the same, or maybe it's fixed in a later CVS
snapshot - if the later is the case, I guess I will have to either hack the PLD spec
to make it build with the newer snapshots, or look for another one. I am also
in the process of building a kernel with NETFILTER_DEBUG on to see if I get
a better idea what the hell happened to cause the packet not to match the state
rule.

Thanks for all the response in advance

------_=_NextPart_001_01C2C3EE.5D0921AC
Content-Type: text/html;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
5.5.2653.12">
<TITLE>sparc64 kernel, netfilter-20021115, iptables-1.2.7a - conntrack =
issue with expecting related connections, FTP</TITLE>
</HEAD>
<BODY>

<P><FONT SIZE=3D2>Can't seem to find anything that is similar to my =
problem so here it goes. </FONT>
<BR><FONT SIZE=3D2>Please CC me - Thanks</FONT>
</P>

<P><FONT SIZE=3D2>Client runs PLD sparc64 kernel RPM 2.4.20-1.2 =
(modified enough to build),</FONT>
<BR><FONT SIZE=3D2>iptables-1.2.7a-0.2 (based on iptables-1.2.7-0.2 =
RPM)</FONT>
</P>

<P><FONT SIZE=3D2>Problem: FTP data connection tracking</FONT>
<BR><FONT SIZE=3D2>Here's the rule set for my test box</FONT>
<BR><FONT SIZE=3D2>iptables -A INPUT -i lo -j ACCEPT</FONT>
<BR><FONT SIZE=3D2>iptables -A INPUT -m state --state =
ESTABLISHED,RELATED -j ACCEPT</FONT>
<BR><FONT SIZE=3D2>iptables -A INPUT -p icmp -j ACCEPT</FONT>
<BR><FONT SIZE=3D2>iptables -A INPUT -p tcp --dport 22 -j ACCEPT</FONT>
<BR><FONT SIZE=3D2>iptables -A INPUT -p tcp -j LOG --log-level 6 =
--log-prefix &quot;INP: &quot; --log-ip-options =
--log-tcp-options</FONT>
<BR><FONT SIZE=3D2>iptables -P INPUT DROP</FONT>
<BR><FONT SIZE=3D2>iptables -A FORWARD -m state --state =
ESTABLISHED,RELATED -j ACCEPT</FONT>
<BR><FONT SIZE=3D2>iptables -P FORWARD DROP</FONT>
<BR><FONT SIZE=3D2>iptables -A OUTPUT -o lo -j ACCEPT</FONT>
<BR><FONT SIZE=3D2>iptables -A OUTPUT -m state --state =
ESTABLISHED,RELATED -j ACCEPT</FONT>
<BR><FONT SIZE=3D2>iptables -A OUTPUT -p icmp -j ACCEPT</FONT>
<BR><FONT SIZE=3D2>iptables -A OUTPUT -p tcp --dport 21 -j =
ACCEPT</FONT>
<BR><FONT SIZE=3D2>iptables -A OUTPUT -p tcp -j LOG --log-level 6 =
--log-prefix &quot;OUT: &quot; --log-ip-options =
--log-tcp-options</FONT>
<BR><FONT SIZE=3D2>iptables -P OUTPUT DROP</FONT>
</P>

<P><FONT SIZE=3D2>Active FTP:</FONT>
<BR><FONT SIZE=3D2>/var/log/kernel</FONT>
<BR><FONT SIZE=3D2>Jan 24 12:53:23 client kernel: INP: IN=3Deth0 OUT=3D =
MAC=3Dclient:server:08:00 SRC=3Dserver DST=3Dclient LEN=3D48 TOS=3D0x00 =
PREC=3D0x00 TTL=3D120 ID=3D24008 DF PROTO=3DTCP SPT=3D20 DPT=3D1025 =
SEQ=3D1615415503 ACK=3D0 WINDOW=3D16384 RES=3D0x00 SYN URGP=3D0 OPT =
(020405B401010402) </FONT></P>

<P><FONT SIZE=3D2>/proc/net/ip_conntrack</FONT>
<BR><FONT SIZE=3D2>EXPECTING: - use=3D1 proto=3D6 src=3Dserver =
dst=3Dclient sport=3D0 dport=3D1025</FONT>
</P>

<P><FONT SIZE=3D2>Passive FTP:</FONT>
<BR><FONT SIZE=3D2>Jan 24 12:54:08 client kernel: OUT: IN=3D OUT=3Deth0 =
SRC=3Dclient DST=3Dserver LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 =
ID=3D47178 DF PROTO=3DTCP SPT=3D1027 DPT=3D4636 SEQ=3D2882061530 =
ACK=3D0 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0 OPT =
(020405B40402080A001280030000000001030300)</FONT></P>

<P><FONT SIZE=3D2>EXPECTING: - use=3D1 proto=3D6 src=3Dclient =
dst=3Dserver sport=3D0 dport=3D4636</FONT>
</P>

<P><FONT SIZE=3D2>Now looking at the source code, it looks like the =
masking for putting in the</FONT>
<BR><FONT SIZE=3D2>expected connection seems to be right, but since I'm =
no netfilter hacker,</FONT>
<BR><FONT SIZE=3D2>I don't know where to look to make sure the =
connection tracking part is right.</FONT>
<BR><FONT SIZE=3D2>I have the feeling that this is an endian/64 bit =
issue as I'm sure none of you</FONT>
<BR><FONT SIZE=3D2>guys with 32 bit kernels have this problem. I =
restrict my outbound connection</FONT>
<BR><FONT SIZE=3D2>to eliminate undesirable connections - I know that =
if I allow all outbound traffic,</FONT>
<BR><FONT SIZE=3D2>passive FTP would work. In this scenario, making =
active FTP work essentially</FONT>
<BR><FONT SIZE=3D2>defeats the purpose of stateful inspection, as I =
would need to open up at least</FONT>
<BR><FONT SIZE=3D2>things coming from port 20 inbound. Maybe the =
sparc64 guys (DaveM) or ppc64</FONT>
<BR><FONT SIZE=3D2>guys have seen this and posted the same, or maybe =
it's fixed in a later CVS</FONT>
<BR><FONT SIZE=3D2>snapshot - if the later is the case, I guess I will =
have to either hack the PLD spec</FONT>
<BR><FONT SIZE=3D2>to make it build with the newer snapshots, or look =
for another one. I am also</FONT>
<BR><FONT SIZE=3D2>in the process of building a kernel with =
NETFILTER_DEBUG on to see if I get</FONT>
<BR><FONT SIZE=3D2>a better idea what the hell happened to cause the =
packet not to match the state</FONT>
<BR><FONT SIZE=3D2>rule.</FONT>
</P>

<P><FONT SIZE=3D2>Thanks for all the response in advance</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C2C3EE.5D0921AC--
