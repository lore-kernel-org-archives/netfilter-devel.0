Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182A4C49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 09:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA69420890
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 09:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfIPJxk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 05:53:40 -0400
Received: from 195-154-211-226.rev.poneytelecom.eu ([195.154.211.226]:52172
        "EHLO flash.glorub.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfIPJxk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 05:53:40 -0400
X-Greylist: delayed 1419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Sep 2019 05:53:39 EDT
Received: from eric by flash.glorub.net with local (Exim 4.89)
        (envelope-from <ejallot@gmail.com>)
        id 1i9nKX-0009GO-Hd; Mon, 16 Sep 2019 11:29:57 +0200
From:   Eric Jallot <ejallot@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Jallot <ejallot@gmail.com>
Subject: [PATCH nft] src: parser_json: fix crash while restoring secmark object
Date:   Mon, 16 Sep 2019 11:29:43 +0200
Message-Id: <20190916092943.35543-1-ejallot@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before patch:
 # nft -j list secmarks | tee rules.json | jq '.'
 {
   "nftables": [
     {
       "metainfo": {
         "version": "0.9.2",
         "release_name": "Scram",
         "json_schema_version": 1
       }
     },
     {
       "secmark": {
         "family": "inet",
         "name": "s",
         "table": "t",
         "handle": 1,
         "context": "system_u:object_r:ssh_server_packet_t:s0"
       }
     }
   ]
 }

 # nft flush ruleset
 # nft -j -f rules.json
 Segmentation fault

Use "&tmp" instead of "tmp" in json_unpack() while translating "context" keyword.

After patch:
 # nft -j -f rules.json
 # nft list secmarks
 table inet t {
         secmark s {
                 "system_u:object_r:ssh_server_packet_t:s0"
         }
 }

Fixes: 3bc84e5c1fdd1 ("src: add support for setting secmark")
Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 5dd410af4b07..bc29dedf5b4c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3093,7 +3093,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		break;
 	case CMD_OBJ_SECMARK:
 		obj->type = NFT_OBJECT_SECMARK;
-		if (!json_unpack(root, "{s:s}", "context", tmp)) {
+		if (!json_unpack(root, "{s:s}", "context", &tmp)) {
 			int ret;
 			ret = snprintf(obj->secmark.ctx, sizeof(obj->secmark.ctx), "%s", tmp);
 			if (ret < 0 || ret >= (int)sizeof(obj->secmark.ctx)) {
-- 
2.11.0

