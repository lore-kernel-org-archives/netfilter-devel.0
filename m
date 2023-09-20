Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E3EC27C7B
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjITU5m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjITU5k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:57:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637E0CE
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ElU7Pr63tVEOxBtHuAk/cugvBWTjZ+s4vvKG9FGbfvU=; b=RDei1YpveXs/ZG8Iowtalu/LOc
        9K03Qafc4VLaq+sOB17Ej8B6GQHWOXm6WdSQhTs9HKl9c+c7/lOLNo0FH9b8co7LsS3KHMr3HFRYv
        5Z3kvh2DmCL9llot2r6dk9oZrCYogmPqWRitD/Qwq+aHN+f7Wg3D/IK4a+md9X+98q2wANTqHH/v5
        gKy08R3qArXX1V1yLFKdb/Nx2/K/Q7DE45B7AUkGKMKbv3GhDuQDJwML5/+QjiKeaDRPzAOyBIzQ6
        UOsiuLje0Y0WIlKMqlvx/hLKNOBddEkBy4cSkPHyAYLbwbAARIHWD5hUFXKEmYBehAmyUPLfaujgi
        YEFckG4A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qj4GK-0007qK-Lq; Wed, 20 Sep 2023 22:57:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 6/9] parser_json: Fix synproxy object mss/wscale parsing
Date:   Wed, 20 Sep 2023 22:57:24 +0200
Message-ID: <20230920205727.22103-7-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920205727.22103-1-phil@nwl.cc>
References: <20230920205727.22103-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The fields are 16 and 8 bits in size, introduce temporary variables to
parse into.

Fixes: f44ab88b1088e ("src: add synproxy stateful object support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 2b244783c442d..8ec11083f463c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3447,7 +3447,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 {
 	const char *family, *tmp, *rate_unit = "packets", *burst_unit = "bytes";
 	uint32_t l3proto = NFPROTO_UNSPEC;
-	int inv = 0, flags = 0, i;
+	int inv = 0, flags = 0, i, j;
 	struct handle h = { 0 };
 	struct obj *obj;
 	json_t *jflags;
@@ -3634,11 +3634,12 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	case CMD_OBJ_SYNPROXY:
 		obj->type = NFT_OBJECT_SYNPROXY;
 		if (json_unpack_err(ctx, root, "{s:i, s:i}",
-				    "mss", &obj->synproxy.mss,
-				    "wscale", &obj->synproxy.wscale)) {
+				    "mss", &i, "wscale", &j)) {
 			obj_free(obj);
 			return NULL;
 		}
+		obj->synproxy.mss = i;
+		obj->synproxy.wscale = j;
 		obj->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
 		obj->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
 		if (!json_unpack(root, "{s:o}", "flags", &jflags)) {
-- 
2.41.0

