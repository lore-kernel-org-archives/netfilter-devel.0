Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C226FCCA473
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jun 2022 10:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiFUKvb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jun 2022 06:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346961AbiFUKvO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jun 2022 06:51:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7235AE027
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 03:51:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o3bTU-0002bU-0W; Tue, 21 Jun 2022 12:51:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: nf_conntrack: add missing __rcu annotations
Date:   Tue, 21 Jun 2022 12:50:55 +0200
Message-Id: <20220621105057.24394-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621105057.24394-1-fw@strlen.de>
References: <20220621105057.24394-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Access to the hook pointers use correct helpers but the pointers lack
the needed __rcu annotation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_conntrack_sip.h   | 2 +-
 include/net/netfilter/nf_conntrack_timeout.h | 2 +-
 net/netfilter/nf_conntrack_pptp.c            | 2 +-
 net/netfilter/nf_conntrack_sip.c             | 2 +-
 net/netfilter/nf_conntrack_timeout.c         | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index c620521c42bc..dbc614dfe0d5 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -164,7 +164,7 @@ struct nf_nat_sip_hooks {
 				  unsigned int medialen,
 				  union nf_inet_addr *rtp_addr);
 };
-extern const struct nf_nat_sip_hooks *nf_nat_sip_hooks;
+extern const struct nf_nat_sip_hooks __rcu *nf_nat_sip_hooks;
 
 int ct_sip_parse_request(const struct nf_conn *ct, const char *dptr,
 			 unsigned int datalen, unsigned int *matchoff,
diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index fea258983d23..9fdaba911de6 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -105,7 +105,7 @@ struct nf_ct_timeout_hooks {
 	void (*timeout_put)(struct nf_ct_timeout *timeout);
 };
 
-extern const struct nf_ct_timeout_hooks *nf_ct_timeout_hook;
+extern const struct nf_ct_timeout_hooks __rcu *nf_ct_timeout_hook;
 #endif
 
 #endif /* _NF_CONNTRACK_TIMEOUT_H */
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index f3fa367b455f..4c679638df06 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -45,7 +45,7 @@ MODULE_ALIAS_NFCT_HELPER("pptp");
 
 static DEFINE_SPINLOCK(nf_pptp_lock);
 
-const struct nf_nat_pptp_hook *nf_nat_pptp_hook;
+const struct nf_nat_pptp_hook __rcu *nf_nat_pptp_hook;
 EXPORT_SYMBOL_GPL(nf_nat_pptp_hook);
 
 #if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index b83dc9bf0a5d..a88b43624b27 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -60,7 +60,7 @@ module_param(sip_external_media, int, 0600);
 MODULE_PARM_DESC(sip_external_media, "Expect Media streams between external "
 				     "endpoints (default 0)");
 
-const struct nf_nat_sip_hooks *nf_nat_sip_hooks;
+const struct nf_nat_sip_hooks __rcu *nf_nat_sip_hooks;
 EXPORT_SYMBOL_GPL(nf_nat_sip_hooks);
 
 static int string_len(const struct nf_conn *ct, const char *dptr,
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 0f828d05ea60..821365ed5b2c 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -22,7 +22,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 
-const struct nf_ct_timeout_hooks *nf_ct_timeout_hook __read_mostly;
+const struct nf_ct_timeout_hooks __rcu *nf_ct_timeout_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_timeout_hook);
 
 static int untimeout(struct nf_conn *ct, void *timeout)
-- 
2.35.1

