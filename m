Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41953C433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 05:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D6A2217D7
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 05:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbfHHF2W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 01:28:22 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:46998 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726106AbfHHF2S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 01:28:18 -0400
Received: from mr2.cc.vt.edu (mr2.cc.ipv6.vt.edu [IPv6:2607:b400:92:8400:0:90:e077:bf22])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x785SGPH015515
        for <netfilter-devel@vger.kernel.org>; Thu, 8 Aug 2019 01:28:16 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        by mr2.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x785SBdY005547
        for <netfilter-devel@vger.kernel.org>; Thu, 8 Aug 2019 01:28:16 -0400
Received: by mail-qk1-f197.google.com with SMTP id m198so81259774qke.22
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Aug 2019 22:28:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=ONCnBgjUfpZrL3xEXxyitnhHR+HMMVGSrZxNYT/XzNs=;
        b=XDLFES+jphKN8u/koo2MXLELzIitJa37iULR3zlTuEvCKKrYFEfrnjGmU0N4Vdp7s6
         tunUxF7LO74JmP+cnbwMob73EkVNP/rfn9U7hxx9lfl/HSaGfGRJKPn+Qd4JEnPxIvOL
         myESGUTHCzPx69Tj4QH2X921KGs5rgtzt5nD8p/Tq9v85Z//fUOAkItvETtq2PyYhaYv
         +MsZNujyo9Q8VnHqSvguUiAlJZL4Gnh6hh/Bs2j9pjk44x3w2TYfodAmLns4j86bx/UF
         IUldbN/E2NMn89elSOqr5ypKUiO4yhszVtYLCLE6DnC/Oaj0zrymK4j71G5rR9gSRiuh
         75gg==
X-Gm-Message-State: APjAAAWdFpUE4kj6sSiWjkUFu0t3Pn18FtRDE86J8a6RE7f8GdvWABoe
        VRuveggG0uPMvmACDRQ7YRWV5FZV862rPeV/bpM8BcEbwSwZpElFc2qlcmyxUvSQ/csGQaFM9MR
        8vqFy90xozMWkhir1eH9LtyBa7TrDaUON5UuVh3E=
X-Received: by 2002:aed:27d5:: with SMTP id m21mr728405qtg.153.1565242091250;
        Wed, 07 Aug 2019 22:28:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwHFKYV/uvRzllEEMllEsc4oakfKGIB84d0faSTQi74ovMYBJ7npBJoOpxzusd6v4sS/gkelA==
X-Received: by 2002:aed:27d5:: with SMTP id m21mr728395qtg.153.1565242090938;
        Wed, 07 Aug 2019 22:28:10 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::359])
        by smtp.gmail.com with ESMTPSA id u16sm46835732qte.32.2019.08.07.22.28.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 22:28:09 -0700 (PDT)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/netfilter - add missing prototypes.
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Thu, 08 Aug 2019 01:28:08 -0400
Message-ID: <54079.1565242088@turing-police>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sparse rightly complains about undeclared symbols.

  CHECK   net/netfilter/nft_set_hash.c
net/netfilter/nft_set_hash.c:647:21: warning: symbol 'nft_set_rhash_type' was not declared. Should it be static?
net/netfilter/nft_set_hash.c:670:21: warning: symbol 'nft_set_hash_type' was not declared. Should it be static?
net/netfilter/nft_set_hash.c:690:21: warning: symbol 'nft_set_hash_fast_type' was not declared. Should it be static?
  CHECK   net/netfilter/nft_set_bitmap.c
net/netfilter/nft_set_bitmap.c:296:21: warning: symbol 'nft_set_bitmap_type' was not declared. Should it be static?
  CHECK   net/netfilter/nft_set_rbtree.c
net/netfilter/nft_set_rbtree.c:470:21: warning: symbol 'nft_set_rbtree_type' was not declared. Should it be static?

Include nf_tables_core.h rather than nf_tables.h to pick up the additional definitions.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index b5aeccdddb22..087a056e34d1 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -10,7 +10,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 
 struct nft_bitmap_elem {
 	struct list_head	head;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 6e8d20c03e3d..c490451fcebf 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -16,7 +16,7 @@
 #include <linux/rhashtable.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 
 /* We target a hash table size of 4, element hint is 75% of final size */
 #define NFT_RHASH_ELEMENT_HINT 3
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 419d58ef802b..57123259452f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -13,7 +13,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 
 struct nft_rbtree {
 	struct rb_root		root;

