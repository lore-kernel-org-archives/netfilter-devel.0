From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/49]: {ip,ip6}t_LOG: log GID
Date: Tue,  4 Dec 2007 13:02:21 +0100 (MET)
Message-ID: <20071204120220.2442.46395.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62154 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbXLDMCW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:22 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {ip,ip6}t_LOG: log GID

Log GID in addition to UID

Signed-off-by: Maciej Soltysiak <maciej.soltysiak@ae.poznan.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5ccda5a2efbe4c504144db8fae1861a795a39258
tree be4c00aed3c33d4528c37a5f9ae509381db0552e
parent 57b89170e9765f9ce899abf12ac4e0a91b5cc42c
author Maciej Soltysiak <maciej.soltysiak@ae.poznan.pl> Tue, 04 Dec 2007 10:47:10 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:28:11 +0100

 net/ipv4/netfilter/ipt_LOG.c  |    4 +++-
 net/ipv6/netfilter/ip6t_LOG.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index fba2155..f8c613a 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -337,7 +337,9 @@ static void dump_packet(const struct nf_loginfo *info,
 	if ((logflags & IPT_LOG_UID) && !iphoff && skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
-			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+			printk("UID=%u GID=%u",
+				skb->sk->sk_socket->file->f_uid,
+				skb->sk->sk_socket->file->f_gid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index cd51c42..1952324 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -362,7 +362,9 @@ static void dump_packet(const struct nf_loginfo *info,
 	if ((logflags & IP6T_LOG_UID) && recurse && skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
-			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+			printk("UID=%u GID=%u",
+				skb->sk->sk_socket->file->f_uid,
+				skb->sk->sk_socket->file->f_gid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 }
