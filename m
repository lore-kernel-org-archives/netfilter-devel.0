From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 3/6] src/object: Avoid returning garbage in nftnl_obj_do_parse()
Date: Thu, 14 Dec 2017 20:40:22 +0100
Message-ID: <20171214194025.21334-4-phil@nwl.cc>
References: <20171214194025.21334-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58088 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbdLNTlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Dec 2017 14:41:08 -0500
In-Reply-To: <20171214194025.21334-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It may happen that 'perr' variable does not get initialized, so making
parameter 'err' point to it in any case is error-prone. Avoid this by
initializing 'perr' upon declaration.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/object.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/object.c b/src/object.c
index 9a4ee712a2a95..da3423bf3381a 100644
--- a/src/object.c
+++ b/src/object.c
@@ -358,7 +358,7 @@ static int nftnl_obj_do_parse(struct nftnl_obj *obj, enum nftnl_parse_type type,
 			      const void *data, struct nftnl_parse_err *err,
 			      enum nftnl_parse_input input)
 {
-	struct nftnl_parse_err perr;
+	struct nftnl_parse_err perr = {};
 	int ret;
 
 	switch (type) {
-- 
2.13.1

