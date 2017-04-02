From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 1/2] extensions: libarpt_mangle.c : Constify option struct
Date: Sun,  2 Apr 2017 12:35:07 +0530
Message-ID: <20170402070508.20770-1-arushisinghal19971997@gmail.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35646 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbdDBHFT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Apr 2017 03:05:19 -0400
Received: by mail-pf0-f196.google.com with SMTP id n11so5545013pfg.2
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Apr 2017 00:05:19 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct arpmangle_opts of the type option is only used to
initialise a field inside the xtables_target struct and is
not modified anywhere.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 extensions/libarpt_mangle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libarpt_mangle.c b/extensions/libarpt_mangle.c
index fdd2104..358b35d 100644
--- a/extensions/libarpt_mangle.c
+++ b/extensions/libarpt_mangle.c
@@ -32,7 +32,7 @@ static void arpmangle_print_help(void)
 #define MANGLE_DEVT   '4'
 #define MANGLE_TARGET '5'
 
-static struct option arpmangle_opts[] = {
+static const struct option arpmangle_opts[] = {
 	{ .name = "mangle-ip-s",	.has_arg = true, .val = MANGLE_IPS },
 	{ .name = "mangle-ip-d",	.has_arg = true, .val = MANGLE_IPT },
 	{ .name = "mangle-mac-s",	.has_arg = true, .val = MANGLE_DEVS },
-- 
2.11.0

