Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8FBCDB465
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 13:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjJPNwh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbjJPNwg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 09:52:36 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A51CEB
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:52:34 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ca816f868fso5125325ad.1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697464354; x=1698069154; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z5bN1RVl3L3Y9SS94wUksTLR9qUkNBGy2gI/wizsvHY=;
        b=FS6sKOb6qv4DKfx/GeKbRyQP+rh/uX8L9d+yAxWyXkshwlKcd1K+d2Dva5S6MF/a4V
         y6yPzys2lZiAMWJ9k+Pss9grTg8wnws2LoR4tKelS599i7gW+z7d7JFHwqUz+d/zA3eV
         teNce3d4M49H2zHUhgBx3Ytx2o2ephsVQZjBZ0H7jnLBjqRxqenZ4gm+hYBMLWMbZ92K
         YJY3/7tNi0hMn+FmMH7qcUuw4p4GRIFMvUbnV1hLCUSY+Ze6yM/OXmNcjr1EgaE4dBg+
         5prfAcfE+fvGIfHe1jnXzbyDm8Oc7KG5Ao0F693v2ar495tWs5LYMvjBQ2bvD7osQbjq
         VkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464354; x=1698069154;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z5bN1RVl3L3Y9SS94wUksTLR9qUkNBGy2gI/wizsvHY=;
        b=SdhW0cxqWo+4x6sUm7/q2CQg51O6PTlJXtF8dGDYJnkvdig84Eo/Y1BCUgto59ic98
         xOldun+DhGCn6LW6KOlSEpYECRcAP6IS2BlSCPCQqdphS+JAYIWO+Fb6hCznsE/iJaUh
         qyA/XpV+VXWsQMinIfMf9naqMeKnZU1xxAfVnr4fQXWa0Rm86sGlPERw7qqvKzL1dGL2
         oUC2vW5+vfPJ3Eh6zFtfZTncdE711WnmIw3MlI0sJl+5z6lcFX0TZyZb7fX8Z0Q0FBZC
         TskQgAW0jsCVjZRfSvvcuic+mfLuQvUBSdXo7M7hMWlmYtdxTsN1lE+ziAPqppMylQEO
         b5QA==
X-Gm-Message-State: AOJu0YwyV2w+Y205nubBiY1UWGwj0bX/ED65M4SSZGuAQM1uUb0R8Vlq
        DWsGDiDHjUyyxrZTLuiaXVE=
X-Google-Smtp-Source: AGHT+IGfGLzkr0fp82oyyEKxhDDk4mSVNPveydBqTmMDL62teIP9z8Rrzwoe0n1BzCTNRLyLYzaRHA==
X-Received: by 2002:a17:903:84b:b0:1ca:28f3:568e with SMTP id ks11-20020a170903084b00b001ca28f3568emr4206216plb.51.1697464353925;
        Mon, 16 Oct 2023 06:52:33 -0700 (PDT)
Received: from localhost.localdomain ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id h24-20020a170902ac9800b001c3be750900sm8533377plr.163.2023.10.16.06.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 06:52:33 -0700 (PDT)
From:   xiaolinkui <xiaolinkui@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, justinstitt@google.com, kuniyu@amazon.com
Cc:     netfilter-devel@vger.kernel.org,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH 1/2] netfilter: ipset: rename ref_netlink to ref_swapping
Date:   Mon, 16 Oct 2023 21:52:03 +0800
Message-Id: <20231016135204.27443-1-xiaolinkui@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Linkui Xiao <xiaolinkui@kylinos.cn>

The ref_netlink appears to solve the swap race problem. In addition to the
netlink events, there are other factors that trigger this race condition.
The race condition in the ip_set_test will be fixed in the next patch.

Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
---
 include/linux/netfilter/ipset/ip_set.h |  4 +--
 net/netfilter/ipset/ip_set_core.c      | 34 +++++++++++++-------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index e8c350a3ade1..32c56f1a43f2 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -248,10 +248,10 @@ struct ip_set {
 	spinlock_t lock;
 	/* References to the set */
 	u32 ref;
-	/* References to the set for netlink events like dump,
+	/* References to the set for netlink/test events,
 	 * ref can be swapped out by ip_set_swap
 	 */
-	u32 ref_netlink;
+	u32 ref_swapping;
 	/* The core set type */
 	struct ip_set_type *type;
 	/* The type variant doing the real job */
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 35d2f9c9ada0..e5d25df5c64c 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -59,7 +59,7 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
 		lockdep_is_held(&ip_set_ref_lock))
 #define ip_set(inst, id)		\
 	ip_set_dereference((inst)->ip_set_list)[id]
-#define ip_set_ref_netlink(inst,id)	\
+#define ip_set_ref_swapping(inst, id)	\
 	rcu_dereference_raw((inst)->ip_set_list)[id]
 
 /* The set types are implemented in modules and registered set types
@@ -683,19 +683,19 @@ __ip_set_put(struct ip_set *set)
  * a separate reference counter
  */
 static void
-__ip_set_get_netlink(struct ip_set *set)
+__ip_set_get_swapping(struct ip_set *set)
 {
 	write_lock_bh(&ip_set_ref_lock);
-	set->ref_netlink++;
+	set->ref_swapping++;
 	write_unlock_bh(&ip_set_ref_lock);
 }
 
 static void
-__ip_set_put_netlink(struct ip_set *set)
+__ip_set_put_swapping(struct ip_set *set)
 {
 	write_lock_bh(&ip_set_ref_lock);
-	BUG_ON(set->ref_netlink == 0);
-	set->ref_netlink--;
+	BUG_ON(set->ref_swapping == 0);
+	set->ref_swapping--;
 	write_unlock_bh(&ip_set_ref_lock);
 }
 
@@ -1213,7 +1213,7 @@ static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!attr[IPSET_ATTR_SETNAME]) {
 		for (i = 0; i < inst->ip_set_max; i++) {
 			s = ip_set(inst, i);
-			if (s && (s->ref || s->ref_netlink)) {
+			if (s && (s->ref || s->ref_swapping)) {
 				ret = -IPSET_ERR_BUSY;
 				goto out;
 			}
@@ -1237,7 +1237,7 @@ static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
 			if (!(flags & IPSET_FLAG_EXIST))
 				ret = -ENOENT;
 			goto out;
-		} else if (s->ref || s->ref_netlink) {
+		} else if (s->ref || s->ref_swapping) {
 			ret = -IPSET_ERR_BUSY;
 			goto out;
 		}
@@ -1321,7 +1321,7 @@ static int ip_set_rename(struct sk_buff *skb, const struct nfnl_info *info,
 		return -ENOENT;
 
 	write_lock_bh(&ip_set_ref_lock);
-	if (set->ref != 0 || set->ref_netlink != 0) {
+	if (set->ref != 0 || set->ref_swapping != 0) {
 		ret = -IPSET_ERR_REFERENCED;
 		goto out;
 	}
@@ -1383,7 +1383,7 @@ static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
 
 	write_lock_bh(&ip_set_ref_lock);
 
-	if (from->ref_netlink || to->ref_netlink) {
+	if (from->ref_swapping || to->ref_swapping) {
 		write_unlock_bh(&ip_set_ref_lock);
 		return -EBUSY;
 	}
@@ -1441,12 +1441,12 @@ ip_set_dump_done(struct netlink_callback *cb)
 		struct ip_set_net *inst =
 			(struct ip_set_net *)cb->args[IPSET_CB_NET];
 		ip_set_id_t index = (ip_set_id_t)cb->args[IPSET_CB_INDEX];
-		struct ip_set *set = ip_set_ref_netlink(inst, index);
+		struct ip_set *set = ip_set_ref_swapping(inst, index);
 
 		if (set->variant->uref)
 			set->variant->uref(set, cb, false);
 		pr_debug("release set %s\n", set->name);
-		__ip_set_put_netlink(set);
+		__ip_set_put_swapping(set);
 	}
 	return 0;
 }
@@ -1580,7 +1580,7 @@ ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
 		if (!cb->args[IPSET_CB_ARG0]) {
 			/* Start listing: make sure set won't be destroyed */
 			pr_debug("reference set\n");
-			set->ref_netlink++;
+			set->ref_swapping++;
 		}
 		write_unlock_bh(&ip_set_ref_lock);
 		nlh = start_msg(skb, NETLINK_CB(cb->skb).portid,
@@ -1646,11 +1646,11 @@ ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
 release_refcount:
 	/* If there was an error or set is done, release set */
 	if (ret || !cb->args[IPSET_CB_ARG0]) {
-		set = ip_set_ref_netlink(inst, index);
+		set = ip_set_ref_swapping(inst, index);
 		if (set->variant->uref)
 			set->variant->uref(set, cb, false);
 		pr_debug("release set %s\n", set->name);
-		__ip_set_put_netlink(set);
+		__ip_set_put_swapping(set);
 		cb->args[IPSET_CB_ARG0] = 0;
 	}
 out:
@@ -1701,11 +1701,11 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 
 	do {
 		if (retried) {
-			__ip_set_get_netlink(set);
+			__ip_set_get_swapping(set);
 			nfnl_unlock(NFNL_SUBSYS_IPSET);
 			cond_resched();
 			nfnl_lock(NFNL_SUBSYS_IPSET);
-			__ip_set_put_netlink(set);
+			__ip_set_put_swapping(set);
 		}
 
 		ip_set_lock(set);
-- 
2.17.1

