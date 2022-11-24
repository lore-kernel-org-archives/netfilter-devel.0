Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAB7C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 16:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiKXQ5T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 11:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiKXQ5I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 11:57:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73953D91D
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 08:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z8wY1ecKTwN5fsph1huuxEd96kC9jO/9FccbW1SBItk=; b=RgdtGz+hA90KVvZcQqSfv+dkau
        NCxb6DtIQ6mJKqZf9iDmicDAmv9V9ParQu6iiqk0nZYZJD1k5g/TgathkjHUCyURsfyGHJ6xiJ2B5
        JjKj86zhuh3lxyxSubtORUn3Pr0FyaAYCuh3xJq0CVeGmUZ4EL600VBJgHTT5vmWfkCHSO55tohHF
        z2iaOOFRt47y0WglFkvhzOwfCABrSdQHq7UUjc6609Uz4DsCPiecErRWUe8YOF8/2RRC+Q/fmMrV9
        vS2Vj5TXnMHVz7aTPAUwF9fDOKxdGYSU1uaCoQ+kasQ8o8kJ5+GaHdj5e7AFfFP9lBEHZNsREr2kC
        5PRtoiYA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oyFX8-0000r5-AC; Thu, 24 Nov 2022 17:57:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 2/4] xt: Purify enum nft_xt_type
Date:   Thu, 24 Nov 2022 17:56:39 +0100
Message-Id: <20221124165641.26921-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221124165641.26921-1-phil@nwl.cc>
References: <20221124165641.26921-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove NFT_XT_MAX from the enum, it is not a valid xt type.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/statement.h | 2 +-
 src/xt.c            | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 8651fc78892c9..e648fb137b740 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -255,8 +255,8 @@ enum nft_xt_type {
 	NFT_XT_MATCH = 0,
 	NFT_XT_TARGET,
 	NFT_XT_WATCHER,
-	NFT_XT_MAX
 };
+#define NFT_XT_MAX	(NFT_XT_WATCHER + 1)
 
 struct xtables_match;
 struct xtables_target;
diff --git a/src/xt.c b/src/xt.c
index 7880fa1bc6966..300416a1e8d92 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -110,8 +110,6 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 		}
 		xfree(t);
 		break;
-	default:
-		break;
 	}
 
 	xt_xlate_free(xl);
-- 
2.38.0

