Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4E5C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiKLAVn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiKLAVl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:21:41 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37619326F9
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kbFPFLttbn6v1XkusNuXu3NVNoHx3aduNGragfIJ4kk=; b=MbNT3T9HLg9V2znrusmzGTSVSo
        lGHbHOPOFezd4Uw0eQoEAP4neSErOVdR8wF1iLYCGelno0XqstaTj1A4XdhpqEd3WCYxkDtn5Jw1M
        JYdih7WIWJx9Zdh+jlne9JFSfniKlmC0dRG+xPqIQU/FtoEuHoA/jY/Y5ZXrGy7bkdYhhGXTE4Ig6
        VNRyWv+Z3zwaawcbPnL6rlFqmV3Di6Kq/5GUivUPbcUgoFfTiT8va1mDcTnTUMS5ytYaKSKD+qA+g
        z0tMQVEOIhxL2XeV8LNwG4lOCbY2XS+2ouDHyXjgkk7xk4BKbINPJQcEIPYRUUSXFDZCpBS0RsffC
        6p4zNwcw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oteHC-00023n-Hf
        for netfilter-devel@vger.kernel.org; Sat, 12 Nov 2022 01:21:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/7] extensions: libebt_arp, libebt_ip: Use xtables_ipparse_any()
Date:   Sat, 12 Nov 2022 01:20:54 +0100
Message-Id: <20221112002056.31917-6-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221112002056.31917-1-phil@nwl.cc>
References: <20221112002056.31917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The libxtables function covers all formerly supported inputs (and more).
The extended libebt_arp.t passes before and after this patch.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_arp.c | 89 ++++-------------------------------------
 extensions/libebt_arp.t |  3 ++
 extensions/libebt_ip.c  | 86 +++++----------------------------------
 3 files changed, 21 insertions(+), 157 deletions(-)

diff --git a/extensions/libebt_arp.c b/extensions/libebt_arp.c
index d5035b956cc15..63a953d4637da 100644
--- a/extensions/libebt_arp.c
+++ b/extensions/libebt_arp.c
@@ -87,91 +87,17 @@ static void brarp_print_help(void)
 #define OPT_MAC_D  0x40
 #define OPT_GRAT   0x80
 
-static int undot_ip(char *ip, unsigned char *ip2)
-{
-	char *p, *q, *end;
-	long int onebyte;
-	int i;
-	char buf[20];
-
-	strncpy(buf, ip, sizeof(buf) - 1);
-
-	p = buf;
-	for (i = 0; i < 3; i++) {
-		if ((q = strchr(p, '.')) == NULL)
-			return -1;
-		*q = '\0';
-		onebyte = strtol(p, &end, 10);
-		if (*end != '\0' || onebyte > 255 || onebyte < 0)
-			return -1;
-		ip2[i] = (unsigned char)onebyte;
-		p = q + 1;
-	}
-
-	onebyte = strtol(p, &end, 10);
-	if (*end != '\0' || onebyte > 255 || onebyte < 0)
-		return -1;
-	ip2[3] = (unsigned char)onebyte;
-
-	return 0;
-}
-
-static int ip_mask(char *mask, unsigned char *mask2)
-{
-	char *end;
-	long int bits;
-	uint32_t mask22;
-
-	if (undot_ip(mask, mask2)) {
-		/* not the /a.b.c.e format, maybe the /x format */
-		bits = strtol(mask, &end, 10);
-		if (*end != '\0' || bits > 32 || bits < 0)
-			return -1;
-		if (bits != 0) {
-			mask22 = htonl(0xFFFFFFFF << (32 - bits));
-			memcpy(mask2, &mask22, 4);
-		} else {
-			mask22 = 0xFFFFFFFF;
-			memcpy(mask2, &mask22, 4);
-		}
-	}
-	return 0;
-}
-
-static void ebt_parse_ip_address(char *address, uint32_t *addr, uint32_t *msk)
-{
-	char *p;
-
-	/* first the mask */
-	if ((p = strrchr(address, '/')) != NULL) {
-		*p = '\0';
-		if (ip_mask(p + 1, (unsigned char *)msk)) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Problem with the IP mask '%s'", p + 1);
-			return;
-		}
-	} else
-		*msk = 0xFFFFFFFF;
-
-	if (undot_ip(address, (unsigned char *)addr)) {
-		xtables_error(PARAMETER_PROBLEM,
-			      "Problem with the IP address '%s'", address);
-		return;
-	}
-	*addr = *addr & *msk;
-}
-
 static int
 brarp_parse(int c, char **argv, int invert, unsigned int *flags,
 	    const void *entry, struct xt_entry_match **match)
 {
 	struct ebt_arp_info *arpinfo = (struct ebt_arp_info *)(*match)->data;
+	struct in_addr *ipaddr, ipmask;
 	long int i;
 	char *end;
-	uint32_t *addr;
-	uint32_t *mask;
 	unsigned char *maddr;
 	unsigned char *mmask;
+	unsigned int ipnr;
 
 	switch (c) {
 	case ARP_OPCODE:
@@ -231,24 +157,25 @@ brarp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case ARP_IP_S:
 	case ARP_IP_D:
+		xtables_ipparse_any(optarg, &ipaddr, &ipmask, &ipnr);
 		if (c == ARP_IP_S) {
 			EBT_CHECK_OPTION(flags, OPT_IP_S);
-			addr = &arpinfo->saddr;
-			mask = &arpinfo->smsk;
+			arpinfo->saddr = ipaddr->s_addr;
+			arpinfo->smsk = ipmask.s_addr;
 			arpinfo->bitmask |= EBT_ARP_SRC_IP;
 		} else {
 			EBT_CHECK_OPTION(flags, OPT_IP_D);
-			addr = &arpinfo->daddr;
-			mask = &arpinfo->dmsk;
+			arpinfo->daddr = ipaddr->s_addr;
+			arpinfo->dmsk = ipmask.s_addr;
 			arpinfo->bitmask |= EBT_ARP_DST_IP;
 		}
+		free(ipaddr);
 		if (invert) {
 			if (c == ARP_IP_S)
 				arpinfo->invflags |= EBT_ARP_SRC_IP;
 			else
 				arpinfo->invflags |= EBT_ARP_DST_IP;
 		}
-		ebt_parse_ip_address(optarg, addr, mask);
 		break;
 	case ARP_MAC_S:
 	case ARP_MAC_D:
diff --git a/extensions/libebt_arp.t b/extensions/libebt_arp.t
index 14ff0f097cfd8..96fbce906107c 100644
--- a/extensions/libebt_arp.t
+++ b/extensions/libebt_arp.t
@@ -6,6 +6,9 @@
 -p ARP ! --arp-ip-dst 1.2.3.4;-p ARP --arp-ip-dst ! 1.2.3.4 -j CONTINUE;OK
 -p ARP --arp-ip-src ! 0.0.0.0;=;OK
 -p ARP --arp-ip-dst ! 0.0.0.0/8;=;OK
+-p ARP --arp-ip-src ! 1.2.3.4/32;-p ARP --arp-ip-src ! 1.2.3.4;OK
+-p ARP --arp-ip-src ! 1.2.3.4/255.255.255.0;-p ARP --arp-ip-src ! 1.2.3.0/24;OK
+-p ARP --arp-ip-src ! 1.2.3.4/255.0.255.255;-p ARP --arp-ip-src ! 1.0.3.4/255.0.255.255;OK
 -p ARP --arp-mac-src 00:de:ad:be:ef:00;=;OK
 -p ARP --arp-mac-dst de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
 -p ARP --arp-gratuitous;=;OK
diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 8413a5aa8dd57..d13e83c06895d 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -164,80 +164,6 @@ parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
 }
 
 /* original code from ebtables: useful_functions.c */
-static int undot_ip(char *ip, unsigned char *ip2)
-{
-	char *p, *q, *end;
-	long int onebyte;
-	int i;
-	char buf[20];
-
-	strncpy(buf, ip, sizeof(buf) - 1);
-
-	p = buf;
-	for (i = 0; i < 3; i++) {
-		if ((q = strchr(p, '.')) == NULL)
-			return -1;
-		*q = '\0';
-		onebyte = strtol(p, &end, 10);
-		if (*end != '\0' || onebyte > 255 || onebyte < 0)
-			return -1;
-		ip2[i] = (unsigned char)onebyte;
-		p = q + 1;
-	}
-
-	onebyte = strtol(p, &end, 10);
-	if (*end != '\0' || onebyte > 255 || onebyte < 0)
-		return -1;
-	ip2[3] = (unsigned char)onebyte;
-
-	return 0;
-}
-
-static int ip_mask(char *mask, unsigned char *mask2)
-{
-	char *end;
-	long int bits;
-	uint32_t mask22;
-
-	if (undot_ip(mask, mask2)) {
-		/* not the /a.b.c.e format, maybe the /x format */
-		bits = strtol(mask, &end, 10);
-		if (*end != '\0' || bits > 32 || bits < 0)
-			return -1;
-		if (bits != 0) {
-			mask22 = htonl(0xFFFFFFFF << (32 - bits));
-			memcpy(mask2, &mask22, 4);
-		} else {
-			mask22 = 0xFFFFFFFF;
-			memcpy(mask2, &mask22, 4);
-		}
-	}
-	return 0;
-}
-
-static void ebt_parse_ip_address(char *address, uint32_t *addr, uint32_t *msk)
-{
-	char *p;
-
-	/* first the mask */
-	if ((p = strrchr(address, '/')) != NULL) {
-		*p = '\0';
-		if (ip_mask(p + 1, (unsigned char *)msk)) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Problem with the IP mask '%s'", p + 1);
-			return;
-		}
-	} else
-		*msk = 0xFFFFFFFF;
-
-	if (undot_ip(address, (unsigned char *)addr)) {
-		xtables_error(PARAMETER_PROBLEM,
-			      "Problem with the IP address '%s'", address);
-		return;
-	}
-	*addr = *addr & *msk;
-}
-
 static char *parse_range(const char *str, unsigned int res[])
 {
 	char *next;
@@ -355,18 +281,26 @@ brip_parse(int c, char **argv, int invert, unsigned int *flags,
 	   const void *entry, struct xt_entry_match **match)
 {
 	struct ebt_ip_info *info = (struct ebt_ip_info *)(*match)->data;
+	struct in_addr *ipaddr, ipmask;
+	unsigned int ipnr;
 
 	switch (c) {
 	case IP_SOURCE:
 		if (invert)
 			info->invflags |= EBT_IP_SOURCE;
-		ebt_parse_ip_address(optarg, &info->saddr, &info->smsk);
+		xtables_ipparse_any(optarg, &ipaddr, &ipmask, &ipnr);
+		info->saddr = ipaddr->s_addr;
+		info->smsk = ipmask.s_addr;
+		free(ipaddr);
 		info->bitmask |= EBT_IP_SOURCE;
 		break;
 	case IP_DEST:
 		if (invert)
 			info->invflags |= EBT_IP_DEST;
-		ebt_parse_ip_address(optarg, &info->daddr, &info->dmsk);
+		xtables_ipparse_any(optarg, &ipaddr, &ipmask, &ipnr);
+		info->daddr = ipaddr->s_addr;
+		info->dmsk = ipmask.s_addr;
+		free(ipaddr);
 		info->bitmask |= EBT_IP_DEST;
 		break;
 	case IP_SPORT:
-- 
2.38.0

