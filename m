Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543CFC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Oct 2022 11:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJALv3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Oct 2022 07:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJALv2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Oct 2022 07:51:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DFB399C3
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Oct 2022 04:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CI2xTrH0B/FZO0y9QQE1xcgHnAsIxzZ15+V+puvP+us=; b=Q2KspCR+QWG4uOquYqXnF1mMh2
        2GppEUxjrY4vYE/LJU5ZloLb6GDEz2hWS2LsWbsjNKsnYV+s2vh95VeRX2SDUSyvkUmFfQMe8Dh1C
        Jb8vZJ7z8SaWdG8+e37+tRrHOisiZGgqEZId+g8+Hl5Mi4e9+b6jTyaN5zKrWQjvqusLGDGaCejJR
        6UdBjsp8NnwRbgPxirrLN5dr9ETw5o/ibsFc/H+FeLOAq927E7jX8FCKcwUhLJKz96VaZGTOtFtcv
        CfxFEdjDsKnqKLhbihDddTv/g7v1dXg0L7yeTY4NCTkmo+a5ZU6UXEqxOcs/D7f+wZRGl0cCAOvCc
        uZcEL2Xg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oeb1h-0007bK-Bq
        for netfilter-devel@vger.kernel.org; Sat, 01 Oct 2022 13:51:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] extensions: among: Fix for use with ebtables-restore
Date:   Sat,  1 Oct 2022 13:51:11 +0200
Message-Id: <20221001115111.23923-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221001115111.23923-1-phil@nwl.cc>
References: <20221001115111.23923-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When restoring multiple rules which use among match, new size may be
smaller than the old one which caused invalid writes by the memcpy()
call. Expect this and realloc the match only if it needs to grow. Also
use realloc instead of freeing and allocating from scratch.

Fixes: 26753888720d8 ("nft: bridge: Rudimental among extension support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_among.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/extensions/libebt_among.c b/extensions/libebt_among.c
index c607a775539d3..1eab201984408 100644
--- a/extensions/libebt_among.c
+++ b/extensions/libebt_among.c
@@ -119,7 +119,6 @@ static int bramong_parse(int c, char **argv, int invert,
 		 struct xt_entry_match **match)
 {
 	struct nft_among_data *data = (struct nft_among_data *)(*match)->data;
-	struct xt_entry_match *new_match;
 	bool have_ip, dst = false;
 	size_t new_size, cnt;
 	struct stat stats;
@@ -170,18 +169,17 @@ static int bramong_parse(int c, char **argv, int invert,
 	new_size *= sizeof(struct nft_among_pair);
 	new_size += XT_ALIGN(sizeof(struct xt_entry_match)) +
 			sizeof(struct nft_among_data);
-	new_match = xtables_calloc(1, new_size);
-	memcpy(new_match, *match, (*match)->u.match_size);
-	new_match->u.match_size = new_size;
 
-	data = (struct nft_among_data *)new_match->data;
+	if (new_size > (*match)->u.match_size) {
+		*match = xtables_realloc(*match, new_size);
+		(*match)->u.match_size = new_size;
+		data = (struct nft_among_data *)(*match)->data;
+	}
+
 	have_ip = nft_among_pairs_have_ip(optarg);
 	poff = nft_among_prepare_data(data, dst, cnt, invert, have_ip);
 	parse_nft_among_pairs(data->pairs + poff, optarg, cnt, have_ip);
 
-	free(*match);
-	*match = new_match;
-
 	if (c == AMONG_DST_F || c == AMONG_SRC_F) {
 		munmap(argv, flen);
 		close(fd);
-- 
2.34.1

