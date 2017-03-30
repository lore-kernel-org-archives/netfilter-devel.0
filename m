From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] iptables: extensions: Remove spaces.
Date: Thu, 30 Mar 2017 23:47:41 +0530
Message-ID: <20170330181741.GA3838@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33474 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933378AbdC3SRs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2017 14:17:48 -0400
Received: by mail-pg0-f65.google.com with SMTP id 79so11778960pgf.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2017 11:17:47 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Solve the checkpatch issue:
space prohibited before close parenthesis ')'
space prohibited after open parenthesis '('

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 extensions/libip6t_ah.c  | 4 ++--
 extensions/libip6t_dst.c | 6 +++---
 extensions/libip6t_hbh.c | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 38c71f2..fc3e524 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -118,13 +118,13 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 			       ahinfo->spis[0]);
 	}
 
-	if (ahinfo->hdrlen != 0 || (ahinfo->invflags & IP6T_AH_INV_LEN) ) {
+	if (ahinfo->hdrlen != 0 || (ahinfo->invflags & IP6T_AH_INV_LEN)) {
 		printf("%s --ahlen %u",
 			(ahinfo->invflags & IP6T_AH_INV_LEN) ? " !" : "",
 			ahinfo->hdrlen);
 	}
 
-	if (ahinfo->hdrres != 0 )
+	if (ahinfo->hdrres != 0)
 		printf(" --ahres");
 }
 
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 321e1f4..83358ab 100644
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
+	if (id == ULONG_MAX  && errno == ERANGE) {
 		xtables_error(PARAMETER_PROBLEM,
 			   "%s `%s' specified too big: would overflow",
 			   typestr, idstr);
 	}
-	if ( *idstr != '\0'  && *ep != '\0' ) {
+	if (*idstr != '\0'  && *ep != '\0') {
 		xtables_error(PARAMETER_PROBLEM,
 		           "dst: error parsing %s `%s'", typestr, idstr);
 	}
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 8e1b0ac..469fecf 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -38,16 +38,16 @@ parse_opts_num(const char *idstr, const char *typestr)
 
 	id =  strtoul(idstr,&ep,0) ;
 
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
-- 
2.11.0

