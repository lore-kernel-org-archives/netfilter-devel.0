From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH] libxt_recent: Remove ineffective checks for info->name
Date: Fri, 20 Oct 2017 13:24:36 +0200
Message-ID: <20171020112436.17679-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52678 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752172AbdJTLYs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 07:24:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In struct xt_recent_mtinfo{,_v1}, field 'name' is an array, not a
pointer. So there is no point in comparing it against NULL. Changing the
check to make sure it's content is not an empty string is pointless
either, since a non-empty default string is used and the argument parser
will refuse empty strings as --name argument. So simply get rid of the
checks altogether.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_recent.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index e1801f1c18952..055ae35080346 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -199,7 +199,7 @@ static void recent_print(const void *ip, const struct xt_entry_match *match,
 	if(info->hit_count) printf(" hit_count: %d", info->hit_count);
 	if (info->check_set & XT_RECENT_TTL)
 		printf(" TTL-Match");
-	if(info->name) printf(" name: %s", info->name);
+	printf(" name: %s", info->name);
 	if (info->side == XT_RECENT_SOURCE)
 		printf(" side: source");
 	if (info->side == XT_RECENT_DEST)
@@ -239,7 +239,7 @@ static void recent_save(const void *ip, const struct xt_entry_match *match,
 	if(info->hit_count) printf(" --hitcount %d", info->hit_count);
 	if (info->check_set & XT_RECENT_TTL)
 		printf(" --rttl");
-	if(info->name) printf(" --name %s",info->name);
+	printf(" --name %s",info->name);
 
 	switch(family) {
 	case NFPROTO_IPV4:
-- 
2.13.1

