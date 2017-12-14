From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 2/6] src/gen: Remove a pointless call to mnl_nlmsg_get_payload()
Date: Thu, 14 Dec 2017 20:40:21 +0100
Message-ID: <20171214194025.21334-3-phil@nwl.cc>
References: <20171214194025.21334-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58052 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbdLNTkh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Dec 2017 14:40:37 -0500
In-Reply-To: <20171214194025.21334-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is a common idiom in all *_nlmsg_parse() functions, but
nftnl_gen_nlmsg_parse() doesn't make use of the data pointer and the
compiler probably can't eliminate it since there could be a side-effect.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/gen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/gen.c b/src/gen.c
index 58b3a96dbdcb9..eafb015a25345 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -143,9 +143,9 @@ static int nftnl_gen_parse_attr_cb(const struct nlattr *attr, void *data)
 int nftnl_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_gen *gen)
 {
 	struct nlattr *tb[NFTA_GEN_MAX + 1] = {};
-	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
 
-	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_gen_parse_attr_cb, tb) < 0)
+	if (mnl_attr_parse(nlh, sizeof(struct nfgenmsg),
+			   nftnl_gen_parse_attr_cb, tb) < 0)
 		return -1;
 
 	if (tb[NFTA_GEN_ID]) {
-- 
2.13.1

