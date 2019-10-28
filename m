Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138C7CA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA2DF20830
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbfJ1Psn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 11:48:43 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40116 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfJ1Psn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 11:48:43 -0400
Received: from localhost ([::1]:53206 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iP7G6-00025s-Hy; Mon, 28 Oct 2019 16:48:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 09/10] xtables-arp: Use xtables_parse_interface()
Date:   Mon, 28 Oct 2019 16:48:17 +0100
Message-Id: <20191028154818.31257-10-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028154818.31257-1-phil@nwl.cc>
References: <20191028154818.31257-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The local implementation differs just slightly but libxtables version
seems more correct (no needless memsetting of mask, more relevant
illegal character checking) so use that one.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-arp.c | 50 +++++-------------------------------------
 1 file changed, 6 insertions(+), 44 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index bbc1ceb6e8e38..9cfad76263d32 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -357,44 +357,6 @@ check_inverse(const char option[], int *invert, int *optidx, int argc)
 	return false;
 }
 
-static void
-parse_interface(const char *arg, char *vianame, unsigned char *mask)
-{
-	int vialen = strlen(arg);
-	unsigned int i;
-
-	memset(mask, 0, IFNAMSIZ);
-	memset(vianame, 0, IFNAMSIZ);
-
-	if (vialen + 1 > IFNAMSIZ)
-		xtables_error(PARAMETER_PROBLEM,
-			      "interface name `%s' must be shorter than IFNAMSIZ"
-			      " (%i)", arg, IFNAMSIZ-1);
-
-	strcpy(vianame, arg);
-	if (vialen == 0)
-		memset(mask, 0, IFNAMSIZ);
-	else if (vianame[vialen - 1] == '+') {
-		memset(mask, 0xFF, vialen - 1);
-		memset(mask + vialen - 1, 0, IFNAMSIZ - vialen + 1);
-		/* Don't remove `+' here! -HW */
-	} else {
-		/* Include nul-terminator in match */
-		memset(mask, 0xFF, vialen + 1);
-		memset(mask + vialen + 1, 0, IFNAMSIZ - vialen - 1);
-		for (i = 0; vianame[i]; i++) {
-			if (!isalnum(vianame[i])
-			    && vianame[i] != '_'
-			    && vianame[i] != '.') {
-				printf("Warning: weird character in interface"
-				       " `%s' (No aliases, :, ! or *).\n",
-				       vianame);
-				break;
-			}
-		}
-	}
-}
-
 static void
 set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
 	   int invert)
@@ -816,18 +778,18 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEIN, &cs.arp.arp.invflags,
 				   invert);
-			parse_interface(argv[optind-1],
-					cs.arp.arp.iniface,
-					cs.arp.arp.iniface_mask);
+			xtables_parse_interface(argv[optind-1],
+						cs.arp.arp.iniface,
+						cs.arp.arp.iniface_mask);
 			break;
 
 		case 'o':
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEOUT, &cs.arp.arp.invflags,
 				   invert);
-			parse_interface(argv[optind-1],
-					cs.arp.arp.outiface,
-					cs.arp.arp.outiface_mask);
+			xtables_parse_interface(argv[optind-1],
+						cs.arp.arp.outiface,
+						cs.arp.arp.outiface_mask);
 			break;
 
 		case 'v':
-- 
2.23.0

