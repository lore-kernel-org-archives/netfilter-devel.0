From: Willy Tarreau <willy@w.ods.org>
Subject: [PATCH-2.4-POM] replace flags test with lookups (was: CLOSE_WAIT..)
Date: Wed, 8 Oct 2003 15:13:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031008131332.GA2135@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Oct 08, 2003 at 11:44:47AM +0200, Harald Welte wrote:

> > For example, either something like this (byte-aligned) :
> >   u8 tcp_conntracks[6][10] = { (REPLY_STATE)<<4 | (ORIGINAL_STATE), ... }
> >    -> read it from (tcp_conntrack[flag][old_state] >> dir?4:0) & 0xF
> >
> > or (u32 aligned) 80 bytes :
> >   int tcp_conntracks[2][10] = { /* original */
> >                                 { /* old sNO */
> >                                   sSS << SYN | sTW << FIN | sES << ACK ...
> >   -> read id from (tcp_conntrack[dir][old_state] >> flag*4) & 0xF.
> 
> this makes the code really hard to read.  If you can come up with some
> easy-to-read macros, I'd be willing to give it a try.

Well, I've just benchmarked both a u32 and a u8 version against the original
one, on x86. The shift operations are enough to slow them down, so it's not
worth optimizing this way. The u8 implementation is already 50% slower than the
original one, and the u32 implementation is twice as slow as the original one.

But I think that porting latest ipt_unclean changes to ip_conntrack_proto_tcp
should at least give a slight boost (just compiled it, did not test) :


--- ./net/ipv4/netfilter/ip_conntrack_proto_tcp.c.old	Tue Oct  7 23:07:12 2003
+++ ./net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Wed Oct  8 15:02:15 2003
@@ -657,6 +657,24 @@
 #define	TH_ECE	0x40
 #define	TH_CWR	0x80
 
+/* table of valid flag combinations - ECE and CWR are always valid */
+static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
+{
+	[TH_SYN]			= 1,
+	[TH_SYN|TH_ACK]			= 1,
+	[TH_RST]			= 1,
+	[TH_RST|TH_ACK]			= 1,
+	[TH_RST|TH_ACK|TH_PUSH]		= 1,
+	[TH_FIN|TH_ACK]			= 1,
+	[TH_ACK]			= 1,
+	[TH_ACK|TH_PUSH]		= 1,
+	[TH_ACK|TH_URG]			= 1,
+	[TH_ACK|TH_URG|TH_PUSH]		= 1,
+	[TH_FIN|TH_ACK|TH_PUSH]		= 1,
+	[TH_FIN|TH_ACK|TH_URG]		= 1,
+	[TH_FIN|TH_ACK|TH_URG|TH_PUSH]	= 1
+};
+
 /* Protect conntrack agaist unclean packets. Code taken from ipt_unclean.c.  */
 static int unclean(struct iphdr *iph, size_t len)
 {
@@ -684,19 +702,7 @@
 
 	/* CHECK: TCP flags. */
 	tcpflags = (((u_int8_t *)tcph)[13] & ~(TH_ECE|TH_CWR));
-	if (tcpflags != TH_SYN
-	    && tcpflags != (TH_SYN|TH_ACK)
-	    && tcpflags != TH_RST
-	    && tcpflags != (TH_RST|TH_ACK)
-	    && tcpflags != (TH_RST|TH_ACK|TH_PUSH)
-	    && tcpflags != (TH_FIN|TH_ACK)
-	    && tcpflags != TH_ACK
-	    && tcpflags != (TH_ACK|TH_PUSH)
-	    && tcpflags != (TH_ACK|TH_URG)
-	    && tcpflags != (TH_ACK|TH_URG|TH_PUSH)
-	    && tcpflags != (TH_FIN|TH_ACK|TH_PUSH)
-	    && tcpflags != (TH_FIN|TH_ACK|TH_URG)
-	    && tcpflags != (TH_FIN|TH_ACK|TH_URG|TH_PUSH)) {
+	if (!tcp_valid_flags[tcpflags]) {
 		if (NET_RATELIMIT(ip_ct_tcp_log_out_of_window))
 			nf_log_ip((char *)iph, len, 
 				  "ip_conntrack_tcp: INVALID: invalid TCP flag combination ");


Regards,
Willy
