From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_conntrack_ipv4: fix module parameter compatibility
Date: Sat, 22 Dec 2007 09:42:54 +0100
Message-ID: <476CCE0E.2000800@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040401040102040106010007"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34996 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbXLVIm4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Dec 2007 03:42:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040401040102040106010007
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------040401040102040106010007
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 0d5dbdc9b0d5168efc29b6261ad6d2ce7c4bbaae
Author: Patrick McHardy <kaber@trash.net>
Date:   Sat Dec 22 09:41:31 2007 +0100

    [NETFILTER]: nf_conntrack_ipv4: fix module parameter compatibility
    
    Some users do "modprobe ip_conntrack hashsize=...". Since we have the
    module aliases this loads nf_conntrack_ipv4 and nf_conntrack, the
    hashsize parameter is unknown for nf_conntrack_ipv4 however and makes
    it fail.
    
    Allow to specify hashsize= for both nf_conntrack and nf_conntrack_ipv4.
    
    Note: the nf_conntrack message in the ringbuffer will display an
    incorrect hashsize since nf_conntrack is first pulled in as a
    dependency and calculates the size itself, then it gets changed
    through a call to nf_conntrack_set_hashsize().
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 90fb66d..4ac5ab1 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -249,6 +249,7 @@ static inline int nf_ct_is_untracked(const struct sk_buff *skb)
 	return (skb->nfct == &nf_conntrack_untracked.ct_general);
 }
 
+extern int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp);
 extern unsigned int nf_conntrack_htable_size;
 extern int nf_conntrack_checksum;
 extern atomic_t nf_conntrack_count;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 831e9b2..910dae7 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -419,6 +419,9 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 	.me		 = THIS_MODULE,
 };
 
+module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
+		  &nf_conntrack_htable_size, 0600);
+
 MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
 MODULE_ALIAS("ip_conntrack");
 MODULE_LICENSE("GPL");
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 000c2fb..a4d5cde 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1016,7 +1016,7 @@ struct hlist_head *nf_ct_alloc_hashtable(int *sizep, int *vmalloced)
 }
 EXPORT_SYMBOL_GPL(nf_ct_alloc_hashtable);
 
-int set_hashsize(const char *val, struct kernel_param *kp)
+int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 {
 	int i, bucket, hashsize, vmalloced;
 	int old_vmalloced, old_size;
@@ -1063,8 +1063,9 @@ int set_hashsize(const char *val, struct kernel_param *kp)
 	nf_ct_free_hashtable(old_hash, old_vmalloced, old_size);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nf_conntrack_set_hashsize);
 
-module_param_call(hashsize, set_hashsize, param_get_uint,
+module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
 		  &nf_conntrack_htable_size, 0600);
 
 int __init nf_conntrack_init(void)

--------------040401040102040106010007--
