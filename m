From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 7/7] extensions: libip6t_dst: make inversion work
Date: Thu, 19 Feb 2015 14:11:23 +0100
Message-ID: <1424351483-27617-8-git-send-email-fw@strlen.de>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58487 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbbBSNLy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:11:54 -0500
In-Reply-To: <1424351483-27617-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The inversion flag wasn't set in the match struct.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libip6t_dst.c | 8 ++++----
 extensions/libip6t_dst.t | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 3fd4c01..1f15162 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -70,22 +70,21 @@ parse_options(const char *optsstr, uint16_t *opts)
 			*next++='\0';
 
                 range = strchr(cp, ':');
-
                 if (range) {
                         if (i == IP6T_OPTS_OPTSNR-1)
 				xtables_error(PARAMETER_PROBLEM,
                                            "too many ports specified");
                         *range++ = '\0';
                 }
-
 		opts[i] = (parse_opts_num(cp, "opt") & 0xFF) << 8;
                 if (range) {
 			if (opts[i] == 0)
 				xtables_error(PARAMETER_PROBLEM,
 					"PAD0 hasn't got length");
 			opts[i] |= parse_opts_num(range, "length") & 0xFF;
-                } else
+		} else {
                         opts[i] |= (0x00FF);
+		}
 
 #ifdef DEBUG
 		printf("opts str: %s %s\n", cp, range);
@@ -112,6 +111,8 @@ static void dst_parse(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_DSTLEN:
+		if (cb->invert)
+			optinfo->invflags |= IP6T_OPTS_INV_LEN;
 		optinfo->flags |= IP6T_OPTS_LEN;
 		break;
 	case O_DSTOPTS:
@@ -152,7 +153,6 @@ static void dst_print(const void *ip, const struct xt_entry_match *match,
 		printf(" opts");
 
 	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
-
 	if (optinfo->invflags & ~IP6T_OPTS_INV_MASK)
 		printf(" Unknown invflags: 0x%X",
 		       optinfo->invflags & ~IP6T_OPTS_INV_MASK);
diff --git a/extensions/libip6t_dst.t b/extensions/libip6t_dst.t
index b2788aa..0b0013b 100644
--- a/extensions/libip6t_dst.t
+++ b/extensions/libip6t_dst.t
@@ -1,4 +1,5 @@
 :INPUT,FORWARD,OUTPUT
 -m dst --dst-len 0;=;OK
 -m dst --dst-opts 149:92,12:12,123:12;=;OK
+-m dst ! --dst-len 42;=;OK
 -m dst --dst-len 42 --dst-opts 149:92,12:12,123:12;=;OK
-- 
2.0.5

