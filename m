From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [RFC PATCH 1/5] netlink: mmap: introduce mmaped skb helper functions
Date: Wed, 22 Jul 2015 10:10:52 +0900
Message-ID: <20150722011052.GB30012@gmail.com>
References: <20150722010938.GA30012@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36729 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802AbbGVBK5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jul 2015 21:10:57 -0400
Received: by pachj5 with SMTP id hj5so129082185pac.3
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2015 18:10:57 -0700 (PDT)
Received: from gmail.com (softbank220009032004.bbtec.net. [220.9.32.4])
        by smtp.gmail.com with ESMTPSA id ok17sm29709043pdb.26.2015.07.21.18.10.55
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2015 18:10:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150722010938.GA30012@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems that we need helper functions for skb which is allocated
at netlink_alloc_skb() since it does not have skb_shared_info.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/linux/netlink.h  |   22 ++++---------
 net/netlink/af_netlink.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 16 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 6835c12..049962e 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -68,6 +68,12 @@ extern void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err);
 extern int netlink_has_listeners(struct sock *sk, unsigned int group);
 extern struct sk_buff *netlink_alloc_skb(struct sock *ssk, unsigned int size,
 					 u32 dst_portid, gfp_t gfp_mask);
+extern struct sk_buff *netlink_skb_copy(const struct sk_buff *skb, gfp_t gfp_mask);
+extern struct sk_buff *netlink_skb_clone(struct sk_buff *skb, gfp_t gfp_mask);
+extern int netlink_skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen);
+extern void netlink_free_skb(struct sk_buff *skb);
+void netlink_consume_skb(struct sk_buff *skb);
+
 extern int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 portid, int nonblock);
 extern int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 portid,
 			     __u32 group, gfp_t allocation);
@@ -86,22 +92,6 @@ int netlink_attachskb(struct sock *sk, struct sk_buff *skb,
 void netlink_detachskb(struct sock *sk, struct sk_buff *skb);
 int netlink_sendskb(struct sock *sk, struct sk_buff *skb);
 
-static inline struct sk_buff *
-netlink_skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
-{
-	struct sk_buff *nskb;
-
-	nskb = skb_clone(skb, gfp_mask);
-	if (!nskb)
-		return NULL;
-
-	/* This is a large skb, set destructor callback to release head */
-	if (is_vmalloc_addr(skb->head))
-		nskb->destructor = skb->destructor;
-
-	return nskb;
-}
-
 /*
  *	skb should fit one page. This choice is good for headerless malloc.
  *	But we should limit to 8K so that userspace does not have to
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index bf6e766..a0a32f4 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1872,6 +1872,87 @@ out:
 }
 EXPORT_SYMBOL_GPL(netlink_alloc_skb);
 
+struct sk_buff *netlink_skb_copy(const struct sk_buff *skb, gfp_t gfp_mask)
+{
+#ifdef CONFIG_NETLINK_MMAP
+	if (netlink_skb_is_mmaped(skb)) {
+		struct sk_buff *n = alloc_skb(skb->len, gfp_mask);
+		if (!n)
+			return NULL;
+
+		skb_put(n, skb->len);
+		memcpy(n->data, skb->data, skb->len);
+		return n;
+	} else
+#endif
+		return skb_copy(skb, gfp_mask);
+}
+EXPORT_SYMBOL_GPL(netlink_skb_copy);
+
+struct sk_buff *netlink_skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
+{
+	struct sk_buff *nskb;
+
+#ifdef CONFIG_NETLINK_MMAP
+	if (netlink_skb_is_mmaped(skb))
+		return netlink_skb_copy(skb, gfp_mask);
+#endif
+	nskb = skb_clone(skb, gfp_mask);
+	if (!nskb)
+		return NULL;
+
+	/* This is a large skb, set destructor callback to release head */
+	if (is_vmalloc_addr(skb->head))
+		nskb->destructor = skb->destructor;
+
+	return nskb;
+}
+EXPORT_SYMBOL_GPL(netlink_skb_clone);
+
+int
+netlink_skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
+{
+#ifdef CONFIG_NETLINK_MMAP
+	struct page *page;
+	unsigned int offset;
+
+	if (netlink_skb_is_mmaped(from)) {
+		if (!len)
+			return 0;
+
+		page = virt_to_head_page(from->head);
+		offset = from->data - (unsigned char *)page_address(page);
+		__skb_fill_page_desc(to, 0, page, offset, len);
+		get_page(page);
+		to->truesize += len;
+		to->len += len;
+		to->data_len += len;
+
+		return 0;
+	} else
+#endif
+
+	return skb_zerocopy(to, from, len, hlen);
+}
+EXPORT_SYMBOL_GPL(netlink_skb_zerocopy);
+
+void netlink_free_skb(struct sk_buff *skb)
+{
+	kfree_skb_partial(skb, netlink_skb_is_mmaped(skb));
+}
+EXPORT_SYMBOL_GPL(netlink_free_skb);
+
+void netlink_consume_skb(struct sk_buff *skb)
+{
+#ifdef CONFIG_NETLINK_MMAP
+	if (netlink_skb_is_mmaped(skb))
+		kfree_skb_partial(skb, true);
+	else
+#endif
+		consume_skb(skb);
+}
+EXPORT_SYMBOL_GPL(netlink_consume_skb);
+
 int netlink_has_listeners(struct sock *sk, unsigned int group)
 {
 	int res = 0;
-- 
1.7.10.4

