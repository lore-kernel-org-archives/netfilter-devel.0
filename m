From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_devgroup: Fix order of mask and id
Date: Thu, 2 Jun 2016 18:54:42 +0530
Message-ID: <20160602132442.GA7807@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35996 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346AbcFBNZY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 09:25:24 -0400
Received: by mail-pa0-f68.google.com with SMTP id fg1so3352674pad.3
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jun 2016 06:25:24 -0700 (PDT)
Received: from shivani ([116.202.34.180])
        by smtp.gmail.com with ESMTPSA id 8sm1073718pfq.11.2016.06.02.06.25.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 02 Jun 2016 06:25:23 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The order of mask and id in the translated code is not apt
so fix it.
This patch follows commit 8548dd by Liping Zhang.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_devgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index a30fff0..f110ea7 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -158,8 +158,8 @@ print_devgroup_xlate(unsigned int id, uint32_t op,  unsigned int mask,
 	const char *name = NULL;
 
 	if (mask != 0xffffffff)
-		xt_xlate_add(xl, "and 0x%x %s 0x%x ", id,
-			   op == XT_OP_EQ ? "==" : "!=", mask);
+		xt_xlate_add(xl, "and 0x%x %s 0x%x ", mask,
+			   op == XT_OP_EQ ? "==" : "!=", id);
 	else {
 		if (numeric == 0)
 			name = xtables_lmap_id2name(devgroups, id);
-- 
1.9.1

