From: Lockenvitz Jan EXT <Jan.Lockenvitz.extern@icn.siemens.de>
Subject: RPC Conntrack - DUMP - fragmentation
Date: Wed, 31 Mar 2004 17:13:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <47D438A0510BD611B9470002A58EDAE703BE6962@mchh2a6e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C41732.AC686846"
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

------_=_NextPart_001_01C41732.AC686846
Content-Type: text/plain

Hi,

we (my colleague and me) tried to track NFS  between two LINUX boxes with the 
RPC Conntracking modules installed via P-O-M. Well, we wondered why this was not working.
So we had a look into the sources.
It loks like the RPC modules cannot handle DUMP requests and responses (only GET
seems to be possible). So we (mainly my colleague) started to insert some code for the
DUMP packets. And it is already working some how ;-)

And now the Problem: The DUMP Response is listing all RPC Services the Server offers and 
so the packet length would be about 400 Byte. And the packet is fragmentet !!
Well, I don't know why the TCP packet needs to be fragmentet at 400 byte? The MTU is set to 1500.
Our main problem is, how can we handle the fragmented packets in the netfilter achitecture???

We can already check whether the DUMP response is fragmeted or not. But we don't know how
to concatenate the information from both fragments.

Thanx in advance,
Jan

------_=_NextPart_001_01C41732.AC686846
Content-Type: text/html

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=us-ascii">
<META NAME="Generator" CONTENT="MS Exchange Server version 5.5.2657.73">
<TITLE>RPC Conntrack - DUMP - fragmentation</TITLE>
</HEAD>
<BODY>

<P><FONT SIZE=2 FACE="Arial">Hi,</FONT>
</P>

<P><FONT SIZE=2 FACE="Arial">we (my colleague and me) tried to track NFS&nbsp; between two LINUX boxes with the </FONT>
<BR><FONT SIZE=2 FACE="Arial">RPC Conntracking modules installed via P-O-M. Well, we wondered why this was not working.</FONT>
<BR><FONT SIZE=2 FACE="Arial">So we had a look into the sources.</FONT>
<BR><FONT SIZE=2 FACE="Arial">It loks like the RPC modules cannot handle DUMP requests and responses (only GET</FONT>
<BR><FONT SIZE=2 FACE="Arial">seems to be possible). So we (mainly my colleague) started to insert some code for the</FONT>
<BR><FONT SIZE=2 FACE="Arial">DUMP packets. And it is already working some how ;-)</FONT>
</P>

<P><FONT SIZE=2 FACE="Arial">And now the Problem: The DUMP Response is listing all RPC Services the Server offers and </FONT>
<BR><FONT SIZE=2 FACE="Arial">so the packet length would be about 400 Byte. And the packet is fragmentet !!</FONT>
<BR><FONT SIZE=2 FACE="Arial">Well, I don't know why the TCP packet needs to be fragmentet at 400 byte? The MTU is set to 1500.</FONT>
<BR><FONT SIZE=2 FACE="Arial">Our main problem is, how can we handle the fragmented packets in the netfilter achitecture???</FONT>
</P>

<P><FONT SIZE=2 FACE="Arial">We can already check whether the DUMP response is fragmeted or not. But we don't know how</FONT>
<BR><FONT SIZE=2 FACE="Arial">to concatenate the information from both fragments.</FONT>
</P>

<P><FONT SIZE=2 FACE="Arial">Thanx in advance,</FONT>
<BR><FONT SIZE=2 FACE="Arial">Jan</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C41732.AC686846--
