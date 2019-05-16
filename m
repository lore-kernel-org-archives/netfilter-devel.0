Return-Path: <SRS0=IJRP=TQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A358C04AAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 May 2019 18:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 282232082E
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 May 2019 18:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfEPSya (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 May 2019 14:54:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbfEPSya (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 May 2019 14:54:30 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD6CC8F911;
        Thu, 16 May 2019 18:54:21 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-126-19.rdu2.redhat.com [10.10.126.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 404F65C70A;
        Thu, 16 May 2019 18:54:18 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] src: update cache if cmd is more specific
Date:   Thu, 16 May 2019 14:54:16 -0400
Message-Id: <20190516185416.19018-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 16 May 2019 18:54:28 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If we've done a partial fetch of the cache and the genid is the same the
cache update will be skipped without fetching the needed items. This
change flushes the cache if the new request is more specific than the
current cache - forcing a cache update which includes the needed items.

Fixes: 816d8c7659c1 ("Support 'add/insert rule index <IDX>'")
---
# NFT=/usr/sbin/nft ./run-tests.sh ./testcases/cache/0003_cache_update_0                                                                                                                                                                                      
I: using nft binary /usr/sbin/nft                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                
W: [FAILED]     ./testcases/cache/0003_cache_update_0: got 1
Error: Could not process rule: No such file or directory                                                                                                                                                                                                                        
add table ip t2; add chain ip t2 c
                              ^^
/dev/stdin:1:18-24: Error: Could not process rule: No such file or directory
add rule ip t4 c index 0 drop
                 ^^^^^^^

I: results: [OK] 0 [FAILED] 1 [TOTAL] 1

# ./run-tests.sh ./testcases/cache/0003_cache_update_0                                                                                                                                                                                                        
I: using nft binary ./../../src/nft                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                
I: [OK]         ./testcases/cache/0003_cache_update_0
Error: No such file or directory; did you mean table 't' in family ip?                                                                                                                                                                                                          
add table ip t2; add chain ip t2 c
                              ^^

I: results: [OK] 1 [FAILED] 0 [TOTAL] 1
---
 include/nftables.h                              |  1 +
 src/rule.c                                      | 12 ++++++++++++
 tests/shell/testcases/cache/0003_cache_update_0 | 14 ++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/include/nftables.h b/include/nftables.h
index b17a16a4adef..bb9bb2091716 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -81,6 +81,7 @@ struct nft_cache {
 	uint16_t		genid;
 	struct list_head	list;
 	uint32_t		seqnum;
+	uint32_t		cmd;
 };
 
 struct mnl_socket;
diff --git a/src/rule.c b/src/rule.c
index dc75c7cd5fb0..afe37cd90b1d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -220,6 +220,15 @@ static int cache_init(struct netlink_ctx *ctx, enum cmd_ops cmd)
 	return 0;
 }
 
+static int cache_needs_more(enum cmd_ops old_cmd, enum cmd_ops cmd)
+{
+	if (cmd == CMD_LIST && old_cmd != CMD_LIST)
+		return 1;
+	if (cmd == CMD_RESET && old_cmd != CMD_RESET)
+		return 1;
+	return 0;
+}
+
 int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 {
 	uint16_t genid;
@@ -235,6 +244,8 @@ int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 replay:
 	ctx.seqnum = cache->seqnum++;
 	genid = mnl_genid_get(&ctx);
+	if (cache->genid && cache_needs_more(cache->cmd, cmd))
+		cache_release(cache);
 	if (genid && genid == cache->genid)
 		return 0;
 	if (cache->genid)
@@ -250,6 +261,7 @@ replay:
 		return -1;
 	}
 	cache->genid = genid;
+	cache->cmd = cmd;
 	return 0;
 }
 
diff --git a/tests/shell/testcases/cache/0003_cache_update_0 b/tests/shell/testcases/cache/0003_cache_update_0
index deb45db2c43b..fa9b5df380a4 100755
--- a/tests/shell/testcases/cache/0003_cache_update_0
+++ b/tests/shell/testcases/cache/0003_cache_update_0
@@ -27,3 +27,17 @@ EOF
 $NFT -i >/dev/null <<EOF
 add table ip t3; add chain ip t c
 EOF
+
+# The following test exposes a problem with incremental cache update when
+# reading commands from a file that add a rule using the "index" keyword.
+#
+# add rule ip t4 c meta l4proto icmp accept -> rule to reference in next step
+# add rule ip t4 c index 0 drop -> index 0 is not found due to rule cache not
+#                                  being updated
+$NFT -i >/dev/null <<EOF
+add table ip t4; add chain ip t4 c
+add rule ip t4 c meta l4proto icmp accept
+EOF
+$NFT -f - >/dev/null <<EOF
+add rule ip t4 c index 0 drop
+EOF
-- 
2.20.1

