From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] netfilter: ECN target corrupts packets (2.6 only)
Date: Sun, 02 Jan 2005 22:17:40 +1100
Message-ID: <1104664660.17292.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Name: ipt_ECN corrupt checksum fix
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Nasty bug, caught while writing the ECN target test.  Corrupts
checksums of packets when target is used on them.

Let this be a warning on the evils of casts.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ipt_ECN.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ipt_ECN.c	2005-01-02 21:47:31.439866944 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ipt_ECN.c	2005-01-02 21:56:47.396348712 +1100
@@ -67,7 +67,7 @@
 
 	if (einfo->operation & IPT_ECN_OP_SET_CWR)
 		th->cwr = einfo->proto.tcp.cwr;
-	diffs[1] = ((u_int16_t *)&th)[6];
+	diffs[1] = ((u_int16_t *)th)[6];
 
 	/* Only mangle if it's changed. */
 	if (diffs[0] != diffs[1]) {

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
