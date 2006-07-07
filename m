From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/10][CTNETLINK] dump counters iif connection ended or
 counters filled up
Date: Fri, 07 Jul 2006 04:15:25 +0200
Message-ID: <44ADC3BD.3050609@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090802050304020400010803"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------090802050304020400010803
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch makes ctnetlink to dump counters iif connection reaches the
destroy state or altenatively if counters filled up.

AFAICS counters on NEW and UPDATE events doesn't provide interesting
information, they just consume the limited netlink bandwidth.

Upcoming conntrackd release in statistics mode uses counters from
DESTROY events to keep the contability of traffic that the firewall has
processed.

I think that this patch should also reset counters upon fill up event,
comments?

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris


--------------090802050304020400010803
Content-Type: text/plain;
 name="06counters.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06counters.patch"

[CTNETLINK] dump counters iif connection ended or counters filled up

This patch makes ctnetlink to dump counters iif connection reaches the
destroy state or altenatively if counters filled up.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-06 19:52:54.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-06 19:54:00.000000000 +0200
@@ -381,8 +381,10 @@ static int ctnetlink_conntrack_event(str
 	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nfattr_failure;
 
-	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
+	/* this connection has died or counters wrapped around */
+	if ((events & IPCT_DESTROY || events & IPCT_COUNTER_FILLING)
+	    && (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+	        ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
 		goto nfattr_failure;
 
 	if (events & IPCT_MARK
Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-07-06 19:54:02.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-07-06 19:54:35.000000000 +0200
@@ -391,8 +391,10 @@ static int ctnetlink_conntrack_event(str
 	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nfattr_failure;
 
-	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
+	/* this connection has died or counters wrapped around */
+	if ((events & IPCT_DESTROY || events & IPCT_COUNTER_FILLING)
+	     && (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+		 ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
 		goto nfattr_failure;
 
 	if (events & IPCT_MARK

--------------090802050304020400010803--
