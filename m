From: Michael Pogrebisky <mic@mercury.co.il>
Subject: Port Triggering and Netfilter
Date: Thu, 12 Jun 2003 13:57:54 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <B5AA414A16B5D411B16B0002A507F5B0034600FC@exchil02.mercury.co.il>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C330D1.7992FC80"
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

------_=_NextPart_001_01C330D1.7992FC80
Content-Type: text/plain

Hi,

 

Sorry for lengthy e-mail. But, please, read on, it may worth it.

 

I'm trying to find a solution for making Microsoft ActiveSync to work
through my Linux firewall.

ActiveSync is used for synchronization between a desktop computer running
ActiveSync agent and a Windows CE device. This synchronization is possible
in numerous ways, including through a TCP/IP connection.

In essence, the client (Windows CE device) opens a TCP connection to the
server on port 5678. The server, in its turn, opens a connection back to the
client port 990.

 

How it can be supported with Netfilter?

For my understanding, with no NAT, just port 990 should be kept open to
inbound TCP connections. When NAT is used, it's still solvable through DNAT
if the IP address of the Windows CE device is known in advance.

The question is how to solve this when Windows CE obtains its IP address
through DHCP.

I looked extensively through Netfilter docs but failed to find anything
useful. Did I miss something?

 

Here, Port Triggering can come to my rescue.

Port Triggering is a popular extension found on some consumer-grade hardware
routers (including some Linux-based ones).

In essence, it allows opening (and correct DNAT-ing, if necessary) of
certain inbound firewall ports if some outbound activity on some other ports
has been seen from within the private network.

This functionality is somewhat similar to non-passive FTP. The difference is
that outbound packet analysis is not required for determining the correct
inbound ports, but instead these ports are simply known in advance.

As you can see, this makes perfect solution for my ActiveSync problem.

 

Why Port Triggering is so useful?

First of all, even without NAT, or with NAT and static client IP address, it
still provides better firewalling solution because it doesn't just keep port
990 open to everybody, but only to the packets related to a previously
opened outbound connection to a certain machine. This alone is already a big
advantage, since it improves firewall security.

Second, it provides a solution for NAT + dynamic client IP situations, which
I currently was unable to find with Netfilter.

 

Finally, my last question, does it make sense to add a support for Port
Triggering to Netfilter?

Basically, I thought about the following:

1.       The incoming packets on the triggered ports should be recognized as
RELATED instead of NEW when appropriate. This will make dealing with them
exactly the same as incoming FTP data connections, which are, in most cases,
allowed.

2.       For definition of the inbound triggered ports, I suggest the
following new target:

 

TRIGGER

            --triggered_port (--tport)

                        Ports that can be triggered. Can be either single
number, comma-separated list or colon-separated range. Mandatory.

            --triggered_protocol (--tprotocol)

                        Protocols that can be triggered - defined
identically to all other places where protocol definitions can appear.
Default is "all".

            --triggered_destination (--tdestination)

                        Destination IP. Can be used with usual IP stuff
(bits and masks). Default: source IP of the matching packet (before NAT
translation, if occurred).

            --triggered_source (--tsource)

                        Source IP. Can be used with usual IP stuff (bits and
masks). Default: destination IP of the matching packet.

            --trigger_timeout (--ttimeout)

                        Maximum time interval from when the matching packet
was seen during which the incoming packet is expected. I currently have no
clue what the good default value should be.

 

I think this covers pretty well Port Triggering needs.

 

What do you think?

 

Thanks,

 

Michael.



________________________________________________________________________
This email has been scanned for all viruses. 

Mercury Interactive Corporation
Optimizing Business Processes to Maximize Business Results 

http://www.merc-int.com
________________________________________________________________________
------_=_NextPart_001_01C330D1.7992FC80
Content-Type: text/html

<html>

<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=us-ascii">


<meta name=Generator content="Microsoft Word 10 (filtered)">

<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{font-family:Arial;
	color:windowtext;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=EN-US link=blue vlink=purple>

<div class=Section1>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Hi,</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Sorry for lengthy e-mail. But, please, read on, it may worth
it.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>I'm trying to find a solution for making Microsoft
ActiveSync to work through my Linux firewall.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>ActiveSync is used for synchronization between a desktop
computer running ActiveSync agent and a Windows CE device. This synchronization
is possible in numerous ways, including through a TCP/IP connection.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>In essence, the client (Windows CE device) opens a TCP
connection to the server on port 5678. The server, in its turn, opens a
connection back to the client port 990.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>How it can be supported with Netfilter?</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>For my understanding, with no NAT, just port 990 should be
kept open to inbound TCP connections. When NAT is used, it's still solvable
through DNAT if the IP address of the Windows CE device is known in advance.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>The question is how to solve this when Windows CE obtains
its IP address through DHCP.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>I looked extensively through Netfilter docs but failed to
find anything useful. Did I miss something?</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Here, Port Triggering can come to my rescue.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Port Triggering is a popular extension found on some
consumer-grade hardware routers (including some Linux-based ones).</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>In essence, it allows opening (and correct DNAT-ing, if
necessary) of certain inbound firewall ports if some outbound activity on some
other ports has been seen from within the private network.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>This functionality is somewhat similar to non-passive FTP.
The difference is that outbound packet analysis is not required for determining
the correct inbound ports, but instead these ports are simply known in advance.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>As you can see, this makes perfect solution for my
ActiveSync problem.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Why Port Triggering is so useful?</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>First of all, even without NAT, or with NAT and static
client IP address, it still provides better firewalling solution because it
doesn't just keep port 990 open to everybody, but only to the packets related
to a previously opened outbound connection to a certain machine. This alone is
already a big advantage, since it improves firewall security.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Second, it provides a solution for NAT + dynamic client IP
situations, which I currently was unable to find with Netfilter.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Finally, my last question, does it make sense to add a
support for Port Triggering to Netfilter?</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Basically, I thought about the following:</span></font></p>

<p class=MsoNormal style='margin-left:.25in;text-indent:-.25in'><font size=2
face=Arial><span style='font-size:10.0pt;font-family:Arial'>1.</span></font><font
size=1><span style='font-size:7.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></font><font
size=2 face=Arial><span style='font-size:10.0pt;font-family:Arial'>The incoming
packets on the triggered ports should be recognized as RELATED instead of NEW
when appropriate. This will make dealing with them exactly the same as incoming
FTP data connections, which are, in most cases, allowed.</span></font></p>

<p class=MsoNormal style='margin-left:.25in;text-indent:-.25in'><font size=2
face=Arial><span style='font-size:10.0pt;font-family:Arial'>2.</span></font><font
size=1><span style='font-size:7.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></font><font
size=2 face=Arial><span style='font-size:10.0pt;font-family:Arial'>For
definition of the inbound triggered ports, I suggest the following new target:</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>TRIGGER</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
--triggered_port (--tport)</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Ports that can be triggered. Can be either single number, comma-separated list
or colon-separated range. Mandatory.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
--triggered_protocol (--tprotocol)</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Protocols that can be triggered - defined identically to all other places where
protocol definitions can appear. Default is &quot;all&quot;.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
--triggered_destination (--tdestination)</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Destination IP. Can be used with usual IP stuff (bits and masks). Default:
source IP of the matching packet (before NAT translation, if occurred).</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
--triggered_source (--tsource)</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Source IP. Can be used with usual IP stuff (bits and masks). Default:
destination IP of the matching packet.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
--trigger_timeout (--ttimeout)</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Maximum time interval from when the matching packet was seen during which the
incoming packet is expected. I currently have no clue what the good default
value should be.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>I think this covers pretty well Port Triggering needs.</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>What do you think?</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Thanks,</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Michael.</span></font></p>

</div>

</body>

</html>


<HTML><BODY><BR>
________________________________________________________________________<BR>
This email has been scanned for all viruses. <BR>
<BR>
Mercury Interactive Corporation<BR>
Optimizing Business Processes to Maximize Business Results <BR>
<BR>
<A 
href=http://www.merc-int.com>
http://www.merc-int.com</A><BR>
________________________________________________________________________<BR>
</BODY></HTML>

------_=_NextPart_001_01C330D1.7992FC80--
