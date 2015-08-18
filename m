From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 8/8] conntrackd: missing break in expectation message parser function
Date: Tue, 18 Aug 2015 19:28:39 +0200
Message-ID: <1439918919-6937-9-git-send-email-pablo@netfilter.org>
References: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Cc: pwouters@redhat.com, fweimer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37628 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbbHRRWm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 13:22:42 -0400
In-Reply-To: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fortunately, the TLVs come in order in the message, however, if the order is
changed we'll incorrectly set up the expectation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parse.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/parse.c b/src/parse.c
index 3ac4092..919d36c 100644
--- a/src/parse.c
+++ b/src/parse.c
@@ -524,13 +524,15 @@ int msg2exp(struct nf_expect *exp, struct nethdr *net, size_t remain)
 			attr = NTA_NEXT(attr, len);
 			continue;
 		}
-		switch(exp_h[attr->nta_attr].exp_attr) {
+		switch (exp_h[attr->nta_attr].exp_attr) {
 		case ATTR_EXP_MASTER:
 			exp_h[attr->nta_attr].parse(master, attr->nta_attr,
 						    NTA_DATA(attr));
+			break;
 		case ATTR_EXP_EXPECTED:
 			exp_h[attr->nta_attr].parse(expected, attr->nta_attr,
 						    NTA_DATA(attr));
+			break;
 		case ATTR_EXP_MASK:
 			exp_h[attr->nta_attr].parse(mask, attr->nta_attr,
 						    NTA_DATA(attr));
-- 
1.7.10.4

