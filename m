Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B410AC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Oct 2021 08:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E5D161278
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Oct 2021 08:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbhJPIX3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Oct 2021 04:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbhJPIX2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Oct 2021 04:23:28 -0400
X-Greylist: delayed 446 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 16 Oct 2021 01:21:21 PDT
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ee9:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB1CC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Oct 2021 01:21:20 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id DC99C103C6A49;
        Sat, 16 Oct 2021 10:13:50 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id B1C6160CF58F;
        Sat, 16 Oct 2021 10:13:50 +0200 (CEST)
X-Mailbox-Line: From 7bc9f3ee15533d170bc412d6bcdd122632af169d Mon Sep 17 00:00:00 2001
Message-Id: <7bc9f3ee15533d170bc412d6bcdd122632af169d.1634370995.git.lukas@wunner.de>
In-Reply-To: <202110160632.WzahPgao-lkp@intel.com>
References: <202110160632.WzahPgao-lkp@intel.com>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sat, 16 Oct 2021 10:13:27 +0200
Subject: [PATCH nf-next] netfilter: core: Fix clang warnings about unused
 static inlines
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        llvm@lists.linux.dev, kbuild-all@lists.01.org, linux-mm@kvack.org,
        Nathan Chancellor <natechancellor@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unlike gcc, clang warns about unused static inlines that are not in an
include file:

  net/netfilter/core.c:344:20: error: unused function 'nf_ingress_hook' [-Werror,-Wunused-function]
  static inline bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
                     ^
  net/netfilter/core.c:353:20: error: unused function 'nf_egress_hook' [-Werror,-Wunused-function]
  static inline bool nf_egress_hook(const struct nf_hook_ops *reg, int pf)
                     ^

According to commit 6863f5643dd7 ("kbuild: allow Clang to find unused
static inline functions for W=1 build"), the proper resolution is to
mark the affected functions as __maybe_unused.  An alternative approach
would be to move them to include/linux/netfilter_netdev.h, but since
Pablo didn't do that in commit ddcfa710d40b ("netfilter: add
nf_ingress_hook() helper function"), I'm guessing __maybe_unused is
preferred.

This fixes both the warning introduced by Pablo in v5.10 as well as the
one recently introduced by myself with commit 42df6e1d221d ("netfilter:
Introduce egress hook").

Fixes: ddcfa710d40b ("netfilter: add nf_ingress_hook() helper function")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v5.10+
---
 net/netfilter/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3a32a813fcde..6dec9cd395f1 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -341,7 +341,8 @@ static int nf_ingress_check(struct net *net, const struct nf_hook_ops *reg,
 	return 0;
 }
 
-static inline bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
+static inline bool __maybe_unused nf_ingress_hook(const struct nf_hook_ops *reg,
+						  int pf)
 {
 	if ((pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS) ||
 	    (pf == NFPROTO_INET && reg->hooknum == NF_INET_INGRESS))
@@ -350,7 +351,8 @@ static inline bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
 	return false;
 }
 
-static inline bool nf_egress_hook(const struct nf_hook_ops *reg, int pf)
+static inline bool __maybe_unused nf_egress_hook(const struct nf_hook_ops *reg,
+						 int pf)
 {
 	return pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EGRESS;
 }
-- 
2.31.1

