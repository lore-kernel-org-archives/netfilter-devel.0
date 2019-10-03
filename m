Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584AEECE58B
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F0292133F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="m4Smd7/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387907AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
Received: from kadath.azazel.net ([81.187.231.250]:51192 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732669AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mH4+kKkEN8FpOwhGtHEjCHyOb2jftV1FkP4UDzVEocc=; b=m4Smd7/g/ixQz4ofwblYYZWJho
        iDyh47jLroap9codVfiCLM4iV5bU9lTF0bgwUfoo9k/+aXaAxpHEiflARXQ8KOmDSJRkGxXhkbym+
        m3+WbVVk4Dm1iD2jmYDfKs8qChhbOU+Wq4ZgKz6Mf8MdFMvecRCvfaMaSEv/biSe9/RFYrEba28Fu
        j5/F9Z3ikI3NUJWvZXgsWkpOBLoMXeE9iUjZ1qYJb7XGHVsq+nzXbS7NemlXvYPHjdIEJydb6/Vjh
        G6y6j/Pwajz1xXEC5+wD6W443TCe+QFzSsf2w/uZfkqOmyn0NzKmpf4ZHMLNlYBeKadlIbbvArIiA
        /mU1s5OQ==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iG7Cq-0004KM-Dk; Thu, 03 Oct 2019 20:56:08 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 4/7] netfilter: ipset: move functions to ip_set_core.c.
Date:   Thu,  3 Oct 2019 20:56:04 +0100
Message-Id: <20191003195607.13180-5-jeremy@azazel.net>
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

Several inline functions in ip_set.h are only called in ip_set_core.c:
move them and remove inline function specifier.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/ipset/ip_set.h | 102 -------------------------
 net/netfilter/ipset/ip_set_core.c      | 102 +++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 985c9bb1ab65..44f6de8a1733 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -508,86 +508,9 @@ ip_set_timeout_set(unsigned long *timeout, u32 value)
 	*timeout = t;
 }
 
-static inline u32
-ip_set_timeout_get(const unsigned long *timeout)
-{
-	u32 t;
-
-	if (*timeout == IPSET_ELEM_PERMANENT)
-		return 0;
-
-	t = jiffies_to_msecs(*timeout - jiffies)/MSEC_PER_SEC;
-	/* Zero value in userspace means no timeout */
-	return t == 0 ? 1 : t;
-}
-
 void ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 			 const struct ip_set_ext *ext);
 
-static inline void
-ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
-{
-	atomic64_add((long long)bytes, &(counter)->bytes);
-}
-
-static inline void
-ip_set_add_packets(u64 packets, struct ip_set_counter *counter)
-{
-	atomic64_add((long long)packets, &(counter)->packets);
-}
-
-static inline u64
-ip_set_get_bytes(const struct ip_set_counter *counter)
-{
-	return (u64)atomic64_read(&(counter)->bytes);
-}
-
-static inline u64
-ip_set_get_packets(const struct ip_set_counter *counter)
-{
-	return (u64)atomic64_read(&(counter)->packets);
-}
-
-static inline bool
-ip_set_match_counter(u64 counter, u64 match, u8 op)
-{
-	switch (op) {
-	case IPSET_COUNTER_NONE:
-		return true;
-	case IPSET_COUNTER_EQ:
-		return counter == match;
-	case IPSET_COUNTER_NE:
-		return counter != match;
-	case IPSET_COUNTER_LT:
-		return counter < match;
-	case IPSET_COUNTER_GT:
-		return counter > match;
-	}
-	return false;
-}
-
-static inline void
-ip_set_update_counter(struct ip_set_counter *counter,
-		      const struct ip_set_ext *ext, u32 flags)
-{
-	if (ext->packets != ULLONG_MAX &&
-	    !(flags & IPSET_FLAG_SKIP_COUNTER_UPDATE)) {
-		ip_set_add_bytes(ext->bytes, counter);
-		ip_set_add_packets(ext->packets, counter);
-	}
-}
-
-static inline bool
-ip_set_put_counter(struct sk_buff *skb, const struct ip_set_counter *counter)
-{
-	return nla_put_net64(skb, IPSET_ATTR_BYTES,
-			     cpu_to_be64(ip_set_get_bytes(counter)),
-			     IPSET_ATTR_PAD) ||
-	       nla_put_net64(skb, IPSET_ATTR_PACKETS,
-			     cpu_to_be64(ip_set_get_packets(counter)),
-			     IPSET_ATTR_PAD);
-}
-
 static inline void
 ip_set_init_counter(struct ip_set_counter *counter,
 		    const struct ip_set_ext *ext)
@@ -598,31 +521,6 @@ ip_set_init_counter(struct ip_set_counter *counter,
 		atomic64_set(&(counter)->packets, (long long)(ext->packets));
 }
 
-static inline void
-ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
-		   const struct ip_set_ext *ext,
-		   struct ip_set_ext *mext, u32 flags)
-{
-	mext->skbinfo = *skbinfo;
-}
-
-static inline bool
-ip_set_put_skbinfo(struct sk_buff *skb, const struct ip_set_skbinfo *skbinfo)
-{
-	/* Send nonzero parameters only */
-	return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
-		nla_put_net64(skb, IPSET_ATTR_SKBMARK,
-			      cpu_to_be64((u64)skbinfo->skbmark << 32 |
-					  skbinfo->skbmarkmask),
-			      IPSET_ATTR_PAD)) ||
-	       (skbinfo->skbprio &&
-		nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
-			      cpu_to_be32(skbinfo->skbprio))) ||
-	       (skbinfo->skbqueue &&
-		nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
-			      cpu_to_be16(skbinfo->skbqueue)));
-}
-
 static inline void
 ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
 		    const struct ip_set_ext *ext)
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 73daea6d4bd5..30bc7df2f4cf 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -325,6 +325,19 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ipaddr6);
 
+static u32
+ip_set_timeout_get(const unsigned long *timeout)
+{
+	u32 t;
+
+	if (*timeout == IPSET_ELEM_PERMANENT)
+		return 0;
+
+	t = jiffies_to_msecs(*timeout - jiffies) / MSEC_PER_SEC;
+	/* Zero value in userspace means no timeout */
+	return t == 0 ? 1 : t;
+}
+
 static char *
 ip_set_comment_uget(struct nlattr *tb)
 {
@@ -510,6 +523,46 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 }
 EXPORT_SYMBOL_GPL(ip_set_get_extensions);
 
+static u64
+ip_set_get_bytes(const struct ip_set_counter *counter)
+{
+	return (u64)atomic64_read(&(counter)->bytes);
+}
+
+static u64
+ip_set_get_packets(const struct ip_set_counter *counter)
+{
+	return (u64)atomic64_read(&(counter)->packets);
+}
+
+static bool
+ip_set_put_counter(struct sk_buff *skb, const struct ip_set_counter *counter)
+{
+	return nla_put_net64(skb, IPSET_ATTR_BYTES,
+			     cpu_to_be64(ip_set_get_bytes(counter)),
+			     IPSET_ATTR_PAD) ||
+	       nla_put_net64(skb, IPSET_ATTR_PACKETS,
+			     cpu_to_be64(ip_set_get_packets(counter)),
+			     IPSET_ATTR_PAD);
+}
+
+static bool
+ip_set_put_skbinfo(struct sk_buff *skb, const struct ip_set_skbinfo *skbinfo)
+{
+	/* Send nonzero parameters only */
+	return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
+		nla_put_net64(skb, IPSET_ATTR_SKBMARK,
+			      cpu_to_be64((u64)skbinfo->skbmark << 32 |
+					  skbinfo->skbmarkmask),
+			      IPSET_ATTR_PAD)) ||
+	       (skbinfo->skbprio &&
+		nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
+			      cpu_to_be32(skbinfo->skbprio))) ||
+	       (skbinfo->skbqueue &&
+		nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
+			      cpu_to_be16(skbinfo->skbqueue)));
+}
+
 int
 ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 		      const void *e, bool active)
@@ -535,6 +588,55 @@ ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 }
 EXPORT_SYMBOL_GPL(ip_set_put_extensions);
 
+static bool
+ip_set_match_counter(u64 counter, u64 match, u8 op)
+{
+	switch (op) {
+	case IPSET_COUNTER_NONE:
+		return true;
+	case IPSET_COUNTER_EQ:
+		return counter == match;
+	case IPSET_COUNTER_NE:
+		return counter != match;
+	case IPSET_COUNTER_LT:
+		return counter < match;
+	case IPSET_COUNTER_GT:
+		return counter > match;
+	}
+	return false;
+}
+
+static void
+ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
+{
+	atomic64_add((long long)bytes, &(counter)->bytes);
+}
+
+static void
+ip_set_add_packets(u64 packets, struct ip_set_counter *counter)
+{
+	atomic64_add((long long)packets, &(counter)->packets);
+}
+
+static void
+ip_set_update_counter(struct ip_set_counter *counter,
+		      const struct ip_set_ext *ext, u32 flags)
+{
+	if (ext->packets != ULLONG_MAX &&
+	    !(flags & IPSET_FLAG_SKIP_COUNTER_UPDATE)) {
+		ip_set_add_bytes(ext->bytes, counter);
+		ip_set_add_packets(ext->packets, counter);
+	}
+}
+
+static void
+ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
+		   const struct ip_set_ext *ext,
+		   struct ip_set_ext *mext, u32 flags)
+{
+	mext->skbinfo = *skbinfo;
+}
+
 bool
 ip_set_match_extensions(struct ip_set *set, const struct ip_set_ext *ext,
 			struct ip_set_ext *mext, u32 flags, void *data)
-- 
2.23.0

