From: Paul Spink <paul.spink@SurfControl.com>
Subject: Module Only Receiving First Packet Of Connection
Date: Thu, 4 Sep 2003 14:58:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <B1BE16C7DD91C846821C56B5F7CEDDC60A486A@bell.surfcontrol.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="--=_NextPart_ST_14_57_20_Thursday_September_04_2003_16035"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
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

----=_NextPart_ST_14_57_20_Thursday_September_04_2003_16035
Content-Type: text/plain

> Hi there,
> 
> I am trying to create a module that will examine all HTTP GET requests.
> My problem is whenever I insert my module, it only ever sees the first TCP
> packet of the connection (for the same <source IP:port> / <destination
> IP:port> combination), I never get to see the HTTP GET requests or
> subsequent TCP packets.
> 
> The hook is registered on the NF_IP_POST_ROUTING hook.  I set skb->nfcache
> |= NFC_UNKNOWN in my hook before returning NF_QUEUE.  The queue handler
> prints out the source and destination IPs and ports into the system log,
> then calls nf_reinject with NF_ACCEPT to accept the packets.
> 
> Any advice you can give me as to what I am doing wrong?  And how I can log
> all the HTTP requests?
> 
> Thanks, Paul.

Get the latest news on SurfControl and our products,
subscribe to our monthly e-newsletter, SurfAdvisory at:
http://surfcontrol.us-hosts.com/sc/subscribe

*********************************************************************
The information in this email is confidential and may be legally
privileged. It is intended solely for the addressee. Access to this
email by anyone else is unauthorized. If you are not the intended
recipient, any disclosure, copying, distribution or any action taken
or omitted to  be taken in reliance on it, is prohibited and may be
unlawful. If you believe that you have received this email in error,
please contact the sender.
*********************************************************************

----=_NextPart_ST_14_57_20_Thursday_September_04_2003_16035
Content-Type: text/html
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Dus-ascii"=
>
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version 5.5.2653.12"=
>
<TITLE>Module Only Receiving First Packet Of Connection</TITLE>
</HEAD>
<BODY>

<P><FONT SIZE=3D2 FACE=3D"Arial">Hi there,</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">I am trying to create a module that will e=
xamine all HTTP GET requests.&nbsp; My problem is whenever I insert my modu=
le, it only ever sees the first TCP packet of the connection (for the same =
&lt;source IP:port&gt; / &lt;destination IP:port&gt; combination), I never =
get to see the HTTP GET requests or subsequent TCP packets.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">The hook is registered on the NF_IP_POST_R=
OUTING hook.&nbsp; I set skb-&gt;nfcache |=3D NFC_UNKNOWN in my hook before=
 returning NF_QUEUE.&nbsp; The queue handler prints out the source and dest=
ination IPs and ports into the system log, then calls nf_reinject with NF_A=
CCEPT to accept the packets.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Any advice you can give me as to what I am=
 doing wrong?&nbsp; And how I can log all the HTTP requests?</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Thanks, Paul.</FONT>
</P>

<br><br>Get the latest news on SurfControl and our products,<br>subscribe t=
o our monthly e-newsletter, SurfAdvisory at:<br>http://surfcontrol.us-hosts=
=2Ecom/sc/subscribe<br><br>************************************************=
*********************<br>The information in this email is confidential and =
may be legally<br>privileged. It is intended solely for the addressee. Acce=
ss to this<br>email by anyone else is unauthorized. If you are not the inte=
nded<br>recipient, any disclosure, copying, distribution or any action take=
n<br>or omitted to  be taken in reliance on it, is prohibited and may be<br=
>unlawful. If you believe that you have received this email in error,<br>pl=
ease contact the sender.<br>***********************************************=
**********************<br></BODY>
</HTML>
----=_NextPart_ST_14_57_20_Thursday_September_04_2003_16035--
