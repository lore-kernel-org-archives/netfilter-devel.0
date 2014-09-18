From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] extensions: libxt_devgroup: Fix the path of the mappings file
Date: Thu, 18 Sep 2014 13:06:42 +0200
Message-ID: <1411038402-7711-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50570 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbaIRLEK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:04:10 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so696125wgh.29
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2014 04:04:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use "/etc/iproute2/group" like the path of the mapping file instead of
"/etc/iproute2/group_map"

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 extensions/libxt_devgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index 4a69c82..fb1fcb5 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -31,12 +31,12 @@ static const struct xt_option_entry devgroup_opts[] = {
 	XTOPT_TABLEEND,
 };
 
-/* array of devgroups from /etc/iproute2/group_map */
+/* array of devgroups from /etc/iproute2/group */
 static struct xtables_lmap *devgroups;
 
 static void devgroup_init(struct xt_entry_match *match)
 {
-	const char file[] = "/etc/iproute2/group_map";
+	const char file[] = "/etc/iproute2/group";
 	devgroups = xtables_lmap_init(file);
 	if (devgroups == NULL && errno != ENOENT)
 		fprintf(stderr, "Warning: %s: %s\n", file, strerror(errno));
-- 
1.7.10.4

