From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/41]: {ip,ip6}t_LOG: print MARK value in log output
Date: Mon, 14 Apr 2008 12:16:21 +0200 (MEST)
Message-ID: <20080414101617.32717.16444.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36236 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYDNKQW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:22 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {ip,ip6}t_LOG: print MARK value in log output

Dump the mark value in log messages similar to nfnetlink_log. This
is useful for debugging complex setups where marks are used for
routing or traffic classification.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 52a366629fe76eafd33688021b56dddd07d7ae56
tree 88118647f71653702c239bfdcc5eacf7dabbf3a5
parent 8ee4a745f7f5faa662eb8140b60331743b63adf4
author Patrick McHardy <kaber@trash.net> Thu, 20 Mar 2008 15:15:45 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:32 +0200

 net/ipv4/netfilter/ipt_LOG.c  |    6 +++++-
 net/ipv6/netfilter/ip6t_LOG.c |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index b38d785..c40e233 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -338,12 +338,16 @@ static void dump_packet(const struct nf_loginfo *info,
 	if ((logflags & IPT_LOG_UID) && !iphoff && skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
-			printk("UID=%u GID=%u",
+			printk("UID=%u GID=%u ",
 				skb->sk->sk_socket->file->f_uid,
 				skb->sk->sk_socket->file->f_gid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 
+	/* Max length: 16 "MARK=0xFFFFFFFF " */
+	if (!iphoff && skb->mark)
+		printk("MARK=0x%x ", skb->mark);
+
 	/* Proto    Max log string length */
 	/* IP:      40+46+6+11+127 = 230 */
 	/* TCP:     10+max(25,20+30+13+9+32+11+127) = 252 */
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 86a6138..3a23169 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -363,11 +363,15 @@ static void dump_packet(const struct nf_loginfo *info,
 	if ((logflags & IP6T_LOG_UID) && recurse && skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
-			printk("UID=%u GID=%u",
+			printk("UID=%u GID=%u ",
 				skb->sk->sk_socket->file->f_uid,
 				skb->sk->sk_socket->file->f_gid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
+
+	/* Max length: 16 "MARK=0xFFFFFFFF " */
+	if (!recurse && skb->mark)
+		printk("MARK=0x%x ", skb->mark);
 }
 
 static struct nf_loginfo default_loginfo = {
