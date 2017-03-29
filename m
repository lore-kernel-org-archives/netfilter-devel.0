From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] iptables: extensions: Add blank line after declarations.
Date: Thu, 30 Mar 2017 05:15:24 +0530
Message-ID: <20170329234524.GA23875@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34513 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932829AbdC2Xpa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 19:45:30 -0400
Received: by mail-pg0-f67.google.com with SMTP id o123so5522536pga.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 16:45:29 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add blank line after declaration as reported by checkpatch.pl.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 extensions/libip6t_mh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index f4c0fd9..ee17182 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -49,6 +49,7 @@ static const struct mh_name mh_names[] = {
 static void print_types_all(void)
 {
 	unsigned int i;
+
 	printf("Valid MH types:");
 
 	for (i = 0; i < ARRAY_SIZE(mh_names); ++i) {
-- 
2.11.0

