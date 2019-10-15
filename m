Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27240ECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 14:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECD3D20650
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 14:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732524AbfJOORj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 10:17:39 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36912 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbfJOORj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 10:17:39 -0400
Received: from localhost ([::1]:50002 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKNdq-0003A8-IU; Tue, 15 Oct 2019 16:17:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 6/6] obj/tunnel: Fix for undefined behaviour
Date:   Tue, 15 Oct 2019 16:16:58 +0200
Message-Id: <20191015141658.11325-7-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191015141658.11325-1-phil@nwl.cc>
References: <20191015141658.11325-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cppcheck complains: Shifting signed 32-bit value by 31 bits is undefined
behaviour.

Indeed, NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR enum value is 31. Make sure
behaviour is as intended by shifting unsigned 1.

Fixes: ea63a05272f54 ("obj: add tunnel support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/obj/tunnel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 7ffade8c46ae7..100aa099c6e97 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -227,7 +227,7 @@ nftnl_obj_tunnel_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_VERSION) &&
 	    (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX) ||
 	     (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID) &&
-	      e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR)))) {
+	      e->flags & (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR)))) {
 		struct nlattr *nest_inner;
 
 		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
@@ -240,7 +240,7 @@ nftnl_obj_tunnel_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 		if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID))
 			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_HWID,
 					tun->u.tun_erspan.u.v2.hwid);
-		if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR))
+		if (e->flags & (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR))
 			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_DIR,
 					tun->u.tun_erspan.u.v2.dir);
 		mnl_attr_nest_end(nlh, nest_inner);
@@ -430,7 +430,7 @@ nftnl_obj_tunnel_parse_erspan(struct nftnl_obj *e, struct nlattr *attr,
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]) {
 		tun->u.tun_erspan.u.v2.dir =
 			mnl_attr_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]);
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR);
+		e->flags |= (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR);
 	}
 
 	return 0;
-- 
2.23.0

