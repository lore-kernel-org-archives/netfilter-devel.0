From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 7/7] ruleset: Initialize ctx.flags before calling nftnl_ruleset_ctx_set()
Date: Fri, 12 Aug 2016 01:33:39 +0200
Message-ID: <1470958419-32602-8-git-send-email-phil@nwl.cc>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52703 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbcHKXeX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:34:23 -0400
In-Reply-To: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The called function otherwise accesses uninitialized data.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/ruleset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/ruleset.c b/src/ruleset.c
index 93cf95ab61e15..a2d67cb550179 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -551,6 +551,7 @@ static int nftnl_ruleset_json_parse(const void *json,
 
 	ctx.cb = cb;
 	ctx.format = type;
+	ctx.flags = 0;
 
 	ctx.set_list = nftnl_set_list_alloc();
 	if (ctx.set_list == NULL)
@@ -682,6 +683,7 @@ static int nftnl_ruleset_xml_parse(const void *xml, struct nftnl_parse_err *err,
 
 	ctx.cb = cb;
 	ctx.format = type;
+	ctx.flags = 0;
 
 	ctx.set_list = nftnl_set_list_alloc();
 	if (ctx.set_list == NULL)
-- 
2.8.2

