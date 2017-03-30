From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] iptables: extensions: Remove typedef in struct.
Date: Thu, 30 Mar 2017 14:34:05 +0530
Message-ID: <20170330090405.GA26814@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: outreachy-kernel@googlegroups.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34044 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753338AbdC3JEL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2017 05:04:11 -0400
Received: by mail-pg0-f67.google.com with SMTP id o123so8510450pga.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2017 02:04:10 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The Linux kernel coding style guidelines suggest not using typedefs for
structure. This patch gets rid of the typedefs for "_code".
The following Coccinelle semantic patch detects the cases for struct
type:

@tn@
identifier i;
type td;
@@

-typedef
 struct i { ... }
-td
 ;

@@
type tn.td;
identifier tn.i;
@@

-td
+ struct i

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 extensions/libebt_log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libebt_log.c b/extensions/libebt_log.c
index 0799185..f170af0 100644
--- a/extensions/libebt_log.c
+++ b/extensions/libebt_log.c
@@ -27,12 +27,12 @@
 #define LOG_LOG    '5'
 #define LOG_IP6    '6'
 
-typedef struct _code {
+struct code {
 	char *c_name;
 	int c_val;
-} CODE;
+};
 
-static CODE eight_priority[] = {
+static struct code eight_priority[] = {
 	{ "emerg", LOG_EMERG },
 	{ "alert", LOG_ALERT },
 	{ "crit", LOG_CRIT },
-- 
2.11.0

