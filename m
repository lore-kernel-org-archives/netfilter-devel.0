Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822C6C4CED1
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5941A207FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="rqy0vDMO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387908AbfJCT4M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 15:56:12 -0400
Received: from kadath.azazel.net ([81.187.231.250]:51188 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732704AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OC2eiirRNQT7H8KxK85DpUYnSIwQ0f8986zSGrlebtQ=; b=rqy0vDMOi3apudinDN982hM42/
        Y9jGb/dECz6UlESOVt/LQ2TkgjMt+qCWfFDvYb+QmmglA+GCUz9oUSq7ZQQxq00KmNWT/l0f5VeLt
        SRwa5jCsI1e5hTiYrhP/uuF+sYhFoKfLj7rrUxk/fbXAs7IcTEBWsASyonWPhvHFsGcvGJf2GpCQ/
        6VtTS3syZ5Q9k6Vg3ob4an5LLUI/QWa5hmzOC3IK3bGywzzbxQskiQSY0rJ0NySet8A69qdhvZmCf
        6CulQyEVAen81BKCTP8rjqCvhGHfYOCrvbE8JZ1k8MnlZtQfvBbM/qNS6fIHyO7LWWj8gEo7Pb30M
        JRpfwVGw==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iG7Cq-0004KM-8I; Thu, 03 Oct 2019 20:56:08 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 3/7] netfilter: ipset: move ip_set_comment functions from ip_set.h to ip_set_core.c.
Date:   Thu,  3 Oct 2019 20:56:03 +0100
Message-Id: <20191003195607.13180-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003195607.13180-1-jeremy@azazel.net>
References: <20191003195607.13180-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Most of the functions are only called from within ip_set_core.c.

The exception is ip_set_init_comment.  However, this is too complex to
be a good candidate for a static inline function.  Move it to
ip_set_core.c, change its linkage to extern and export it, leaving a
declaration in ip_set.h.

ip_set_comment_free is only used as an extension destructor, so change
its prototype to match and drop cast.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/ipset/ip_set.h | 63 +-----------------------
 net/netfilter/ipset/ip_set_core.c      | 66 +++++++++++++++++++++++++-
 2 files changed, 67 insertions(+), 62 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 9fee4837d02c..985c9bb1ab65 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -521,67 +521,8 @@ ip_set_timeout_get(const unsigned long *timeout)
 	return t == 0 ? 1 : t;
 }
 
-static inline char*
-ip_set_comment_uget(struct nlattr *tb)
-{
-	return nla_data(tb);
-}
-
-/* Called from uadd only, protected by the set spinlock.
- * The kadt functions don't use the comment extensions in any way.
- */
-static inline void
-ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
-		    const struct ip_set_ext *ext)
-{
-	struct ip_set_comment_rcu *c = rcu_dereference_protected(comment->c, 1);
-	size_t len = ext->comment ? strlen(ext->comment) : 0;
-
-	if (unlikely(c)) {
-		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-		kfree_rcu(c, rcu);
-		rcu_assign_pointer(comment->c, NULL);
-	}
-	if (!len)
-		return;
-	if (unlikely(len > IPSET_MAX_COMMENT_SIZE))
-		len = IPSET_MAX_COMMENT_SIZE;
-	c = kmalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
-	if (unlikely(!c))
-		return;
-	strlcpy(c->str, ext->comment, len + 1);
-	set->ext_size += sizeof(*c) + strlen(c->str) + 1;
-	rcu_assign_pointer(comment->c, c);
-}
-
-/* Used only when dumping a set, protected by rcu_read_lock() */
-static inline int
-ip_set_put_comment(struct sk_buff *skb, const struct ip_set_comment *comment)
-{
-	struct ip_set_comment_rcu *c = rcu_dereference(comment->c);
-
-	if (!c)
-		return 0;
-	return nla_put_string(skb, IPSET_ATTR_COMMENT, c->str);
-}
-
-/* Called from uadd/udel, flush or the garbage collectors protected
- * by the set spinlock.
- * Called when the set is destroyed and when there can't be any user
- * of the set data anymore.
- */
-static inline void
-ip_set_comment_free(struct ip_set *set, struct ip_set_comment *comment)
-{
-	struct ip_set_comment_rcu *c;
-
-	c = rcu_dereference_protected(comment->c, 1);
-	if (unlikely(!c))
-		return;
-	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-	kfree_rcu(c, rcu);
-	rcu_assign_pointer(comment->c, NULL);
-}
+void ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
+			 const struct ip_set_ext *ext);
 
 static inline void
 ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 04266295a750..73daea6d4bd5 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -325,6 +325,70 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ipaddr6);
 
+static char *
+ip_set_comment_uget(struct nlattr *tb)
+{
+	return nla_data(tb);
+}
+
+/* Called from uadd only, protected by the set spinlock.
+ * The kadt functions don't use the comment extensions in any way.
+ */
+void
+ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
+		    const struct ip_set_ext *ext)
+{
+	struct ip_set_comment_rcu *c = rcu_dereference_protected(comment->c, 1);
+	size_t len = ext->comment ? strlen(ext->comment) : 0;
+
+	if (unlikely(c)) {
+		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
+		kfree_rcu(c, rcu);
+		rcu_assign_pointer(comment->c, NULL);
+	}
+	if (!len)
+		return;
+	if (unlikely(len > IPSET_MAX_COMMENT_SIZE))
+		len = IPSET_MAX_COMMENT_SIZE;
+	c = kmalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
+	if (unlikely(!c))
+		return;
+	strlcpy(c->str, ext->comment, len + 1);
+	set->ext_size += sizeof(*c) + strlen(c->str) + 1;
+	rcu_assign_pointer(comment->c, c);
+}
+EXPORT_SYMBOL_GPL(ip_set_init_comment);
+
+/* Used only when dumping a set, protected by rcu_read_lock() */
+static int
+ip_set_put_comment(struct sk_buff *skb, const struct ip_set_comment *comment)
+{
+	struct ip_set_comment_rcu *c = rcu_dereference(comment->c);
+
+	if (!c)
+		return 0;
+	return nla_put_string(skb, IPSET_ATTR_COMMENT, c->str);
+}
+
+/* Called from uadd/udel, flush or the garbage collectors protected
+ * by the set spinlock.
+ * Called when the set is destroyed and when there can't be any user
+ * of the set data anymore.
+ */
+static void
+ip_set_comment_free(struct ip_set *set, void *ptr)
+{
+	struct ip_set_comment *comment = ptr;
+	struct ip_set_comment_rcu *c;
+
+	c = rcu_dereference_protected(comment->c, 1);
+	if (unlikely(!c))
+		return;
+	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
+	kfree_rcu(c, rcu);
+	rcu_assign_pointer(comment->c, NULL);
+}
+
 typedef void (*destroyer)(struct ip_set *, void *);
 /* ipset data extension types, in size order */
 
@@ -351,7 +415,7 @@ const struct ip_set_ext_type ip_set_extensions[] = {
 		.flag	 = IPSET_FLAG_WITH_COMMENT,
 		.len	 = sizeof(struct ip_set_comment),
 		.align	 = __alignof__(struct ip_set_comment),
-		.destroy = (destroyer) ip_set_comment_free,
+		.destroy = ip_set_comment_free,
 	},
 };
 EXPORT_SYMBOL_GPL(ip_set_extensions);
-- 
2.23.0

