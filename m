From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH libnetfilter_conntrack] conntrack: remove duplicate code
Date: Tue, 17 Jun 2014 21:12:19 +0900
Message-ID: <20140617121219.GB24712@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:37714 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbaFQMM0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:12:26 -0400
Received: by mail-pb0-f43.google.com with SMTP id um1so2879165pbc.16
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2014 05:12:25 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nfct_filter_dump_set_attr() will set the bit.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/conntrack/filter_dump.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/conntrack/filter_dump.c b/src/conntrack/filter_dump.c
index 9e2e169..4819759 100644
--- a/src/conntrack/filter_dump.c
+++ b/src/conntrack/filter_dump.c
@@ -17,7 +17,6 @@ set_filter_dump_attr_mark(struct nfct_filter_dump *filter_dump,
 
 	filter_dump->mark.val = this->val;
 	filter_dump->mark.mask = this->mask;
-	filter_dump->set |= (1 << NFCT_FILTER_DUMP_MARK);
 }
 
 static void
@@ -25,7 +24,6 @@ set_filter_dump_attr_family(struct nfct_filter_dump *filter_dump,
 			    const void *value)
 {
 	filter_dump->l3num = *((u_int8_t *)value);
-	filter_dump->set |= (1 << NFCT_FILTER_DUMP_L3NUM);
 }
 
 const set_filter_dump_attr set_filter_dump_attr_array[NFCT_FILTER_DUMP_MAX] = {
-- 
1.9.1

