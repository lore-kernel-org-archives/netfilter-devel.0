Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 484DFC433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 10:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECC996127A
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 10:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbhD0Knv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbhD0Knu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 06:43:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2523C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Apr 2021 03:43:07 -0700 (PDT)
Received: from localhost ([::1]:59170 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lbLBI-0001YM-Lm; Tue, 27 Apr 2021 12:43:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] nft-arp: Make use of ipv4_addr_to_string()
Date:   Tue, 27 Apr 2021 12:42:59 +0200
Message-Id: <20210427104259.22042-3-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210427104259.22042-1-phil@nwl.cc>
References: <20210427104259.22042-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This eliminates quite a bit of redundant code apart from also dropping
use of obsolete function gethostbyaddr().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c | 99 ++++------------------------------------------
 iptables/xshared.c |  6 +--
 iptables/xshared.h |  3 ++
 3 files changed, 14 insertions(+), 94 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index c82ffdc95e300..2a9387a18dffe 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -42,78 +42,6 @@ char *arp_opcodes[] =
 	"ARP_NAK",
 };
 
-static char *
-addr_to_dotted(const struct in_addr *addrp)
-{
-	static char buf[20];
-	const unsigned char *bytep;
-
-	bytep = (const unsigned char *) &(addrp->s_addr);
-	sprintf(buf, "%d.%d.%d.%d", bytep[0], bytep[1], bytep[2], bytep[3]);
-	return buf;
-}
-
-static char *
-addr_to_host(const struct in_addr *addr)
-{
-	struct hostent *host;
-
-	if ((host = gethostbyaddr((char *) addr,
-					sizeof(struct in_addr), AF_INET)) != NULL)
-		return (char *) host->h_name;
-
-	return (char *) NULL;
-}
-
-static char *
-addr_to_network(const struct in_addr *addr)
-{
-	struct netent *net;
-
-	if ((net = getnetbyaddr((long) ntohl(addr->s_addr), AF_INET)) != NULL)
-		return (char *) net->n_name;
-
-	return (char *) NULL;
-}
-
-static char *
-addr_to_anyname(const struct in_addr *addr)
-{
-	char *name;
-
-	if ((name = addr_to_host(addr)) != NULL ||
-		(name = addr_to_network(addr)) != NULL)
-		return name;
-
-	return addr_to_dotted(addr);
-}
-
-static char *
-mask_to_dotted(const struct in_addr *mask)
-{
-	int i;
-	static char buf[22];
-	u_int32_t maskaddr, bits;
-
-	maskaddr = ntohl(mask->s_addr);
-
-	if (maskaddr == 0xFFFFFFFFL)
-		/* we don't want to see "/32" */
-		return "";
-
-	i = 32;
-	bits = 0xFFFFFFFEL;
-	while (--i >= 0 && maskaddr != bits)
-		bits <<= 1;
-	if (i >= 0)
-		sprintf(buf, "/%d", i);
-	else
-		/* mask was not a decent combination of 1's and 0's */
-		snprintf(buf, sizeof(buf), "/%s", addr_to_dotted(mask));
-
-	return buf;
-}
-
 static bool need_devaddr(struct arpt_devaddr_info *info)
 {
 	int i;
@@ -403,7 +331,6 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 				       unsigned int format)
 {
 	const struct arpt_entry *fw = &cs->arp;
-	char buf[BUFSIZ];
 	char iface[IFNAMSIZ+2];
 	const char *sep = "";
 	int print_iface = 0;
@@ -450,15 +377,10 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 	}
 
 	if (fw->arp.smsk.s_addr != 0L) {
-		printf("%s%s", sep, fw->arp.invflags & IPT_INV_SRCIP
-			? "! " : "");
-		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", addr_to_dotted(&(fw->arp.src)));
-		else
-			sprintf(buf, "%s", addr_to_anyname(&(fw->arp.src)));
-		strncat(buf, mask_to_dotted(&(fw->arp.smsk)),
-			sizeof(buf) - strlen(buf) - 1);
-		printf("-s %s", buf);
+		printf("%s%s-s %s", sep,
+		       fw->arp.invflags & IPT_INV_SRCIP ? "! " : "",
+		       ipv4_addr_to_string(&fw->arp.src,
+					   &fw->arp.smsk, format));
 		sep = " ";
 	}
 
@@ -476,15 +398,10 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 after_devsrc:
 
 	if (fw->arp.tmsk.s_addr != 0L) {
-		printf("%s%s", sep, fw->arp.invflags & IPT_INV_DSTIP
-			? "! " : "");
-		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", addr_to_dotted(&(fw->arp.tgt)));
-		else
-			sprintf(buf, "%s", addr_to_anyname(&(fw->arp.tgt)));
-		strncat(buf, mask_to_dotted(&(fw->arp.tmsk)),
-			sizeof(buf) - strlen(buf) - 1);
-		printf("-d %s", buf);
+		printf("%s%s-d %s", sep,
+		       fw->arp.invflags & IPT_INV_DSTIP ? "! " : "",
+		       ipv4_addr_to_string(&fw->arp.tgt,
+					   &fw->arp.tmsk, format));
 		sep = " ";
 	}
 
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 71f689901e1d4..9a1f465a5a6d3 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -550,9 +550,9 @@ void debug_print_argv(struct argv_store *store)
 }
 #endif
 
-static const char *ipv4_addr_to_string(const struct in_addr *addr,
-				       const struct in_addr *mask,
-				       unsigned int format)
+const char *ipv4_addr_to_string(const struct in_addr *addr,
+				const struct in_addr *mask,
+				unsigned int format)
 {
 	static char buf[BUFSIZ];
 
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 9159b2b1f3768..1e86aba8b2375 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -206,6 +206,9 @@ void debug_print_argv(struct argv_store *store);
 #  define debug_print_argv(...) /* nothing */
 #endif
 
+const char *ipv4_addr_to_string(const struct in_addr *addr,
+				const struct in_addr *mask,
+				unsigned int format);
 void print_ipv4_addresses(const struct ipt_entry *fw, unsigned int format);
 void print_ipv6_addresses(const struct ip6t_entry *fw6, unsigned int format);
 
-- 
2.31.0

