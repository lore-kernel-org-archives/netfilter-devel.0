Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB9CEE49AC
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 15:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbjHVPnz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbjHVPny (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 11:43:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E75CC1;
        Tue, 22 Aug 2023 08:43:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qYTXp-0003Ei-24; Tue, 22 Aug 2023 17:43:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        "GONG, Ruiqi" <gongruiqi1@huawei.com>, GONG@breakpoint.cc,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH net-next 02/10] netfilter: ebtables: replace zero-length array members
Date:   Tue, 22 Aug 2023 17:43:23 +0200
Message-ID: <20230822154336.12888-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230822154336.12888-1-fw@strlen.de>
References: <20230822154336.12888-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: "GONG, Ruiqi" <gongruiqi1@huawei.com>

As suggested by Kees[1], replace the old-style 0-element array members
of multiple structs in ebtables.h with modern C99 flexible array.

[1]: https://lore.kernel.org/all/5E8E0F9C-EE3F-4B0D-B827-DC47397E2A4A@kernel.org/

[ fw@strlen.de:
  keep struct ebt_entry_target as-is, causes compiler warning:
  "variable sized type 'struct ebt_entry_target' not at the end of a
  struct or class is a GNU extension" ]

Link: https://github.com/KSPP/linux/issues/21
Signed-off-by: GONG, Ruiqi <gongruiqi1@huawei.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter_bridge/ebtables.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/uapi/linux/netfilter_bridge/ebtables.h
index b0caad82b693..4ff328f3d339 100644
--- a/include/uapi/linux/netfilter_bridge/ebtables.h
+++ b/include/uapi/linux/netfilter_bridge/ebtables.h
@@ -87,7 +87,7 @@ struct ebt_entries {
 	/* nr. of entries */
 	unsigned int nentries;
 	/* entry list */
-	char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+	char data[] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
 };
 
 /* used for the bitmask of struct ebt_entry */
@@ -129,7 +129,7 @@ struct ebt_entry_match {
 	} u;
 	/* size of data */
 	unsigned int match_size;
-	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+	unsigned char data[] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
 };
 
 struct ebt_entry_watcher {
@@ -142,7 +142,7 @@ struct ebt_entry_watcher {
 	} u;
 	/* size of data */
 	unsigned int watcher_size;
-	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+	unsigned char data[] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
 };
 
 struct ebt_entry_target {
@@ -190,7 +190,7 @@ struct ebt_entry {
 		/* sizeof ebt_entry + matches + watchers + target */
 		unsigned int next_offset;
 	);
-	unsigned char elems[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+	unsigned char elems[] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
 };
 
 static __inline__ struct ebt_entry_target *
-- 
2.41.0

