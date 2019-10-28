Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66950CA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45D8620830
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbfJ1Pst (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 11:48:49 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40122 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfJ1Pss (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 11:48:48 -0400
Received: from localhost ([::1]:53212 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iP7GB-00026E-SJ; Mon, 28 Oct 2019 16:48:47 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 07/10] xtables-arp: Integrate OPT_* defines into xshared.h
Date:   Mon, 28 Oct 2019 16:48:15 +0100
Message-Id: <20191028154818.31257-8-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028154818.31257-1-phil@nwl.cc>
References: <20191028154818.31257-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These defines are internal use only, so their actual value doesn't
matter as long as they're unique and inverse_for_options array items
match:

When negating a given option, the corresponding OPT_* value's bit is
used as an index into inverse_for_options to retrieve the corresponding
invflag. If zero, either negating or the option itself is not supported.
(In practice, a lookup for unsupported option won't happen as those are
caught by getopt_long()).

Since xtables-arp's OPT_* values change, adjust the local
inverse_for_options array accordingly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Adjust inverse_for_options array size and content to changed OPT_*
  values.
- Add a comment to inverse_for_options array highlighting the
  connection.
- Extend commit message to elaborate on the necessary adjustment.
---
 iptables/xshared.h     |  7 +++++++
 iptables/xtables-arp.c | 43 ++++++++++++++----------------------------
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/iptables/xshared.h b/iptables/xshared.h
index b0738b042e95a..490b19ade5106 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -29,6 +29,13 @@ enum {
 	OPT_VIANAMEOUT  = 1 << 8,
 	OPT_LINENUMBERS = 1 << 9,
 	OPT_COUNTERS    = 1 << 10,
+	/* below are for arptables only */
+	OPT_S_MAC	= 1 << 11,
+	OPT_D_MAC	= 1 << 12,
+	OPT_H_LENGTH	= 1 << 13,
+	OPT_OPCODE	= 1 << 14,
+	OPT_H_TYPE	= 1 << 15,
+	OPT_P_TYPE	= 1 << 16,
 };
 
 enum {
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 4949ddd3d486c..8339b2cb6f38c 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -57,23 +57,6 @@ typedef char arpt_chainlabel[32];
 
 #define OPTION_OFFSET 256
 
-#define OPT_NONE	0x00000U
-#define OPT_NUMERIC	0x00001U
-#define OPT_S_IP	0x00002U
-#define OPT_D_IP	0x00004U
-#define OPT_S_MAC	0x00008U
-#define OPT_D_MAC	0x00010U
-#define OPT_H_LENGTH	0x00020U
-#define OPT_P_LENGTH	0x00040U
-#define OPT_OPCODE	0x00080U
-#define OPT_H_TYPE	0x00100U
-#define OPT_P_TYPE	0x00200U
-#define OPT_JUMP	0x00400U
-#define OPT_VERBOSE	0x00800U
-#define OPT_VIANAMEIN	0x01000U
-#define OPT_VIANAMEOUT	0x02000U
-#define OPT_LINENUMBERS 0x04000U
-#define OPT_COUNTERS	0x08000U
 #define NUMBER_OF_OPT	16
 static const char optflags[NUMBER_OF_OPT]
 = { 'n', 's', 'd', 2, 3, 7, 8, 4, 5, 6, 'j', 'v', 'i', 'o', '0', 'c'};
@@ -132,24 +115,26 @@ struct xtables_globals arptables_globals = {
 	.compat_rev		= nft_compatible_revision,
 };
 
-static int inverse_for_options[NUMBER_OF_OPT] =
+/* index relates to bit of each OPT_* value */
+static int inverse_for_options[] =
 {
 /* -n */ 0,
 /* -s */ ARPT_INV_SRCIP,
 /* -d */ ARPT_INV_TGTIP,
-/* 2 */ ARPT_INV_SRCDEVADDR,
-/* 3 */ ARPT_INV_TGTDEVADDR,
-/* -l */ ARPT_INV_ARPHLN,
-/* 8 */ 0,
-/* 4 */ ARPT_INV_ARPOP,
-/* 5 */ ARPT_INV_ARPHRD,
-/* 6 */ ARPT_INV_ARPPRO,
+/* -p */ 0,
 /* -j */ 0,
 /* -v */ 0,
+/* -x */ 0,
 /* -i */ ARPT_INV_VIA_IN,
 /* -o */ ARPT_INV_VIA_OUT,
 /*--line*/ 0,
 /* -c */ 0,
+/* 2 */ ARPT_INV_SRCDEVADDR,
+/* 3 */ ARPT_INV_TGTDEVADDR,
+/* -l */ ARPT_INV_ARPHLN,
+/* 4 */ ARPT_INV_ARPOP,
+/* 5 */ ARPT_INV_ARPHRD,
+/* 6 */ ARPT_INV_ARPPRO,
 };
 
 /* Primitive headers... */
@@ -747,14 +732,14 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			break;
 		case 's':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_S_IP, &cs.arp.arp.invflags,
+			set_option(&options, OPT_SOURCE, &cs.arp.arp.invflags,
 				   invert);
 			shostnetworkmask = argv[optind-1];
 			break;
 
 		case 'd':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_D_IP, &cs.arp.arp.invflags,
+			set_option(&options, OPT_DESTINATION, &cs.arp.arp.invflags,
 				   invert);
 			dhostnetworkmask = argv[optind-1];
 			break;
@@ -965,9 +950,9 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			      "nothing appropriate following !");
 
 	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
-		if (!(options & OPT_D_IP))
+		if (!(options & OPT_DESTINATION))
 			dhostnetworkmask = "0.0.0.0/0";
-		if (!(options & OPT_S_IP))
+		if (!(options & OPT_SOURCE))
 			shostnetworkmask = "0.0.0.0/0";
 	}
 
-- 
2.23.0

