From: "Reilly, John" <john@xelector.com>
Subject: RE: Is it possible
Date: Sat, 6 Jul 2002 16:15:41 +0100
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <F54DD05BD063D411920200D0B77E68510131F133@mail.xelector.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C224FF.FDF30DA0"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: 'Peter Gosens' <ptha@mac.com>, netfilter-devel@lists.samba.org
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

------_=_NextPart_001_01C224FF.FDF30DA0
Content-Type: text/plain;
	charset="iso-8859-1"

Since forwarding/proxying is based on hostname, it must be proxied based on
application protocol (if the hostname is included into the protocol
request/response).
 
For http you can use apache with mod_proxy to do the proxying.  I'm not sure
about https - I think I've heard that the different virtual servers in
apache need different IP addresses for the certs to work correctly in all
cases, but I'm not 100% sure about that.
 
Cheers,
jr

Is it possible to make iptables forward packets based on hostname. 
 
I've one.cc.com and two.cc.com three.cc.com pointing to 213.93.43.28 . And I
want that traffic with one.cc.com is going to 213.93.43.84. But the
two.cc.com and three.cc.com traffic need to be forwarded to an internal
network ip (suchs as 192.168.100.2).
 
Is this possible with iptables. Or do I have to add an loadbalancer or use
an proxy. I also thought about using ipv6, but it has an lack of supporting
program's.
 
If you have any other idea's about this matter. Please tell me.
 
Peter Gosens


------_=_NextPart_001_01C224FF.FDF30DA0
Content-Type: text/html;
	charset="iso-8859-1"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">


<META content="MSHTML 5.00.2920.0" name=GENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=#ffffff>
<DIV><FONT color=#0000ff face=Arial size=2><SPAN class=703390015-06072002>Since 
forwarding/proxying is based on hostname, it must be proxied based on 
application protocol (if the hostname is included into the protocol 
request/response).</SPAN></FONT></DIV>
<DIV><FONT color=#0000ff face=Arial size=2><SPAN 
class=703390015-06072002></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT color=#0000ff face=Arial size=2><SPAN class=703390015-06072002>For 
http you can use apache with mod_proxy to do the proxying.&nbsp; I'm not sure 
about https - I think I've heard that the different virtual servers in apache 
need different IP addresses for the certs to work correctly in all cases, but 
I'm not 100% sure about that.</SPAN></FONT></DIV>
<DIV><FONT color=#0000ff face=Arial size=2><SPAN 
class=703390015-06072002></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT color=#0000ff face=Arial size=2><SPAN 
class=703390015-06072002>Cheers,</SPAN></FONT></DIV>
<DIV><FONT color=#0000ff face=Arial size=2><SPAN 
class=703390015-06072002>jr</SPAN></FONT></DIV>
<BLOCKQUOTE 
style="BORDER-LEFT: #0000ff 2px solid; MARGIN-LEFT: 5px; MARGIN-RIGHT: 0px; PADDING-LEFT: 5px">
  <DIV><FONT face=Arial size=2>Is it possible to make iptables forward packets 
  based on hostname. </FONT></DIV>
  <DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
  <DIV><FONT face=Arial size=2>I've one.cc.com and two.cc.com three.cc.com 
  pointing to 213.93.43.28 . </FONT><FONT face=Arial size=2>And I want that 
  traffic with one.cc.com is going to 213.93.43.84. But&nbsp;the two.cc.com and 
  three.cc.com traffic need&nbsp;to be forwarded to an internal network ip 
  (suchs as 192.168.100.2).</FONT></DIV>
  <DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
  <DIV><FONT face=Arial size=2>Is this possible with iptables.&nbsp;Or do I have 
  to&nbsp;add an loadbalancer or&nbsp;use an proxy. I also thought about using 
  ipv6, but it has an&nbsp;lack of supporting program's.</FONT></DIV>
  <DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
  <DIV><FONT face=Arial size=2>If you have any other idea's about this matter. 
  Please tell me.</FONT></DIV>
  <DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
  <DIV><FONT face=Arial size=2>Peter 
Gosens</FONT></DIV></BLOCKQUOTE></BODY></HTML>

------_=_NextPart_001_01C224FF.FDF30DA0--
