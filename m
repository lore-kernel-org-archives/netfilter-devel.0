From: Manickavel Subramaniraj <MSubramaniraj@MEGISTO.com>
Subject: IP Queue and fragmentation
Date: Tue, 11 Feb 2003 12:10:35 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <C3F7A1AD0781F84784B5528466CA09DD04F4E0@megisto-sql1>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C2D1F0.7E2B0520"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

------_=_NextPart_001_01C2D1F0.7E2B0520
Content-Type: text/plain;
	charset="iso-8859-1"

All:
    I need some help in IP queue. I am passing IP packets to user space
using IP Queue by setting up iptables as follows 
 
iptables -A FORWARD -p udp -d 10.10.0.0/16 - j QUEUE
 
What I am trying to do is in Linux 2.4 kernel is to create a  transparent
proxy(UDP), where application needs reassembled IP packet.  Looks like  IP
queue does not reassemble the packet before sending to the user space ( is
it true). If that is case  
 
1) Is any thing that I can do to reassemble the packet before sending to
user space?
2) Is there any user space reassembly code available?. so I can try to
reassemble the packet in user space.
 
Thank
Vel..

------_=_NextPart_001_01C2D1F0.7E2B0520
Content-Type: text/html;
	charset="iso-8859-1"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">


<META content="MSHTML 5.00.3103.1000" name=GENERATOR></HEAD>
<BODY>
<DIV><FONT face=Arial size=2><SPAN 
class=550325916-11022003>All:</SPAN></FONT></DIV>
<DIV><FONT face=Arial size=2><SPAN class=550325916-11022003>&nbsp;&nbsp;&nbsp; I 
need some help in IP queue. I am passing IP packets to user space using IP Queue 
by setting up iptables as follows </SPAN></FONT></DIV>
<DIV><FONT face=Arial size=2><SPAN 
class=550325916-11022003></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2><SPAN class=550325916-11022003>iptables -A FORWARD 
-p udp -d 10.10.0.0/16 - j QUEUE</SPAN></FONT></DIV>
<DIV><FONT face=Arial size=2><SPAN 
class=550325916-11022003></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2><SPAN class=550325916-11022003>What I am trying to 
do is in Linux 2.4 kernel is to create a&nbsp; transparent proxy(UDP), where 
application needs reassembled IP packet.&nbsp; Looks like&nbsp; IP queue does 
not reassemble the packet before sending to the user space ( is it true). If 
that is case&nbsp; </SPAN></FONT></DIV>
<DIV><FONT face=Arial size=2><SPAN 
class=550325916-11022003></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2><SPAN class=550325916-11022003>1) Is any thing that 
I can do to reassemble the packet before sending to user 
space?</SPAN></FONT></DIV>
<DIV><FONT face=Arial size=2><SPAN class=550325916-11022003>2) Is there any user 
space reassembly code available?. so I can try to reassemble the packet in user 
space.</SPAN></FONT></DIV>
<DIV><FONT face=Arial size=2><SPAN 
class=550325916-11022003></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2><SPAN 
class=550325916-11022003>Thank<BR>Vel..</SPAN></FONT></DIV></BODY></HTML>

------_=_NextPart_001_01C2D1F0.7E2B0520--
