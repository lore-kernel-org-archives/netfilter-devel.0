From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 4/8] Fix racy counters zeroing
Date: Tue, 08 Nov 2005 02:44:33 +0100
Message-ID: <43700301.1060401@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060208030005030506050703"
Cc: Harald Welte <laforge@netfilter.org>
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
--------------060208030005030506050703
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Fix racy zero counters operation at getting.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------060208030005030506050703
Content-Type: text/plain;
 name="03-zeroing.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-zeroing.patch"

Fix racy zero counters operation at getting.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-06 19:09:20.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-06 19:25:09.000000000 +0100
@@ -770,18 +770,20 @@ ctnetlink_get_conntrack(struct sock *ctn
 	if (err < 0)
 		return err;
 
-	h = ip_conntrack_find_get(&tuple, NULL);
+	write_lock_bh(&ip_conntrack_lock);
+	h = __ip_conntrack_find(&tuple, NULL);
 	if (!h) {
 		DEBUGP("tuple not found in conntrack hash");
+		write_unlock_bh(&ip_conntrack_lock);
 		return -ENOENT;
 	}
 	DEBUGP("tuple found\n");
 	ct = tuplehash_to_ctrack(h);
 
 	err = -ENOMEM;
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2) {
-		ip_conntrack_put(ct);
+		write_unlock_bh(&ip_conntrack_lock);
 		return -ENOMEM;
 	}
 	NETLINK_CB(skb2).dst_pid = NETLINK_CB(skb).pid;
@@ -794,7 +796,7 @@ ctnetlink_get_conntrack(struct sock *ctn
 		memset(&ct->counters, 0, sizeof(ct->counters));
 #endif
 	
-	ip_conntrack_put(ct);
+	write_unlock_bh(&ip_conntrack_lock);
 	if (err <= 0)
 		goto free;
 

--------------060208030005030506050703--
