From: Rajeev Jain <rajeevj@EMAIL.masconit.com>
Subject: MSN v/s Iptables !
Date: Fri, 21 Jun 2002 17:26:04 -0500
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <A5EBA754022DD411928400D0B774BB520133BCCC@email.masconit.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C21972.A1AD71E0"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "'netfilter-devel@lists.samba.org'" <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_001_01C21972.A1AD71E0
Content-Type: text/plain;
	charset="iso-8859-1"

Hi,

I read some document about allowing MSN voice using Iptables and setup the
following commented ruleset in my firewall rules startup file. I did it
manually too but didn't help.

Could you please take a look at the ruleset below and advice me the correct
order OR ruleset to allow MSN voice chat ?

I would really appreciate your reply.

Thanks
Rajeev


$EXTIF=eth0=12.12.12.12 (Public IP)
$INTIF=eth1=192.168.1.1 (Private IP of Router)

#
echo "   clearing any existing rules and setting default policy.."
$IPTABLES -P INPUT ACCEPT
$IPTABLES -F INPUT 
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -F OUTPUT 
$IPTABLES -P FORWARD DROP
$IPTABLES -F FORWARD 
$IPTABLES -t nat -F

echo "   FWD: Allow all connections OUT and only existing and related ones
IN"
$IPTABLES -A FORWARD -i $EXTIF -o $INTIF -m state --state
ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A FORWARD -i $INTIF -o $EXTIF -j ACCEPT
$IPTABLES -A FORWARD -j LOG

#echo " Allow MSN Messenger connection "
#$IPTABLES -A FORWARD -p TCP --dport 1863 -j ACCEPT
#$IPTABLES -A FORWARD -p TCP --dport 7801:7825 -j ACCEPT
#$IPTABLES -A FORWARD -p TCP --dport 6891:6900 -j ACCEPT
#$IPTABLES -A FORWARD -d 64.4.13.0/24 -j ACCEPT

echo "   Enabling SNAT (MASQUERADE) functionality on $EXTIF"
$IPTABLES -t nat -A POSTROUTING -o $EXTIF -j MASQUERADE

echo -e "\nrc.firewall-2.4 v$FWVER done.\n"


------_=_NextPart_001_01C21972.A1AD71E0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
5.5.2653.12">
<TITLE>MSN v/s Iptables !</TITLE>
</HEAD>
<BODY>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Hi,</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">I read some document about =
allowing MSN voice using Iptables and setup the following commented =
ruleset in my firewall rules startup file. I did it manually too but =
didn't help.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Could you please take a look at =
the ruleset below and advice me the correct order OR ruleset to allow =
MSN voice chat ?</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">I would really appreciate your =
reply.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Thanks</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">Rajeev</FONT>
</P>
<BR>

<P><FONT SIZE=3D2 FACE=3D"Courier New">$EXTIF=3Deth0=3D12.12.12.12 =
(Public IP)</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$INTIF=3Deth1=3D192.168.1.1 =
(Private IP of Router)</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">#</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">echo &quot;&nbsp;&nbsp; =
clearing any existing rules and setting default policy..&quot;</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -P INPUT =
ACCEPT</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -F INPUT </FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -P OUTPUT =
ACCEPT</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -F OUTPUT </FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -P FORWARD =
DROP</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -F FORWARD </FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -t nat -F</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">echo &quot;&nbsp;&nbsp; FWD: =
Allow all connections OUT and only existing and related ones =
IN&quot;</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -A FORWARD -i $EXTIF =
-o $INTIF -m state --state ESTABLISHED,RELATED -j ACCEPT</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -A FORWARD -i $INTIF =
-o $EXTIF -j ACCEPT</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -A FORWARD -j =
LOG</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">#echo &quot; Allow MSN Messenger =
connection &quot;</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">#$IPTABLES -A FORWARD -p TCP =
--dport 1863 -j ACCEPT</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">#$IPTABLES -A FORWARD -p TCP =
--dport 7801:7825 -j ACCEPT</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">#$IPTABLES -A FORWARD -p TCP =
--dport 6891:6900 -j ACCEPT</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">#$IPTABLES -A FORWARD -d =
64.4.13.0/24 -j ACCEPT</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">echo &quot;&nbsp;&nbsp; Enabling =
SNAT (MASQUERADE) functionality on $EXTIF&quot;</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Courier New">$IPTABLES -t nat -A POSTROUTING =
-o $EXTIF -j MASQUERADE</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">echo -e &quot;\nrc.firewall-2.4 =
v$FWVER done.\n&quot;</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C21972.A1AD71E0--
