Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF890C47083
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A7CB61360
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhFBP0Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 11:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhFBP0Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 11:26:25 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C71C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 08:24:41 -0700 (PDT)
Received: from localhost ([::1]:43118 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1loSjW-0007Pt-TP; Wed, 02 Jun 2021 17:24:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 7/9] extensions: libebt_ip6: Use xtables_ip6parse_any()
Date:   Wed,  2 Jun 2021 17:24:01 +0200
Message-Id: <20210602152403.5689-8-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602152403.5689-1-phil@nwl.cc>
References: <20210602152403.5689-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The code was almost identical and suffered from the same problem as
fixed in commit a76a5c997a235 ("libxtables: fix two off-by-one memory
corruption bugs").

The only functional change this involves is ebt_parse_ip6_address() will
now accept hostnames as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip6.c | 74 ++++++-----------------------------------
 1 file changed, 10 insertions(+), 64 deletions(-)

diff --git a/extensions/libebt_ip6.c b/extensions/libebt_ip6.c
index 301bed9aadefd..3cc39271d4658 100644
--- a/extensions/libebt_ip6.c
+++ b/extensions/libebt_ip6.c
@@ -247,73 +247,19 @@ static void brip6_init(struct xt_entry_match *match)
 	memset(ipinfo->dmsk.s6_addr, 0, sizeof(ipinfo->dmsk.s6_addr));
 }
 
-static struct in6_addr *numeric_to_addr(const char *num)
+/* wrap xtables_ip6parse_any(), ignoring any but the first returned address */
+static void ebt_parse_ip6_address(char *address,
+				  struct in6_addr *addr, struct in6_addr *msk)
 {
-	static struct in6_addr ap;
-
-	if (inet_pton(AF_INET6, num, &ap) == 1)
-		return &ap;
-	return (struct in6_addr *)NULL;
-}
-
-static struct in6_addr *parse_ip6_mask(char *mask)
-{
-	static struct in6_addr maskaddr;
 	struct in6_addr *addrp;
-	unsigned int bits;
-
-	if (mask == NULL) {
-		/* no mask at all defaults to 128 bits */
-		memset(&maskaddr, 0xff, sizeof maskaddr);
-		return &maskaddr;
-	}
-	if ((addrp = numeric_to_addr(mask)) != NULL)
-		return addrp;
-	if (!xtables_strtoui(mask, NULL, &bits, 0, 128))
-		xtables_error(PARAMETER_PROBLEM, "Invalid IPv6 Mask '%s' specified", mask);
-	if (bits != 0) {
-		char *p = (char *)&maskaddr;
-		memset(p, 0xff, bits / 8);
-		memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
-		p[bits / 8] = 0xff << (8 - (bits & 7));
-		return &maskaddr;
-	}
+	unsigned int naddrs;
 
-	memset(&maskaddr, 0, sizeof maskaddr);
-	return &maskaddr;
-}
-
-/* Set the ipv6 mask and address. Callers should check ebt_errormsg[0].
- * The string pointed to by address can be altered. */
-static void ebt_parse_ip6_address(char *address, struct in6_addr *addr, struct in6_addr *msk)
-{
-	struct in6_addr *tmp_addr;
-	char buf[256];
-	char *p;
-	int i;
-
-	strncpy(buf, address, sizeof(buf) - 1);
-	/* first the mask */
-	buf[sizeof(buf) - 1] = '\0';
-	if ((p = strrchr(buf, '/')) != NULL) {
-		*p = '\0';
-		tmp_addr = parse_ip6_mask(p + 1);
-	} else
-		tmp_addr = parse_ip6_mask(NULL);
-
-	*msk = *tmp_addr;
-
-	/* if a null mask is given, the name is ignored, like in "any/0" */
-	if (!memcmp(msk, &in6addr_any, sizeof(in6addr_any)))
-		strcpy(buf, "::");
-
-	if (inet_pton(AF_INET6, buf, addr) < 1) {
-		xtables_error(PARAMETER_PROBLEM, "Invalid IPv6 Address '%s' specified", buf);
-		return;
-	}
-
-	for (i = 0; i < 4; i++)
-		addr->s6_addr32[i] &= msk->s6_addr32[i];
+	xtables_ip6parse_any(address, &addrp, msk, &naddrs);
+	if (naddrs != 1)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Invalid IPv6 Address '%s' specified", address);
+	memcpy(addr, addrp, sizeof(*addr));
+	free(addrp);
 }
 
 #define OPT_SOURCE 0x01
-- 
2.31.1

