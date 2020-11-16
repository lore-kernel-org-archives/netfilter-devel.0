Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07236C5519F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 14:03:16 +0000 (UTC)
Received: from vger.kernel.org (unknown [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41EEE22245
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 14:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41EEE22245
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=netfilter-devel-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgKPOCy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 09:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbgKPOCx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 09:02:53 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3025C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 06:02:53 -0800 (PST)
Received: from localhost ([::1]:51034 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kef5o-0001Rg-4Q; Mon, 16 Nov 2020 15:02:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] libxtables: Extend MAC address printing/parsing support
Date:   Mon, 16 Nov 2020 15:02:36 +0100
Message-Id: <20201116140238.25955-2-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201116140238.25955-1-phil@nwl.cc>
References: <20201116140238.25955-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adding a parser which supports common names for special MAC/mask
combinations and a print routine detecting those special addresses and
printing the respective name allows to consolidate all the various
duplicated implementations.

The side-effects of this change are manageable:

* arptables now accepts "BGA" as alias for the bridge group address
* "mac" match now prints MAC addresses in lower-case which is consistent
  with the remaining code at least

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libarpt_mangle.c                   | 13 +---
 extensions/libebt_arp.c                       | 50 +------------
 extensions/libebt_stp.c                       | 60 ++-------------
 extensions/libxt_mac.c                        | 15 +---
 include/xtables.h                             |  3 +
 iptables/nft-bridge.c                         | 37 +---------
 .../ipt-save/dumps/ipt-save-filter.txt        |  4 +-
 iptables/xtables-arp.c                        | 50 +------------
 iptables/xtables-eb-translate.c               |  8 +-
 iptables/xtables-eb.c                         | 59 ++-------------
 libxtables/xtables.c                          | 73 +++++++++++++++++++
 11 files changed, 106 insertions(+), 266 deletions(-)

diff --git a/extensions/libarpt_mangle.c b/extensions/libarpt_mangle.c
index 2fea6185ca1b5..a2378a8ba6ccb 100644
--- a/extensions/libarpt_mangle.c
+++ b/extensions/libarpt_mangle.c
@@ -130,15 +130,6 @@ static void arpmangle_final_check(unsigned int flags)
 {
 }
 
-static void print_mac(const unsigned char *mac, int l)
-{
-	int j;
-
-	for (j = 0; j < l; j++)
-		printf("%02x%s", mac[j],
-			(j==l-1) ? "" : ":");
-}
-
 static const char *ipaddr_to(const struct in_addr *addrp, int numeric)
 {
 	if (numeric)
@@ -159,7 +150,7 @@ arpmangle_print(const void *ip, const struct xt_entry_target *target,
 	}
 	if (m->flags & ARPT_MANGLE_SDEV) {
 		printf(" --mangle-mac-s ");
-		print_mac((unsigned char *)m->src_devaddr, 6);
+		xtables_print_mac((unsigned char *)m->src_devaddr);
 	}
 	if (m->flags & ARPT_MANGLE_TIP) {
 		printf(" --mangle-ip-d %s",
@@ -167,7 +158,7 @@ arpmangle_print(const void *ip, const struct xt_entry_target *target,
 	}
 	if (m->flags & ARPT_MANGLE_TDEV) {
 		printf(" --mangle-mac-d ");
-		print_mac((unsigned char *)m->tgt_devaddr, 6);
+		xtables_print_mac((unsigned char *)m->tgt_devaddr);
 	}
 	if (m->target != NF_ACCEPT) {
 		printf(" --mangle-target %s",
diff --git a/extensions/libebt_arp.c b/extensions/libebt_arp.c
index a062b7e7e5864..d5035b956cc15 100644
--- a/extensions/libebt_arp.c
+++ b/extensions/libebt_arp.c
@@ -161,54 +161,6 @@ static void ebt_parse_ip_address(char *address, uint32_t *addr, uint32_t *msk)
 	*addr = *addr & *msk;
 }
 
-static int brarp_get_mac_and_mask(const char *from, unsigned char *to, unsigned char *mask)
-{
-	char *p;
-	int i;
-	struct ether_addr *addr = NULL;
-
-	static const unsigned char mac_type_unicast[ETH_ALEN];
-	static const unsigned char msk_type_unicast[ETH_ALEN] =   {1,0,0,0,0,0};
-	static const unsigned char mac_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
-	static const unsigned char mac_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
-	static const unsigned char mac_type_bridge_group[ETH_ALEN] = {0x01,0x80,0xc2,0,0,0};
-	static const unsigned char msk_type_bridge_group[ETH_ALEN] = {255,255,255,255,255,255};
-
-	if (strcasecmp(from, "Unicast") == 0) {
-		memcpy(to, mac_type_unicast, ETH_ALEN);
-		memcpy(mask, msk_type_unicast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "Multicast") == 0) {
-		memcpy(to, mac_type_multicast, ETH_ALEN);
-		memcpy(mask, mac_type_multicast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "Broadcast") == 0) {
-		memcpy(to, mac_type_broadcast, ETH_ALEN);
-		memcpy(mask, mac_type_broadcast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "BGA") == 0) {
-		memcpy(to, mac_type_bridge_group, ETH_ALEN);
-		memcpy(mask, msk_type_bridge_group, ETH_ALEN);
-		return 0;
-	}
-	if ( (p = strrchr(from, '/')) != NULL) {
-		*p = '\0';
-		if (!(addr = ether_aton(p + 1)))
-			return -1;
-		memcpy(mask, addr, ETH_ALEN);
-	} else
-		memset(mask, 0xff, ETH_ALEN);
-	if (!(addr = ether_aton(from)))
-		return -1;
-	memcpy(to, addr, ETH_ALEN);
-	for (i = 0; i < ETH_ALEN; i++)
-		to[i] &= mask[i];
-	return 0;
-}
-
 static int
 brarp_parse(int c, char **argv, int invert, unsigned int *flags,
 	    const void *entry, struct xt_entry_match **match)
@@ -317,7 +269,7 @@ brarp_parse(int c, char **argv, int invert, unsigned int *flags,
 			else
 				arpinfo->invflags |= EBT_ARP_DST_MAC;
 		}
-		if (brarp_get_mac_and_mask(optarg, maddr, mmask))
+		if (xtables_parse_mac_and_mask(optarg, maddr, mmask))
 			xtables_error(PARAMETER_PROBLEM, "Problem with ARP MAC address argument");
 		break;
 	case ARP_GRAT:
diff --git a/extensions/libebt_stp.c b/extensions/libebt_stp.c
index 06cf93b8d8449..81ba572c33c1a 100644
--- a/extensions/libebt_stp.c
+++ b/extensions/libebt_stp.c
@@ -150,54 +150,6 @@ static void print_range(unsigned int l, unsigned int u)
 		printf("%u:%u ", l, u);
 }
 
-static int brstp_get_mac_and_mask(const char *from, unsigned char *to, unsigned char *mask)
-{
-	char *p;
-	int i;
-	struct ether_addr *addr = NULL;
-
-	static const unsigned char mac_type_unicast[ETH_ALEN];
-	static const unsigned char msk_type_unicast[ETH_ALEN] =   {1,0,0,0,0,0};
-	static const unsigned char mac_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
-	static const unsigned char mac_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
-	static const unsigned char mac_type_bridge_group[ETH_ALEN] = {0x01,0x80,0xc2,0,0,0};
-	static const unsigned char msk_type_bridge_group[ETH_ALEN] = {255,255,255,255,255,255};
-
-	if (strcasecmp(from, "Unicast") == 0) {
-		memcpy(to, mac_type_unicast, ETH_ALEN);
-		memcpy(mask, msk_type_unicast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "Multicast") == 0) {
-		memcpy(to, mac_type_multicast, ETH_ALEN);
-		memcpy(mask, mac_type_multicast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "Broadcast") == 0) {
-		memcpy(to, mac_type_broadcast, ETH_ALEN);
-		memcpy(mask, mac_type_broadcast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "BGA") == 0) {
-		memcpy(to, mac_type_bridge_group, ETH_ALEN);
-		memcpy(mask, msk_type_bridge_group, ETH_ALEN);
-		return 0;
-	}
-	if ( (p = strrchr(from, '/')) != NULL) {
-		*p = '\0';
-		if (!(addr = ether_aton(p + 1)))
-			return -1;
-		memcpy(mask, addr, ETH_ALEN);
-	} else
-		memset(mask, 0xff, ETH_ALEN);
-	if (!(addr = ether_aton(from)))
-		return -1;
-	memcpy(to, addr, ETH_ALEN);
-	for (i = 0; i < ETH_ALEN; i++)
-		to[i] &= mask[i];
-	return 0;
-}
-
 static int
 brstp_parse(int c, char **argv, int invert, unsigned int *flags,
 	    const void *entry, struct xt_entry_match **match)
@@ -280,15 +232,15 @@ brstp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM, "Bad --stp-forward-delay range");
 		break;
 	case EBT_STP_ROOTADDR:
-		if (brstp_get_mac_and_mask(argv[optind-1],
-		    (unsigned char *)stpinfo->config.root_addr,
-		    (unsigned char *)stpinfo->config.root_addrmsk))
+		if (xtables_parse_mac_and_mask(argv[optind-1],
+					       stpinfo->config.root_addr,
+					       stpinfo->config.root_addrmsk))
 			xtables_error(PARAMETER_PROBLEM, "Bad --stp-root-addr address");
 		break;
 	case EBT_STP_SENDERADDR:
-		if (brstp_get_mac_and_mask(argv[optind-1],
-		    (unsigned char *)stpinfo->config.sender_addr,
-		    (unsigned char *)stpinfo->config.sender_addrmsk))
+		if (xtables_parse_mac_and_mask(argv[optind-1],
+					       stpinfo->config.sender_addr,
+					       stpinfo->config.sender_addrmsk))
 			xtables_error(PARAMETER_PROBLEM, "Bad --stp-sender-addr address");
 		break;
 	default:
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index b6d717bcf86f0..b90eef207c98e 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -37,15 +37,6 @@ static void mac_parse(struct xt_option_call *cb)
 		macinfo->invert = 1;
 }
 
-static void print_mac(const unsigned char *macaddress)
-{
-	unsigned int i;
-
-	printf(" %02X", macaddress[0]);
-	for (i = 1; i < ETH_ALEN; ++i)
-		printf(":%02X", macaddress[i]);
-}
-
 static void
 mac_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
@@ -56,7 +47,7 @@ mac_print(const void *ip, const struct xt_entry_match *match, int numeric)
 	if (info->invert)
 		printf(" !");
 
-	print_mac(info->srcaddr);
+	xtables_print_mac(info->srcaddr);
 }
 
 static void mac_save(const void *ip, const struct xt_entry_match *match)
@@ -66,8 +57,8 @@ static void mac_save(const void *ip, const struct xt_entry_match *match)
 	if (info->invert)
 		printf(" !");
 
-	printf(" --mac-source");
-	print_mac(info->srcaddr);
+	printf(" --mac-source ");
+	xtables_print_mac(info->srcaddr);
 }
 
 static void print_mac_xlate(const unsigned char *macaddress,
diff --git a/include/xtables.h b/include/xtables.h
index 5044dd08e86d3..df1eaee326643 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -557,6 +557,9 @@ extern void xtables_save_string(const char *value);
 #define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
 
 extern void xtables_print_num(uint64_t number, unsigned int format);
+extern int xtables_parse_mac_and_mask(const char *from, void *to, void *mask);
+extern int xtables_print_well_known_mac_and_mask(const void *mac,
+						 const void *mask);
 extern void xtables_print_mac(const unsigned char *macaddress);
 extern void xtables_print_mac_and_mask(const unsigned char *mac,
 				       const unsigned char *mask);
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index c1a2c209cc1aa..d98fd527d9549 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -58,44 +58,11 @@ void ebt_cs_clean(struct iptables_command_state *cs)
 	}
 }
 
-static void ebt_print_mac(const unsigned char *mac)
-{
-	int j;
-
-	for (j = 0; j < ETH_ALEN; j++)
-		printf("%02x%s", mac[j], (j==ETH_ALEN-1) ? "" : ":");
-}
-
-static bool mac_all_ones(const unsigned char *mac)
-{
-	static const char hlpmsk[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-
-	return memcmp(mac, hlpmsk, sizeof(hlpmsk)) == 0;
-}
-
 /* Put the mac address into 6 (ETH_ALEN) bytes returns 0 on success. */
 static void ebt_print_mac_and_mask(const unsigned char *mac, const unsigned char *mask)
 {
-
-	if (!memcmp(mac, eb_mac_type_unicast, 6) &&
-	    !memcmp(mask, eb_msk_type_unicast, 6))
-		printf("Unicast");
-	else if (!memcmp(mac, eb_mac_type_multicast, 6) &&
-	         !memcmp(mask, eb_msk_type_multicast, 6))
-		printf("Multicast");
-	else if (!memcmp(mac, eb_mac_type_broadcast, 6) &&
-	         !memcmp(mask, eb_msk_type_broadcast, 6))
-		printf("Broadcast");
-	else if (!memcmp(mac, eb_mac_type_bridge_group, 6) &&
-	         !memcmp(mask, eb_msk_type_bridge_group, 6))
-		printf("BGA");
-	else {
-		ebt_print_mac(mac);
-		if (!mac_all_ones(mask)) {
-			printf("/");
-			ebt_print_mac(mask);
-		}
-	}
+	if (xtables_print_well_known_mac_and_mask(mac, mask))
+		xtables_print_mac_and_mask(mac, mask);
 }
 
 static void add_logical_iniface(struct nftnl_rule *r, char *iface, uint32_t op)
diff --git a/iptables/tests/shell/testcases/ipt-save/dumps/ipt-save-filter.txt b/iptables/tests/shell/testcases/ipt-save/dumps/ipt-save-filter.txt
index bfb6bdda57faf..6e42de78433ec 100644
--- a/iptables/tests/shell/testcases/ipt-save/dumps/ipt-save-filter.txt
+++ b/iptables/tests/shell/testcases/ipt-save/dumps/ipt-save-filter.txt
@@ -40,8 +40,8 @@
 -A OUTPUT -s 127.0.0.1/32 -d 127.0.0.1/32 -o lo -j ACCEPT
 -A OUTPUT -o wlan0 -j wlanout
 -A OUTPUT -j block
--A WLAN -s 192.168.200.4/32 -m mac --mac-source 00:00:F1:05:A0:E0 -j RETURN
--A WLAN -s 192.168.200.9/32 -m mac --mac-source 00:00:F1:05:99:85 -j RETURN
+-A WLAN -s 192.168.200.4/32 -m mac --mac-source 00:00:f1:05:a0:e0 -j RETURN
+-A WLAN -s 192.168.200.9/32 -m mac --mac-source 00:00:f1:05:99:85 -j RETURN
 -A WLAN -m limit --limit 12/min -j LOG --log-prefix "UNKNOWN WLAN dropped:"
 -A WLAN -j DROP
 -A accept_log -i ppp0 -p tcp -m tcp --tcp-flags SYN,RST,ACK SYN -m limit --limit 1/sec -j LOG --log-prefix "TCPConnect on ppp0:"
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 8632774dfb705..e56bbb4dd0363 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -135,52 +135,6 @@ static int inverse_for_options[] =
 /* ARPTABLES SPECIFIC NEW FUNCTIONS ADDED HERE */
 /***********************************************/
 
-static unsigned char mac_type_unicast[ETH_ALEN] =   {0,0,0,0,0,0};
-static unsigned char msk_type_unicast[ETH_ALEN] =   {1,0,0,0,0,0};
-static unsigned char mac_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
-static unsigned char msk_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
-static unsigned char mac_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
-static unsigned char msk_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
-
-/*
- * put the mac address into 6 (ETH_ALEN) bytes
- */
-static int getmac_and_mask(char *from, char *to, char *mask)
-{
-	char *p;
-	int i;
-	struct ether_addr *addr;
-
-	if (strcasecmp(from, "Unicast") == 0) {
-		memcpy(to, mac_type_unicast, ETH_ALEN);
-		memcpy(mask, msk_type_unicast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "Multicast") == 0) {
-		memcpy(to, mac_type_multicast, ETH_ALEN);
-		memcpy(mask, msk_type_multicast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "Broadcast") == 0) {
-		memcpy(to, mac_type_broadcast, ETH_ALEN);
-		memcpy(mask, msk_type_broadcast, ETH_ALEN);
-		return 0;
-	}
-	if ( (p = strrchr(from, '/')) != NULL) {
-		*p = '\0';
-		if (!(addr = ether_aton(p + 1)))
-			return -1;
-		memcpy(mask, addr, ETH_ALEN);
-	} else
-		memset(mask, 0xff, ETH_ALEN);
-	if (!(addr = ether_aton(from)))
-		return -1;
-	memcpy(to, addr, ETH_ALEN);
-	for (i = 0; i < ETH_ALEN; i++)
-		to[i] &= mask[i];
-	return 0;
-}
-
 static int getlength_and_mask(char *from, uint8_t *to, uint8_t *mask)
 {
 	char *p, *buffer;
@@ -686,7 +640,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_S_MAC, &cs.arp.arp.invflags,
 				   invert);
-			if (getmac_and_mask(argv[optind - 1],
+			if (xtables_parse_mac_and_mask(argv[optind - 1],
 			    cs.arp.arp.src_devaddr.addr, cs.arp.arp.src_devaddr.mask))
 				xtables_error(PARAMETER_PROBLEM, "Problem with specified "
 						"source mac");
@@ -697,7 +651,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			set_option(&options, OPT_D_MAC, &cs.arp.arp.invflags,
 				   invert);
 
-			if (getmac_and_mask(argv[optind - 1],
+			if (xtables_parse_mac_and_mask(argv[optind - 1],
 			    cs.arp.arp.tgt_devaddr.addr, cs.arp.arp.tgt_devaddr.mask))
 				xtables_error(PARAMETER_PROBLEM, "Problem with specified "
 						"destination mac");
diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index 96b2730fa97ed..83ae77cb07fb2 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -397,7 +397,9 @@ print_zero:
 				if (ebt_check_inverse2(optarg, argc, argv))
 					cs.eb.invflags |= EBT_ISOURCE;
 
-				if (ebt_get_mac_and_mask(optarg, cs.eb.sourcemac, cs.eb.sourcemsk))
+				if (xtables_parse_mac_and_mask(optarg,
+							       cs.eb.sourcemac,
+							       cs.eb.sourcemsk))
 					xtables_error(PARAMETER_PROBLEM, "Problem with specified source mac '%s'", optarg);
 				cs.eb.bitmask |= EBT_SOURCEMAC;
 				break;
@@ -406,7 +408,9 @@ print_zero:
 				if (ebt_check_inverse2(optarg, argc, argv))
 					cs.eb.invflags |= EBT_IDEST;
 
-				if (ebt_get_mac_and_mask(optarg, cs.eb.destmac, cs.eb.destmsk))
+				if (xtables_parse_mac_and_mask(optarg,
+							       cs.eb.destmac,
+							       cs.eb.destmsk))
 					xtables_error(PARAMETER_PROBLEM, "Problem with specified destination mac '%s'", optarg);
 				cs.eb.bitmask |= EBT_DESTMAC;
 				break;
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 6641a21a72d32..b379c0e5119f1 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -55,57 +55,6 @@
  * 1: the inverse '!' of the option has already been specified */
 int ebt_invert = 0;
 
-unsigned char eb_mac_type_unicast[ETH_ALEN] =   {0,0,0,0,0,0};
-unsigned char eb_msk_type_unicast[ETH_ALEN] =   {1,0,0,0,0,0};
-unsigned char eb_mac_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
-unsigned char eb_msk_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
-unsigned char eb_mac_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
-unsigned char eb_msk_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
-unsigned char eb_mac_type_bridge_group[ETH_ALEN] = {0x01,0x80,0xc2,0,0,0};
-unsigned char eb_msk_type_bridge_group[ETH_ALEN] = {255,255,255,255,255,255};
-
-int ebt_get_mac_and_mask(const char *from, unsigned char *to,
-  unsigned char *mask)
-{
-	char *p;
-	int i;
-	struct ether_addr *addr = NULL;
-
-	if (strcasecmp(from, "Unicast") == 0) {
-		memcpy(to, eb_mac_type_unicast, ETH_ALEN);
-		memcpy(mask, eb_msk_type_unicast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "Multicast") == 0) {
-		memcpy(to, eb_mac_type_multicast, ETH_ALEN);
-		memcpy(mask, eb_msk_type_multicast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "Broadcast") == 0) {
-		memcpy(to, eb_mac_type_broadcast, ETH_ALEN);
-		memcpy(mask, eb_msk_type_broadcast, ETH_ALEN);
-		return 0;
-	}
-	if (strcasecmp(from, "BGA") == 0) {
-		memcpy(to, eb_mac_type_bridge_group, ETH_ALEN);
-		memcpy(mask, eb_msk_type_bridge_group, ETH_ALEN);
-		return 0;
-	}
-	if ( (p = strrchr(from, '/')) != NULL) {
-		*p = '\0';
-		if (!(addr = ether_aton(p + 1)))
-			return -1;
-		memcpy(mask, addr, ETH_ALEN);
-	} else
-		memset(mask, 0xff, ETH_ALEN);
-	if (!(addr = ether_aton(from)))
-		return -1;
-	memcpy(to, addr, ETH_ALEN);
-	for (i = 0; i < ETH_ALEN; i++)
-		to[i] &= mask[i];
-	return 0;
-}
-
 static int ebt_check_inverse2(const char option[], int argc, char **argv)
 {
 	if (!option)
@@ -1037,7 +986,9 @@ print_zero:
 				if (ebt_check_inverse2(optarg, argc, argv))
 					cs.eb.invflags |= EBT_ISOURCE;
 
-				if (ebt_get_mac_and_mask(optarg, cs.eb.sourcemac, cs.eb.sourcemsk))
+				if (xtables_parse_mac_and_mask(optarg,
+							       cs.eb.sourcemac,
+							       cs.eb.sourcemsk))
 					xtables_error(PARAMETER_PROBLEM, "Problem with specified source mac '%s'", optarg);
 				cs.eb.bitmask |= EBT_SOURCEMAC;
 				break;
@@ -1046,7 +997,9 @@ print_zero:
 				if (ebt_check_inverse2(optarg, argc, argv))
 					cs.eb.invflags |= EBT_IDEST;
 
-				if (ebt_get_mac_and_mask(optarg, cs.eb.destmac, cs.eb.destmsk))
+				if (xtables_parse_mac_and_mask(optarg,
+							       cs.eb.destmac,
+							       cs.eb.destmsk))
 					xtables_error(PARAMETER_PROBLEM, "Problem with specified destination mac '%s'", optarg);
 				cs.eb.bitmask |= EBT_DESTMAC;
 				break;
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 7152c6576cd63..bc42ba8221f3a 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -2137,6 +2137,79 @@ void xtables_print_num(uint64_t number, unsigned int format)
 	printf(FMT("%4lluT ","%lluT "), (unsigned long long)number);
 }
 
+#include <netinet/ether.h>
+
+static const unsigned char mac_type_unicast[ETH_ALEN] =   {};
+static const unsigned char msk_type_unicast[ETH_ALEN] =   {1};
+static const unsigned char mac_type_multicast[ETH_ALEN] = {1};
+static const unsigned char msk_type_multicast[ETH_ALEN] = {1};
+#define ALL_ONE_MAC {0xff, 0xff, 0xff, 0xff, 0xff, 0xff}
+static const unsigned char mac_type_broadcast[ETH_ALEN] = ALL_ONE_MAC;
+static const unsigned char msk_type_broadcast[ETH_ALEN] = ALL_ONE_MAC;
+static const unsigned char mac_type_bridge_group[ETH_ALEN] = {0x01, 0x80, 0xc2};
+static const unsigned char msk_type_bridge_group[ETH_ALEN] = ALL_ONE_MAC;
+#undef ALL_ONE_MAC
+
+int xtables_parse_mac_and_mask(const char *from, void *to, void *mask)
+{
+	char *p;
+	int i;
+	struct ether_addr *addr = NULL;
+
+	if (strcasecmp(from, "Unicast") == 0) {
+		memcpy(to, mac_type_unicast, ETH_ALEN);
+		memcpy(mask, msk_type_unicast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "Multicast") == 0) {
+		memcpy(to, mac_type_multicast, ETH_ALEN);
+		memcpy(mask, msk_type_multicast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "Broadcast") == 0) {
+		memcpy(to, mac_type_broadcast, ETH_ALEN);
+		memcpy(mask, msk_type_broadcast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "BGA") == 0) {
+		memcpy(to, mac_type_bridge_group, ETH_ALEN);
+		memcpy(mask, msk_type_bridge_group, ETH_ALEN);
+		return 0;
+	}
+	if ( (p = strrchr(from, '/')) != NULL) {
+		*p = '\0';
+		if (!(addr = ether_aton(p + 1)))
+			return -1;
+		memcpy(mask, addr, ETH_ALEN);
+	} else
+		memset(mask, 0xff, ETH_ALEN);
+	if (!(addr = ether_aton(from)))
+		return -1;
+	memcpy(to, addr, ETH_ALEN);
+	for (i = 0; i < ETH_ALEN; i++)
+		((char *)to)[i] &= ((char *)mask)[i];
+	return 0;
+}
+
+int xtables_print_well_known_mac_and_mask(const void *mac, const void *mask)
+{
+	if (!memcmp(mac, mac_type_unicast, ETH_ALEN) &&
+	    !memcmp(mask, msk_type_unicast, ETH_ALEN))
+		printf("Unicast");
+	else if (!memcmp(mac, mac_type_multicast, ETH_ALEN) &&
+	         !memcmp(mask, msk_type_multicast, ETH_ALEN))
+		printf("Multicast");
+	else if (!memcmp(mac, mac_type_broadcast, ETH_ALEN) &&
+	         !memcmp(mask, msk_type_broadcast, ETH_ALEN))
+		printf("Broadcast");
+	else if (!memcmp(mac, mac_type_bridge_group, ETH_ALEN) &&
+	         !memcmp(mask, msk_type_bridge_group, ETH_ALEN))
+		printf("BGA");
+	else
+		return -1;
+	return 0;
+}
+
 void xtables_print_mac(const unsigned char *macaddress)
 {
 	unsigned int i;
-- 
2.28.0

