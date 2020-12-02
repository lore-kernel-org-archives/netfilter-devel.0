Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3719CC6369E
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB4AC217A0
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgLBX1p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgLBX1p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 18:27:45 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B4CC0613D6
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Dec 2020 15:27:05 -0800 (PST)
Received: from localhost ([::1]:47468 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kkbWZ-0008Ah-PB; Thu, 03 Dec 2020 00:27:03 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3] extensions: dccp: Fix for DCCP type 'INVALID'
Date:   Thu,  3 Dec 2020 00:26:59 +0100
Message-Id: <20201202232659.27382-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support for matching on invalid DCCP type field values was pretty
broken: While RFC4340 declares any type value from 10 to 15 invalid, the
extension's type name 'INVALID' mapped to type value 10 only. Fix this
by introduction of INVALID_OTHER_TYPE_MASK which has the remaining
invalid type's bits set and apply it if bit 10 is set after parsing the
type list. When printing, stop searching type names after printing
'INVALID' - unless numeric output was requested. The latter prints all
actual type values. Since parsing types in numeric form is not
supported, changing the output should not break existing scripts.

When translating into nftables syntax, the code returned prematurely if
'INVALID' was among the list of types - thereby emitting invalid syntax.
Instead print a real match for invalid types by use of a range
expression.

While being at it, fix syntax of translator output: If only
'--dccp-types' was translated, the output contained an extra 'dccp'. On
the other hand, if '--sport' and '--dport' was present, a required
'dccp' between the translations of both was missing.

Fixes: e40b11d7ef827 ("add support for new 'dccp' protocol match")
Fixes: c94a998724143 ("extensions: libxt_dccp: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Conditional break in print_types() happened too early, have to print
  the typename first.

Changes since v1:
- Actually fix INVALID type match, thereby aligning behaviour of xtables
  match and nftables translation.
---
 extensions/libxt_dccp.c      | 58 ++++++++++++++++++++++--------------
 extensions/libxt_dccp.txlate | 12 ++++++--
 2 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 5e67c264db2a9..aea3e20be4818 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -76,6 +76,9 @@ static const char *const dccp_pkt_types[] = {
 	[DCCP_PKT_INVALID]	= "INVALID",
 };
 
+/* Bits for type values 11-15 */
+#define INVALID_OTHER_TYPE_MASK		0xf800
+
 static uint16_t
 parse_dccp_types(const char *typestring)
 {
@@ -95,6 +98,9 @@ parse_dccp_types(const char *typestring)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unknown DCCP type `%s'", ptr);
 	}
+	if (typemask & (1 << DCCP_PKT_INVALID))
+		typemask |= INVALID_OTHER_TYPE_MASK;
+
 
 	free(buffer);
 	return typemask;
@@ -193,9 +199,13 @@ print_types(uint16_t types, int inverted, int numeric)
 
 		if (numeric)
 			printf("%u", i);
-		else
+		else {
 			printf("%s", dccp_pkt_types[i]);
 
+			if (i == DCCP_PKT_INVALID)
+				break;
+		}
+
 		types &= ~(1 << i);
 	}
 }
@@ -288,6 +298,7 @@ static const char *const dccp_pkt_types_xlate[] = {
 	[DCCP_PKT_RESET]        = "reset",
 	[DCCP_PKT_SYNC]         = "sync",
 	[DCCP_PKT_SYNCACK]      = "syncack",
+	[DCCP_PKT_INVALID]	= "10-15",
 };
 
 static int dccp_type_xlate(const struct xt_dccp_info *einfo,
@@ -296,10 +307,10 @@ static int dccp_type_xlate(const struct xt_dccp_info *einfo,
 	bool have_type = false, set_need = false;
 	uint16_t types = einfo->typemask;
 
-	if (types & (1 << DCCP_PKT_INVALID))
-		return 0;
-
-	xt_xlate_add(xl, " dccp type%s ", einfo->invflags ? " !=" : "");
+	if (types & INVALID_OTHER_TYPE_MASK) {
+		types &= ~INVALID_OTHER_TYPE_MASK;
+		types |= 1 << DCCP_PKT_INVALID;
+	}
 
 	if ((types != 0) && !(types == (types & -types))) {
 		xt_xlate_add(xl, "{");
@@ -335,34 +346,37 @@ static int dccp_xlate(struct xt_xlate *xl,
 	char *space = "";
 	int ret = 1;
 
-	xt_xlate_add(xl, "dccp ");
-
 	if (einfo->flags & XT_DCCP_SRC_PORTS) {
+		xt_xlate_add(xl, "dccp sport%s %u",
+			     einfo->invflags & XT_DCCP_SRC_PORTS ? " !=" : "",
+			     einfo->spts[0]);
+
 		if (einfo->spts[0] != einfo->spts[1])
-			xt_xlate_add(xl, "sport%s %u-%u",
-				     einfo->invflags & XT_DCCP_SRC_PORTS ? " !=" : "",
-				     einfo->spts[0], einfo->spts[1]);
-		else
-			xt_xlate_add(xl, "sport%s %u",
-				     einfo->invflags & XT_DCCP_SRC_PORTS ? " !=" : "",
-				     einfo->spts[0]);
+			xt_xlate_add(xl, "-%u", einfo->spts[1]);
+
 		space = " ";
 	}
 
 	if (einfo->flags & XT_DCCP_DEST_PORTS) {
+		xt_xlate_add(xl, "%sdccp dport%s %u", space,
+			     einfo->invflags & XT_DCCP_DEST_PORTS ? " !=" : "",
+			     einfo->dpts[0]);
+
 		if (einfo->dpts[0] != einfo->dpts[1])
-			xt_xlate_add(xl, "%sdport%s %u-%u", space,
-				     einfo->invflags & XT_DCCP_DEST_PORTS ? " !=" : "",
-				     einfo->dpts[0], einfo->dpts[1]);
-		else
-			xt_xlate_add(xl, "%sdport%s %u", space,
-				     einfo->invflags & XT_DCCP_DEST_PORTS ? " !=" : "",
-				     einfo->dpts[0]);
+			xt_xlate_add(xl, "-%u", einfo->dpts[1]);
+
+		space = " ";
 	}
 
-	if (einfo->flags & XT_DCCP_TYPE)
+	if (einfo->flags & XT_DCCP_TYPE && einfo->typemask) {
+		xt_xlate_add(xl, "%sdccp type%s ", space,
+			     einfo->invflags & XT_DCCP_TYPE ? " !=" : "");
 		ret = dccp_type_xlate(einfo, xl);
 
+		space = " ";
+	}
+
+	/* FIXME: no dccp option support in nftables yet */
 	if (einfo->flags & XT_DCCP_OPTION)
 		ret = 0;
 
diff --git a/extensions/libxt_dccp.txlate b/extensions/libxt_dccp.txlate
index b47dc65f5bc4f..ea853f6acf627 100644
--- a/extensions/libxt_dccp.txlate
+++ b/extensions/libxt_dccp.txlate
@@ -7,8 +7,14 @@ nft add rule ip filter INPUT dccp dport 100-200 counter
 iptables-translate -A INPUT -p dccp -m dccp ! --dport 100
 nft add rule ip filter INPUT dccp dport != 100 counter
 
-iptables-translate -A INPUT -p dccp -m dccp --dport 100 --dccp-types REQUEST,RESPONSE,DATA,ACK,DATAACK,CLOSEREQ,CLOSE,SYNC,SYNCACK
-nft add rule ip filter INPUT dccp dport 100 dccp type {request, response, data, ack, dataack, closereq, close, sync, syncack} counter
+iptables-translate -A INPUT -p dccp -m dccp --dccp-types CLOSE
+nft add rule ip filter INPUT dccp type close counter
+
+iptables-translate -A INPUT -p dccp -m dccp --dccp-types INVALID
+nft add rule ip filter INPUT dccp type 10-15 counter
+
+iptables-translate -A INPUT -p dccp -m dccp --dport 100 --dccp-types REQUEST,RESPONSE,DATA,ACK,DATAACK,CLOSEREQ,CLOSE,SYNC,SYNCACK,INVALID
+nft add rule ip filter INPUT dccp dport 100 dccp type {request, response, data, ack, dataack, closereq, close, sync, syncack, 10-15} counter
 
 iptables-translate -A INPUT -p dccp -m dccp --sport 200 --dport 100
-nft add rule ip filter INPUT dccp sport 200 dport 100 counter
+nft add rule ip filter INPUT dccp sport 200 dccp dport 100 counter
-- 
2.28.0

