From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] iptables: extensions: Add space around operators
Date: Thu, 30 Mar 2017 04:46:31 +0530
Message-ID: <20170329231631.GA22081@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36098 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdC2XQh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 19:16:37 -0400
Received: by mail-pg0-f66.google.com with SMTP id 81so5387913pgh.3
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 16:16:36 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add spaces around operator and remove trailing whitespaces.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 extensions/dscp_helper.c    |  2 +-
 extensions/libarpt_mangle.c |  2 +-
 extensions/libip6t_ah.c     |  2 +-
 extensions/libip6t_dst.c    |  6 +++---
 extensions/libip6t_frag.c   |  2 +-
 extensions/libip6t_hbh.c    | 10 +++++-----
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/extensions/dscp_helper.c b/extensions/dscp_helper.c
index 75b1fec..359fbb2 100644
--- a/extensions/dscp_helper.c
+++ b/extensions/dscp_helper.c
@@ -68,7 +68,7 @@ dscp_to_name(unsigned int dscp)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(ds_classes); ++i) 
+	for (i = 0; i < ARRAY_SIZE(ds_classes); ++i)
 		if (dscp == ds_classes[i].dscp)
 			return ds_classes[i].name;
 
diff --git a/extensions/libarpt_mangle.c b/extensions/libarpt_mangle.c
index ec9b543..fdd2104 100644
--- a/extensions/libarpt_mangle.c
+++ b/extensions/libarpt_mangle.c
@@ -136,7 +136,7 @@ static void print_mac(const unsigned char *mac, int l)
 
 	for (j = 0; j < l; j++)
 		printf("%02x%s", mac[j],
-			(j==l-1) ? "" : ":");
+			(j == l-1) ? "" : ":");
 }
 
 static void
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index f35982f..38c71f2 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -89,7 +89,7 @@ static void ah_print(const void *ip, const struct xt_entry_match *match,
 	printf(" ah ");
 	print_spis("spi", ah->spis[0], ah->spis[1],
 		    ah->invflags & IP6T_AH_INV_SPI);
-	print_len("length", ah->hdrlen, 
+	print_len("length", ah->hdrlen,
 		    ah->invflags & IP6T_AH_INV_LEN);
 
 	if (ah->hdrres)
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index fe7e340..321e1f4 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -57,17 +57,17 @@ parse_options(const char *optsstr, uint16_t *opts)
 {
         char *buffer, *cp, *next, *range;
         unsigned int i;
-	
+
 	buffer = strdup(optsstr);
         if (!buffer)
 		xtables_error(OTHER_PROBLEM, "strdup failed");
-			
+
         for (cp = buffer, i = 0; cp && i < IP6T_OPTS_OPTSNR; cp = next, i++)
         {
                 next = strchr(cp, ',');
 
                 if (next)
-			*next++='\0';
+			*next++ = '\0';
 
                 range = strchr(cp, ':');
 
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 3842496..cd6e2eb 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -178,7 +178,7 @@ static int frag_xlate(struct xt_xlate *xl,
 {
 	const struct ip6t_frag *fraginfo =
 		(struct ip6t_frag *)params->match->data;
-	char *space= "";
+	char *space = "";
 
 	if (!(fraginfo->ids[0] == 0 && fraginfo->ids[1] == 0xFFFFFFFF)) {
 		xt_xlate_add(xl, "frag id %s",
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 76b4ff0..8e1b0ac 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -63,10 +63,10 @@ parse_options(const char *optsstr, uint16_t *opts)
 	buffer = strdup(optsstr);
 	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
 			
-        for (cp=buffer, i=0; cp && i<IP6T_OPTS_OPTSNR; cp=next,i++)
+        for (cp = buffer, i = 0; cp && i < IP6T_OPTS_OPTSNR; cp = next,i++)
         {
-                next=strchr(cp, ',');
-                if (next) *next++='\0';
+                next = strchr(cp, ',');
+                if (next) *next++ = '\0';
                 range = strchr(cp, ':');
                 if (range) {
                         if (i == IP6T_OPTS_OPTSNR-1)
@@ -122,8 +122,8 @@ print_options(unsigned int optsnr, uint16_t *optsp)
 {
 	unsigned int i;
 
-	for(i=0; i<optsnr; i++){
-		printf("%c", (i==0)?' ':',');
+	for(i = 0; i < optsnr; i++){
+		printf("%c", (i == 0)?' ':',');
 		printf("%d", (optsp[i] & 0xFF00)>>8);
 		if ((optsp[i] & 0x00FF) != 0x00FF){
 			printf(":%d", (optsp[i] & 0x00FF));
-- 
2.11.0

