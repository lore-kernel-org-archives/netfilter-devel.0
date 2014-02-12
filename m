From: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 1/2] lib: fix ifname 'physdev:' prefix parsing
Date: Wed, 12 Feb 2014 10:27:19 +0100
Message-ID: <1392197240-9389-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37573 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbaBLJbH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:31:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hash:net,iface supports matching on the bridge port as well,
but userspace currently doesn't handle it correctly as it passes
in 'physdev:eth0' instead of 'eth0'+IPSET_OPT_PHYSDEV.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 lib/parse.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/parse.c b/lib/parse.c
index f1c1f0e..4db872e 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -1753,14 +1753,15 @@ ipset_parse_iface(struct ipset_session *session,
 {
 	struct ipset_data *data;
 	int offset = 0, err = 0;
+	static const char pdev_prefix[]="physdev:";
 
 	assert(session);
 	assert(opt == IPSET_OPT_IFACE);
 	assert(str);
 
 	data = ipset_session_data(session);
-	if (STREQ(str, "physdev:")) {
-		offset = 8;
+	if (STRNEQ(str, pdev_prefix, strlen(pdev_prefix))) {
+		offset = strlen(pdev_prefix);
 		err = ipset_data_set(data, IPSET_OPT_PHYSDEV, str);
 		if (err < 0)
 			return err;
-- 
1.8.1.5

