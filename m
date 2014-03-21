From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [nft PATCH] src: check if the set name is too long
Date: Fri, 21 Mar 2014 18:39:00 +0100
Message-ID: <1395423541-5098-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44002 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761155AbaCURjT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:39:19 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so2079321eek.11
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2014 10:39:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

checks if the name of set is larger than 16 chars
before to add it.
If so, the set is not added and an error message is printed.

I didn't figure out why, but another error message is printed, see below:

nft add set ip test thenameofthissetistoolooong { type ipv4_address\; }
<cmdline>:1:17-43: Error: set name is too long (> 16)
add set ip test thenameofthissetistoolooong { type ipv4_address; }
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^
<cmdline>:1:66-66: Error: syntax error, unexpected '}'
add set ip test thenameofthissetistoolooong { type ipv4_address; }

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 src/parser.y | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/parser.y b/src/parser.y
index db6f493..17fbd5e 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -15,6 +15,7 @@
 #include <inttypes.h>
 #include <netinet/ip.h>
 #include <netinet/if_ether.h>
+#include <net/if.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
@@ -986,6 +987,11 @@ chain_identifier	:	identifier
 
 set_spec		:	table_spec	identifier
 			{
+				if (strlen($2) > IFNAMSIZ) {
+					erec_queue(error(&@2, "set name too long (> %d)", IFNAMSIZ),
+						   state->msgs);
+					YYERROR;
+				}
 				$$		= $1;
 				$$.set		= $2;
 			}
@@ -993,6 +999,12 @@ set_spec		:	table_spec	identifier
 
 set_identifier		:	identifier
 			{
+				if (strlen($1) > IFNAMSIZ) {
+					erec_queue(error(&@1, "set name too long (> %d", IFNAMSIZ),
+						   state->msgs);
+					YYERROR;
+				}
+
 				memset(&$$, 0, sizeof($$));
 				$$.set		= $1;
 			}
-- 
1.8.3.2

