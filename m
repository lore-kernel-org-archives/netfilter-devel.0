From: Miroslav Kratochvil <exa.exa@gmail.com>
Subject: [PATCH] nf_tables: silence needless warning on element delete
Date: Wed, 29 Apr 2015 11:49:32 +0200
Message-ID: <CAO0uZ+8rN_Wdi+O3U8Ux3MxPR_uS7QAcgXb=TmEYOxi-_4DsiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34696 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422731AbbD2Jtd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Apr 2015 05:49:33 -0400
Received: by lbcga7 with SMTP id ga7so15999510lbc.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2015 02:49:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When deleting nft set elements in certain situations, a warning was triggered
by wrong check for dtype value. This fixes the check accordingly to enum
definition in include/linux/netfilter/nf_tables.h

Signed-off-by: Mirek Kratochvil <exa.exa@gmail.com>

Ref.: https://bugzilla.netfilter.org/show_bug.cgi?id=1013
---
 net/netfilter/nf_tables_api.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index adce01e..f2653a5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3312,9 +3312,8 @@ EXPORT_SYMBOL_GPL(nft_data_init);
  */
 void nft_data_uninit(const struct nft_data *data, enum nft_data_types type)
 {
+    if (type < NFT_DATA_VERDICT) return;
     switch (type) {
-    case NFT_DATA_VALUE:
-        return;
     case NFT_DATA_VERDICT:
         return nft_verdict_uninit(data);
     default:
-- 
2.1.4
