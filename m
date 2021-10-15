Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3860C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6BCD60E05
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbhJOMaG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Oct 2021 08:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238937AbhJOM3Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Oct 2021 08:29:25 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6882EC061762
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Oct 2021 05:27:19 -0700 (PDT)
Received: from localhost ([::1]:33890 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mbMIv-0002Ve-Rg; Fri, 15 Oct 2021 14:27:17 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 04/13] xtables: Simplify addr_mask freeing
Date:   Fri, 15 Oct 2021 14:25:59 +0200
Message-Id: <20211015122608.12474-5-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211015122608.12474-1-phil@nwl.cc>
References: <20211015122608.12474-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce a generic 'ptr' union field to pass to free().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h |  2 ++
 iptables/xtables.c    | 15 ++++-----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 71094a28e73de..44ad0811f4081 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -177,6 +177,7 @@ struct addr_mask {
 	union {
 		struct in_addr	*v4;
 		struct in6_addr *v6;
+		void *ptr;
 	} addr;
 
 	unsigned int naddrs;
@@ -184,6 +185,7 @@ struct addr_mask {
 	union {
 		struct in_addr	*v4;
 		struct in6_addr *v6;
+		void *ptr;
 	} mask;
 };
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 092edaaf89224..f45e36086dcb8 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1021,17 +1021,10 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 
 	nft_clear_iptables_command_state(&cs);
 
-	if (h->family == AF_INET) {
-		free(args.s.addr.v4);
-		free(args.s.mask.v4);
-		free(args.d.addr.v4);
-		free(args.d.mask.v4);
-	} else if (h->family == AF_INET6) {
-		free(args.s.addr.v6);
-		free(args.s.mask.v6);
-		free(args.d.addr.v6);
-		free(args.d.mask.v6);
-	}
+	free(args.s.addr.ptr);
+	free(args.s.mask.ptr);
+	free(args.d.addr.ptr);
+	free(args.d.mask.ptr);
 	xtables_free_opts(1);
 
 	return ret;
-- 
2.33.0

