Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E49DC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Mar 2022 13:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiCDNUf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 08:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiCDNUf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 08:20:35 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAE322BEE
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 05:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5Dp8Dv0823boUabYG/hfICMrOcytJwEDTINe0ZcdHys=; b=FIEk8x3KZNm70Gxc/LSNZafZp7
        SfccDRJprLQOyGsh2kdSqYpNO5M3kpgqYRWBS2c+WrM1wfOKDIRP3d9j4NjBCtgsrB4Paa32JuoX8
        4J+0sbJXE4AvlTi6ZAqeYR6xZfN3/m1Ils/H4CqRiJqz1b3US0SHnpvxgfCseUrO6RvTU9dZn7RMe
        GJDHFcWd4U9vKhii/Tf8vmP/UsIKi4xTuu4tEfZ6C+xADsQOIKFVPREpS3RGjcVrgX+lI5JSWBuLH
        mJgWx1fPa2XjEMFP7THxIY9dibLd7VyEGHYnYpk1iuj3hdp44MvqHf4KobeBnPNQuF7VUKn9gKV8A
        lr+5XLFg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nQ7qT-0004VN-Ht; Fri, 04 Mar 2022 14:19:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables RFC 2/2] libxtables: Boost rule target checks by announcing chain names
Date:   Fri,  4 Mar 2022 14:19:44 +0100
Message-Id: <20220304131944.30801-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220304131944.30801-1-phil@nwl.cc>
References: <20220304131944.30801-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When restoring a ruleset, feed libxtables with chain names from
respective lines to avoid extension searches for them when parsing rules
jumping to them later.

This is kind of a double-edged blade: the obvious downside is that
*tables-restore won't detect user-defined chain name and extension
clashes anymore. The upside is a tremendous performance improvement
restoring large rulesets. The same crooked ruleset as mentioned in
earlier patches (50k chains, 130k rules of which 90k jump to a chain)
yields these numbers:

variant	 unoptimized	non-targets cache	announced chains
----------------------------------------------------------------
legacy   1m12s		37s			2.5s
nft      1m35s		53s			8s

Note that iptables-legacy-restore allows the clashes already as long as
the name does not match a standard target, but with this patch it stops
warning about it. iptables-nft-restore does not care at all, even allows
adding a chain named 'ACCEPT' (and rules can't reach it because '-j
ACCEPT' translates to a native nftables verdict). The latter is a bug by
itself.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h           | 3 +++
 iptables/iptables-restore.c | 1 +
 iptables/xtables-restore.c  | 1 +
 libxtables/xtables.c        | 6 ++++++
 4 files changed, 11 insertions(+)

diff --git a/include/xtables.h b/include/xtables.h
index ca674c2663eb4..816a157d5577d 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -645,6 +645,9 @@ const char *xt_xlate_get(struct xt_xlate *xl);
 #define xt_xlate_rule_get xt_xlate_get
 const char *xt_xlate_set_get(struct xt_xlate *xl);
 
+/* informed target lookups */
+void xtables_announce_chain(const char *name);
+
 #ifdef XTABLES_INTERNAL
 
 /* Shipped modules rely on this... */
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 1917fb2315665..4cf0d3dadead9 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -308,6 +308,7 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 						cb->ops->strerror(errno));
 			}
 
+			xtables_announce_chain(chain);
 			ret = 1;
 
 		} else if (in_table) {
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 81b25a43c9a04..4f9ffefdfab22 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -201,6 +201,7 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 				      policy, chain, line,
 				      strerror(errno));
 		}
+		xtables_announce_chain(chain);
 		ret = 1;
 	} else if (state->in_table) {
 		char *pcnt = NULL;
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 3cb9a87c9406d..96ba16014af46 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -322,6 +322,12 @@ static void notargets_hlist_insert(const char *name)
 	hlist_add_head(&cur->node, &notargets[djb_hash(name) % NOTARGET_HSIZE]);
 }
 
+void xtables_announce_chain(const char *name)
+{
+	if (!notargets_hlist_lookup(name))
+		notargets_hlist_insert(name);
+}
+
 void xtables_init(void)
 {
 	/* xtables cannot be used with setuid in a safe way. */
-- 
2.34.1

