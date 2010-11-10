From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] attr: remove redundant check for NULL
Date: Thu, 11 Nov 2010 00:08:03 +0100
Message-ID: <1289430485-16467-5-git-send-email-jengelh@medozas.de>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56318 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab0KJXIL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:08:11 -0500
In-Reply-To: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Calling mnl_attr_parse with cb==NULL is pointless, because the
function will do nothing else.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/attr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index 69fda0b..e22a8ac 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -260,7 +260,7 @@ int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
 	int len = nlh->nlmsg_len - MNL_NLMSG_HDRLEN - MNL_ALIGN(offset);
 
 	while (mnl_attr_ok(attr, len)) {
-		if (cb && (ret = cb(attr, data)) <= MNL_CB_STOP)
+		if ((ret = cb(attr, data)) <= MNL_CB_STOP)
 			return ret;
 		attr = mnl_attr_next(attr, &len);
 	}
@@ -289,7 +289,7 @@ int mnl_attr_parse_nested(const struct nlattr *nested,
 	int len = mnl_attr_get_payload_len(nested);
 
 	while (mnl_attr_ok(attr, len)) {
-		if (cb && (ret = cb(attr, data)) <= MNL_CB_STOP)
+		if ((ret = cb(attr, data)) <= MNL_CB_STOP)
 			return ret;
 		attr = mnl_attr_next(attr, &len);
 	}
-- 
1.7.1

