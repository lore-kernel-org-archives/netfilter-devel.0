From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/5] src: ct: make ct l3proto work
Date: Fri, 18 Dec 2015 22:08:02 +0100
Message-ID: <1450472883-19743-5-git-send-email-fw@strlen.de>
References: <1450472883-19743-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40519 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965296AbbLRVMC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 16:12:02 -0500
In-Reply-To: <1450472883-19743-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ct l3proto original == ipv6
<cmdline>:1:56-59: Error: Can't parse symbolic invalid expressions

Its just the nf protocol number -- no dependencies.  Just set right type.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index c705838..5a3fda3 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -184,8 +184,8 @@ static const struct ct_template ct_templates[] = {
 	[NFT_CT_HELPER]		= CT_TEMPLATE("helper",	    &string_type,
 					      BYTEORDER_HOST_ENDIAN,
 					      NF_CT_HELPER_NAME_LEN * BITS_PER_BYTE),
-	[NFT_CT_L3PROTOCOL]	= CT_TEMPLATE("l3proto",    &invalid_type,
-					      BYTEORDER_INVALID,
+	[NFT_CT_L3PROTOCOL]	= CT_TEMPLATE("l3proto",    &nfproto_type,
+					      BYTEORDER_HOST_ENDIAN,
 					      BITS_PER_BYTE),
 	[NFT_CT_SRC]		= CT_TEMPLATE("saddr",	    &invalid_type,
 					      BYTEORDER_BIG_ENDIAN, 0),
-- 
2.4.10

