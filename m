From: "Chris Poon" <Chris.Poon@TELUS.COM>
Subject: RE: sparc64 kernel, netfilter-20021115, iptables-1.2.7a -
 conntra ck issue with expecting related connections, FTP
Date: Tue, 28 Jan 2003 16:48:58 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <771F217D7A4AF84494632457889470A412D77A@bcmsg011.corp.ads>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="----_=_NextPart_001_01C2C727.D3683230"
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

------_=_NextPart_001_01C2C727.D3683230
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit

After running a kernel with debugging on ip_conntrack_core.c, I can see that it
doesn't find a match in the expected connections list, but the print out suggests
that the expectation for the related connection is set correctly. That points me
to two scenarios: 1) the related connection entry was not found in the expectation
list due to a failed masked comparison or 2) the related connection entry was
found and further operations in ip_conntrack_core.c:init_conntrack invalidated
the expectation. Again, I feel that this might be strictly a 64 bit kernel issue as I'm
sure if the conntrack for related connection didn't work for 32 bit kernels, I would
have found a lot more discussion about it (which I found none so far). And I don't
think this is strictly with FTP connection tracking either, but rather connection
tracking for related connection in general under a 64 bit kernel.

Thanks...

------_=_NextPart_001_01C2C727.D3683230
Content-Type: text/html;
 charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=us-ascii">
<META NAME="Generator" CONTENT="MS Exchange Server version 5.5.2653.12">
<TITLE>RE: sparc64 kernel, netfilter-20021115, iptables-1.2.7a - conntrack issue with expecting related connections, FTP</TITLE>
</HEAD>
<BODY>

<P><FONT SIZE=2>After running a kernel with debugging on ip_conntrack_core.c, I can see that it</FONT>
<BR><FONT SIZE=2>doesn't find a match in the expected connections list, but the print out suggests</FONT>
<BR><FONT SIZE=2>that the expectation for the related connection is set correctly. That points me</FONT>
<BR><FONT SIZE=2>to two scenarios: 1) the related connection entry was not found in the expectation</FONT>
<BR><FONT SIZE=2>list due to a failed masked comparison or 2) the related connection entry was</FONT>
<BR><FONT SIZE=2>found and further operations in ip_conntrack_core.c:init_conntrack invalidated</FONT>
<BR><FONT SIZE=2>the expectation. Again, I feel that this might be strictly a 64 bit kernel issue as I'm</FONT>
<BR><FONT SIZE=2>sure if the conntrack for related connection didn't work for 32 bit kernels, I would</FONT>
<BR><FONT SIZE=2>have found a lot more discussion about it (which I found none so far). And I don't</FONT>
<BR><FONT SIZE=2>think this is strictly with FTP connection tracking either, but rather connection</FONT>
<BR><FONT SIZE=2>tracking for related connection in general under a 64 bit kernel.</FONT>
</P>

<P><FONT SIZE=2>Thanks...</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C2C727.D3683230--
