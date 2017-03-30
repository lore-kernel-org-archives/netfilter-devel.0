From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] iptables: extensions: Add/Remove unnecessary spaces.
Date: Thu, 30 Mar 2017 10:33:05 +0530
Message-ID: <20170330050305.GA25722@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36711 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754335AbdC3FDM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2017 01:03:12 -0400
Received: by mail-pg0-f65.google.com with SMTP id 81so7120304pgh.3
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 22:03:11 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add or remove unnecessary spaces as reported by
checkpatch.pl.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 extensions/libebt_802_3.c       | 4 ++--
 extensions/libip6t_dst.c        | 8 ++++----
 extensions/libip6t_hbh.c        | 8 ++++----
 extensions/libip6t_ipv6header.c | 2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/extensions/libebt_802_3.c b/extensions/libebt_802_3.c
index f05d02e..6634e13 100644
--- a/extensions/libebt_802_3.c
+++ b/extensions/libebt_802_3.c
@@ -60,7 +60,7 @@ br802_3_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (i > 255 || *end != '\0')
 			xtables_error(PARAMETER_PROBLEM,
 				      "Problem with specified "
-					"sap hex value, %x",i);
+					"sap hex value, %x", i);
 		info->sap = i; /* one byte, so no byte order worries */
 		info->bitmask |= EBT_802_3_SAP;
 		break;
@@ -71,7 +71,7 @@ br802_3_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (i > 65535 || *end != '\0') {
 			xtables_error(PARAMETER_PROBLEM,
 				      "Problem with the specified "
-					"type hex value, %x",i);
+					"type hex value, %x", i);
 		}
 		info->type = htons(i);
 		info->bitmask |= EBT_802_3_TYPE;
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 321e1f4..2d7ea4f 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -36,16 +36,16 @@ parse_opts_num(const char *idstr, const char *typestr)
 
 	id = strtoul(idstr, &ep, 0);
 
-	if ( idstr == ep ) {
+	if (idstr == ep) {
 		xtables_error(PARAMETER_PROBLEM,
 		           "dst: no valid digits in %s `%s'", typestr, idstr);
 	}
-	if ( id == ULONG_MAX  && errno == ERANGE ) {
+	if (id == ULONG_MAX && errno == ERANGE) {
 		xtables_error(PARAMETER_PROBLEM,
 			   "%s `%s' specified too big: would overflow",
 			   typestr, idstr);
 	}
-	if ( *idstr != '\0'  && *ep != '\0' ) {
+	if (*idstr != '\0' && *ep != '\0') {
 		xtables_error(PARAMETER_PROBLEM,
 		           "dst: error parsing %s `%s'", typestr, idstr);
 	}
@@ -129,7 +129,7 @@ print_options(unsigned int optsnr, uint16_t *optsp)
 	unsigned int i;
 
 	printf(" ");
-	for(i = 0; i < optsnr; i++) {
+	for (i = 0; i < optsnr; i++) {
 		printf("%d", (optsp[i] & 0xFF00) >> 8);
 
 		if ((optsp[i] & 0x00FF) != 0x00FF)
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 8e1b0ac..6386786 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -36,18 +36,18 @@ parse_opts_num(const char *idstr, const char *typestr)
 	unsigned long int id;
 	char* ep;
 
-	id =  strtoul(idstr,&ep,0) ;
+	id =  strtoul(idstr, &ep, 0) ;
 
-	if ( idstr == ep ) {
+	if (idstr == ep) {
 		xtables_error(PARAMETER_PROBLEM,
 			   "hbh: no valid digits in %s `%s'", typestr, idstr);
 	}
-	if ( id == ULONG_MAX  && errno == ERANGE ) {
+	if (id == ULONG_MAX  && errno == ERANGE) {
 		xtables_error(PARAMETER_PROBLEM,
 			   "%s `%s' specified too big: would overflow",
 			   typestr, idstr);
 	}	
-	if ( *idstr != '\0'  && *ep != '\0' ) {
+	if (*idstr != '\0'  && *ep != '\0') {
 		xtables_error(PARAMETER_PROBLEM,
 			   "hbh: error parsing %s `%s'", typestr, idstr);
 	}
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 887d225..2e0cebb 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -110,7 +110,7 @@ add_proto_to_mask(int proto){
 	unsigned int i=0, flag=0;
 
 	for (i = 0; i < ARRAY_SIZE(chain_flags); ++i)
-			if (proto == chain_flags[i].proto){
+			if (proto == chain_flags[i].proto) {
 				flag = chain_flags[i].flag;
 				break;
 			}
-- 
2.11.0

