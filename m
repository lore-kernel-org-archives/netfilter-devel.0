From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [CTNETLINK] Fix compilation with debugging enabled
Date: Tue, 10 Oct 2006 03:10:22 +0200
Message-ID: <452AF2FE.1050606@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030900050708090907050202"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------030900050708090907050202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Two debugging messages inside dump_table refer to variable `id'
that is not declared anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------030900050708090907050202
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[CTNETLINK] Fix compilation with debugging enabled

two debugging messages inside dump_table refer to variable `id'
that is not declared anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-10-10 03:00:00.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-10-10 03:01:36.000000000 +0200
@@ -411,8 +411,7 @@ ctnetlink_dump_table(struct sk_buff *skb
 	struct ip_conntrack_tuple_hash *h;
 	struct list_head *i;
 
-	DEBUGP("entered %s, last bucket=%lu id=%u\n", __FUNCTION__, 
-			cb->args[0], *id);
+	DEBUGP("entered %s, last bucket=%lu\n", __FUNCTION__, cb->args[0]);
 
 	read_lock_bh(&ip_conntrack_lock);
 	last = (struct ip_conntrack *)cb->args[1];
@@ -452,7 +451,7 @@ out:
 	if (last)
 		ip_conntrack_put(last);
 
-	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
+	DEBUGP("leaving, last bucket=%lu\n", cb->args[0]);
 	return skb->len;
 }
 
Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-10-10 03:02:35.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-10-10 03:03:29.000000000 +0200
@@ -425,8 +425,7 @@ ctnetlink_dump_table(struct sk_buff *skb
 	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
-	DEBUGP("entered %s, last bucket=%lu id=%u\n", __FUNCTION__, 
-			cb->args[0], *id);
+	DEBUGP("entered %s, last bucket=%lu\n", __FUNCTION__, cb->args[0]);
 
 	read_lock_bh(&nf_conntrack_lock);
 	last = (struct nf_conn *)cb->args[1];
@@ -471,7 +470,7 @@ out:
 	if (last)
 		nf_ct_put(last);
 
-	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
+	DEBUGP("leaving, last bucket=%lu\n", cb->args[0]);
 	return skb->len;
 }
 

--------------030900050708090907050202--
