Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30809C43217
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237569AbhKXR1f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbhKXR1e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:27:34 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144A0C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:24 -0800 (PST)
Received: from localhost ([::1]:44898 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw0M-00019J-At; Wed, 24 Nov 2021 18:24:22 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 05/15] meta: Fix {g,u}id_type on Big Endian
Date:   Wed, 24 Nov 2021 18:22:41 +0100
Message-Id: <20211124172251.11539-6-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Using a 64bit variable to temporarily hold the parsed value works only
on Little Endian. uid_t and gid_t (and therefore also pw->pw_uid and
gr->gr_gid) are 32bit.
To fix this, use uid_t/gid_t for the temporary variable but keep the
64bit one for numeric parsing so values exceeding 32bits are still
detected.

Fixes: e0ed4c45d9ad2 ("meta: relax restriction on UID/GID parsing")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/meta.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index bdd10269569d2..1794495ebba1c 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -220,18 +220,20 @@ static struct error_record *uid_type_parse(struct parse_ctx *ctx,
 					   struct expr **res)
 {
 	struct passwd *pw;
-	uint64_t uid;
+	uid_t uid;
 	char *endptr = NULL;
 
 	pw = getpwnam(sym->identifier);
 	if (pw != NULL)
 		uid = pw->pw_uid;
 	else {
-		uid = strtoull(sym->identifier, &endptr, 10);
-		if (uid > UINT32_MAX)
+		uint64_t _uid = strtoull(sym->identifier, &endptr, 10);
+
+		if (_uid > UINT32_MAX)
 			return error(&sym->location, "Value too large");
 		else if (*endptr)
 			return error(&sym->location, "User does not exist");
+		uid = _uid;
 	}
 
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
@@ -274,18 +276,20 @@ static struct error_record *gid_type_parse(struct parse_ctx *ctx,
 					   struct expr **res)
 {
 	struct group *gr;
-	uint64_t gid;
+	gid_t gid;
 	char *endptr = NULL;
 
 	gr = getgrnam(sym->identifier);
 	if (gr != NULL)
 		gid = gr->gr_gid;
 	else {
-		gid = strtoull(sym->identifier, &endptr, 0);
-		if (gid > UINT32_MAX)
+		uint64_t _gid = strtoull(sym->identifier, &endptr, 0);
+
+		if (_gid > UINT32_MAX)
 			return error(&sym->location, "Value too large");
 		else if (*endptr)
 			return error(&sym->location, "Group does not exist");
+		gid = _gid;
 	}
 
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
-- 
2.33.0

