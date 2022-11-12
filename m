Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF017C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbiKLAVJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKLAVI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:21:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26360DF22
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pZG4fINHGuAd8E2VWv2cIF+UbsrbHRa+KOvgweON7gg=; b=kQOpL3LWAiB7ZnHh9zwBcw+YdW
        AtTudaU2EX/qqLqj7yt4nf81hL16nGbw/reXDVi9Q4GJypCO/7GtYiupv/fq2zQfyZu2b6aNHOlxo
        pH5jSxoQIrA75hp82Oe+z7yqW38ZS2XKDM9GnptoN0rCQuneOvQKQb6HJ5B/S+CsPMH/LRLcpVv2P
        pFVJOFzkrpboF/SIQFrK31x/Pijkc8QUg6lf1IDyPELj5al1MB+BW1eMyhQ4ifkip6niauceY6zTn
        3JrOdlujZBNEpXZ8B/twvzYyvr7iIHbh3NVF+eZ1XYiBppcRZEREdsMamfKzJJ5y3ScLcoMCurjGo
        2C1s9L6w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oteGf-00022H-6H
        for netfilter-devel@vger.kernel.org; Sat, 12 Nov 2022 01:21:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 6/7] extensions: Collate ICMP types/codes in libxt_icmp.h
Date:   Sat, 12 Nov 2022 01:20:55 +0100
Message-Id: <20221112002056.31917-7-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221112002056.31917-1-phil@nwl.cc>
References: <20221112002056.31917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Put the most extensive version of icmp_codes, icmpv6_codes and
igmp_codes into the header. Have to rename the function
xt_print_icmp_types's parameter to avoid a compiler warning.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip.c     |  62 --------------------
 extensions/libebt_ip6.c    |  38 ------------
 extensions/libip6t_icmp6.c |  42 --------------
 extensions/libipt_icmp.c   |  55 ------------------
 extensions/libxt_icmp.h    | 116 ++++++++++++++++++++++++++++++++++---
 5 files changed, 107 insertions(+), 206 deletions(-)

diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index d13e83c06895d..27ae84e9470d8 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -50,68 +50,6 @@ static const struct option brip_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static const struct xt_icmp_names icmp_codes[] = {
-	{ "echo-reply", 0, 0, 0xFF },
-	/* Alias */ { "pong", 0, 0, 0xFF },
-
-	{ "destination-unreachable", 3, 0, 0xFF },
-	{   "network-unreachable", 3, 0, 0 },
-	{   "host-unreachable", 3, 1, 1 },
-	{   "protocol-unreachable", 3, 2, 2 },
-	{   "port-unreachable", 3, 3, 3 },
-	{   "fragmentation-needed", 3, 4, 4 },
-	{   "source-route-failed", 3, 5, 5 },
-	{   "network-unknown", 3, 6, 6 },
-	{   "host-unknown", 3, 7, 7 },
-	{   "network-prohibited", 3, 9, 9 },
-	{   "host-prohibited", 3, 10, 10 },
-	{   "TOS-network-unreachable", 3, 11, 11 },
-	{   "TOS-host-unreachable", 3, 12, 12 },
-	{   "communication-prohibited", 3, 13, 13 },
-	{   "host-precedence-violation", 3, 14, 14 },
-	{   "precedence-cutoff", 3, 15, 15 },
-
-	{ "source-quench", 4, 0, 0xFF },
-
-	{ "redirect", 5, 0, 0xFF },
-	{   "network-redirect", 5, 0, 0 },
-	{   "host-redirect", 5, 1, 1 },
-	{   "TOS-network-redirect", 5, 2, 2 },
-	{   "TOS-host-redirect", 5, 3, 3 },
-
-	{ "echo-request", 8, 0, 0xFF },
-	/* Alias */ { "ping", 8, 0, 0xFF },
-
-	{ "router-advertisement", 9, 0, 0xFF },
-
-	{ "router-solicitation", 10, 0, 0xFF },
-
-	{ "time-exceeded", 11, 0, 0xFF },
-	/* Alias */ { "ttl-exceeded", 11, 0, 0xFF },
-	{   "ttl-zero-during-transit", 11, 0, 0 },
-	{   "ttl-zero-during-reassembly", 11, 1, 1 },
-
-	{ "parameter-problem", 12, 0, 0xFF },
-	{   "ip-header-bad", 12, 0, 0 },
-	{   "required-option-missing", 12, 1, 1 },
-
-	{ "timestamp-request", 13, 0, 0xFF },
-
-	{ "timestamp-reply", 14, 0, 0xFF },
-
-	{ "address-mask-request", 17, 0, 0xFF },
-
-	{ "address-mask-reply", 18, 0, 0xFF }
-};
-
-static const struct xt_icmp_names igmp_types[] = {
-	{ "membership-query", 0x11 },
-	{ "membership-report-v1", 0x12 },
-	{ "membership-report-v2", 0x16 },
-	{ "leave-group", 0x17 },
-	{ "membership-report-v3", 0x22 },
-};
-
 static void brip_print_help(void)
 {
 	printf(
diff --git a/extensions/libebt_ip6.c b/extensions/libebt_ip6.c
index a686a285c3cb8..ac20666af5ba3 100644
--- a/extensions/libebt_ip6.c
+++ b/extensions/libebt_ip6.c
@@ -49,44 +49,6 @@ static const struct option brip6_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static const struct xt_icmp_names icmpv6_codes[] = {
-	{ "destination-unreachable", 1, 0, 0xFF },
-	{ "no-route", 1, 0, 0 },
-	{ "communication-prohibited", 1, 1, 1 },
-	{ "address-unreachable", 1, 3, 3 },
-	{ "port-unreachable", 1, 4, 4 },
-
-	{ "packet-too-big", 2, 0, 0xFF },
-
-	{ "time-exceeded", 3, 0, 0xFF },
-	/* Alias */ { "ttl-exceeded", 3, 0, 0xFF },
-	{ "ttl-zero-during-transit", 3, 0, 0 },
-	{ "ttl-zero-during-reassembly", 3, 1, 1 },
-
-	{ "parameter-problem", 4, 0, 0xFF },
-	{ "bad-header", 4, 0, 0 },
-	{ "unknown-header-type", 4, 1, 1 },
-	{ "unknown-option", 4, 2, 2 },
-
-	{ "echo-request", 128, 0, 0xFF },
-	/* Alias */ { "ping", 128, 0, 0xFF },
-
-	{ "echo-reply", 129, 0, 0xFF },
-	/* Alias */ { "pong", 129, 0, 0xFF },
-
-	{ "router-solicitation", 133, 0, 0xFF },
-
-	{ "router-advertisement", 134, 0, 0xFF },
-
-	{ "neighbour-solicitation", 135, 0, 0xFF },
-	/* Alias */ { "neighbor-solicitation", 135, 0, 0xFF },
-
-	{ "neighbour-advertisement", 136, 0, 0xFF },
-	/* Alias */ { "neighbor-advertisement", 136, 0, 0xFF },
-
-	{ "redirect", 137, 0, 0xFF },
-};
-
 static void
 parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
 {
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index cc7bfaeb72fd7..44f7109528166 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -12,48 +12,6 @@ enum {
 	O_ICMPV6_TYPE = 0,
 };
 
-static const struct xt_icmp_names icmpv6_codes[] = {
-	{ "destination-unreachable", 1, 0, 0xFF },
-	{   "no-route", 1, 0, 0 },
-	{   "communication-prohibited", 1, 1, 1 },
-	{   "beyond-scope", 1, 2, 2 },
-	{   "address-unreachable", 1, 3, 3 },
-	{   "port-unreachable", 1, 4, 4 },
-	{   "failed-policy", 1, 5, 5 },
-	{   "reject-route", 1, 6, 6 },
-
-	{ "packet-too-big", 2, 0, 0xFF },
-
-	{ "time-exceeded", 3, 0, 0xFF },
-	/* Alias */ { "ttl-exceeded", 3, 0, 0xFF },
-	{   "ttl-zero-during-transit", 3, 0, 0 },
-	{   "ttl-zero-during-reassembly", 3, 1, 1 },
-
-	{ "parameter-problem", 4, 0, 0xFF },
-	{   "bad-header", 4, 0, 0 },
-	{   "unknown-header-type", 4, 1, 1 },
-	{   "unknown-option", 4, 2, 2 },
-
-	{ "echo-request", 128, 0, 0xFF },
-	/* Alias */ { "ping", 128, 0, 0xFF },
-
-	{ "echo-reply", 129, 0, 0xFF },
-	/* Alias */ { "pong", 129, 0, 0xFF },
-
-	{ "router-solicitation", 133, 0, 0xFF },
-
-	{ "router-advertisement", 134, 0, 0xFF },
-
-	{ "neighbour-solicitation", 135, 0, 0xFF },
-	/* Alias */ { "neighbor-solicitation", 135, 0, 0xFF },
-
-	{ "neighbour-advertisement", 136, 0, 0xFF },
-	/* Alias */ { "neighbor-advertisement", 136, 0, 0xFF },
-
-	{ "redirect", 137, 0, 0xFF },
-
-};
-
 static void icmp6_help(void)
 {
 	printf(
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index e5e236613f39f..f0e838874286b 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -19,61 +19,6 @@ enum {
 	O_ICMP_TYPE = 0,
 };
 
-static const struct xt_icmp_names icmp_codes[] = {
-	{ "any", 0xFF, 0, 0xFF },
-	{ "echo-reply", 0, 0, 0xFF },
-	/* Alias */ { "pong", 0, 0, 0xFF },
-
-	{ "destination-unreachable", 3, 0, 0xFF },
-	{   "network-unreachable", 3, 0, 0 },
-	{   "host-unreachable", 3, 1, 1 },
-	{   "protocol-unreachable", 3, 2, 2 },
-	{   "port-unreachable", 3, 3, 3 },
-	{   "fragmentation-needed", 3, 4, 4 },
-	{   "source-route-failed", 3, 5, 5 },
-	{   "network-unknown", 3, 6, 6 },
-	{   "host-unknown", 3, 7, 7 },
-	{   "network-prohibited", 3, 9, 9 },
-	{   "host-prohibited", 3, 10, 10 },
-	{   "TOS-network-unreachable", 3, 11, 11 },
-	{   "TOS-host-unreachable", 3, 12, 12 },
-	{   "communication-prohibited", 3, 13, 13 },
-	{   "host-precedence-violation", 3, 14, 14 },
-	{   "precedence-cutoff", 3, 15, 15 },
-
-	{ "source-quench", 4, 0, 0xFF },
-
-	{ "redirect", 5, 0, 0xFF },
-	{   "network-redirect", 5, 0, 0 },
-	{   "host-redirect", 5, 1, 1 },
-	{   "TOS-network-redirect", 5, 2, 2 },
-	{   "TOS-host-redirect", 5, 3, 3 },
-
-	{ "echo-request", 8, 0, 0xFF },
-	/* Alias */ { "ping", 8, 0, 0xFF },
-
-	{ "router-advertisement", 9, 0, 0xFF },
-
-	{ "router-solicitation", 10, 0, 0xFF },
-
-	{ "time-exceeded", 11, 0, 0xFF },
-	/* Alias */ { "ttl-exceeded", 11, 0, 0xFF },
-	{   "ttl-zero-during-transit", 11, 0, 0 },
-	{   "ttl-zero-during-reassembly", 11, 1, 1 },
-
-	{ "parameter-problem", 12, 0, 0xFF },
-	{   "ip-header-bad", 12, 0, 0 },
-	{   "required-option-missing", 12, 1, 1 },
-
-	{ "timestamp-request", 13, 0, 0xFF },
-
-	{ "timestamp-reply", 14, 0, 0xFF },
-
-	{ "address-mask-request", 17, 0, 0xFF },
-
-	{ "address-mask-reply", 18, 0, 0xFF }
-};
-
 static void icmp_help(void)
 {
 	printf(
diff --git a/extensions/libxt_icmp.h b/extensions/libxt_icmp.h
index 5820206ef469e..d6d9f9b6ffc98 100644
--- a/extensions/libxt_icmp.h
+++ b/extensions/libxt_icmp.h
@@ -1,25 +1,123 @@
-struct xt_icmp_names {
+static const struct xt_icmp_names {
 	const char *name;
 	uint8_t type;
 	uint8_t code_min, code_max;
+} icmp_codes[] = {
+	{ "any", 0xFF, 0, 0xFF },
+	{ "echo-reply", 0, 0, 0xFF },
+	/* Alias */ { "pong", 0, 0, 0xFF },
+
+	{ "destination-unreachable", 3, 0, 0xFF },
+	{   "network-unreachable", 3, 0, 0 },
+	{   "host-unreachable", 3, 1, 1 },
+	{   "protocol-unreachable", 3, 2, 2 },
+	{   "port-unreachable", 3, 3, 3 },
+	{   "fragmentation-needed", 3, 4, 4 },
+	{   "source-route-failed", 3, 5, 5 },
+	{   "network-unknown", 3, 6, 6 },
+	{   "host-unknown", 3, 7, 7 },
+	{   "network-prohibited", 3, 9, 9 },
+	{   "host-prohibited", 3, 10, 10 },
+	{   "TOS-network-unreachable", 3, 11, 11 },
+	{   "TOS-host-unreachable", 3, 12, 12 },
+	{   "communication-prohibited", 3, 13, 13 },
+	{   "host-precedence-violation", 3, 14, 14 },
+	{   "precedence-cutoff", 3, 15, 15 },
+
+	{ "source-quench", 4, 0, 0xFF },
+
+	{ "redirect", 5, 0, 0xFF },
+	{   "network-redirect", 5, 0, 0 },
+	{   "host-redirect", 5, 1, 1 },
+	{   "TOS-network-redirect", 5, 2, 2 },
+	{   "TOS-host-redirect", 5, 3, 3 },
+
+	{ "echo-request", 8, 0, 0xFF },
+	/* Alias */ { "ping", 8, 0, 0xFF },
+
+	{ "router-advertisement", 9, 0, 0xFF },
+
+	{ "router-solicitation", 10, 0, 0xFF },
+
+	{ "time-exceeded", 11, 0, 0xFF },
+	/* Alias */ { "ttl-exceeded", 11, 0, 0xFF },
+	{   "ttl-zero-during-transit", 11, 0, 0 },
+	{   "ttl-zero-during-reassembly", 11, 1, 1 },
+
+	{ "parameter-problem", 12, 0, 0xFF },
+	{   "ip-header-bad", 12, 0, 0 },
+	{   "required-option-missing", 12, 1, 1 },
+
+	{ "timestamp-request", 13, 0, 0xFF },
+
+	{ "timestamp-reply", 14, 0, 0xFF },
+
+	{ "address-mask-request", 17, 0, 0xFF },
+
+	{ "address-mask-reply", 18, 0, 0xFF }
+}, icmpv6_codes[] = {
+	{ "destination-unreachable", 1, 0, 0xFF },
+	{   "no-route", 1, 0, 0 },
+	{   "communication-prohibited", 1, 1, 1 },
+	{   "beyond-scope", 1, 2, 2 },
+	{   "address-unreachable", 1, 3, 3 },
+	{   "port-unreachable", 1, 4, 4 },
+	{   "failed-policy", 1, 5, 5 },
+	{   "reject-route", 1, 6, 6 },
+
+	{ "packet-too-big", 2, 0, 0xFF },
+
+	{ "time-exceeded", 3, 0, 0xFF },
+	/* Alias */ { "ttl-exceeded", 3, 0, 0xFF },
+	{   "ttl-zero-during-transit", 3, 0, 0 },
+	{   "ttl-zero-during-reassembly", 3, 1, 1 },
+
+	{ "parameter-problem", 4, 0, 0xFF },
+	{   "bad-header", 4, 0, 0 },
+	{   "unknown-header-type", 4, 1, 1 },
+	{   "unknown-option", 4, 2, 2 },
+
+	{ "echo-request", 128, 0, 0xFF },
+	/* Alias */ { "ping", 128, 0, 0xFF },
+
+	{ "echo-reply", 129, 0, 0xFF },
+	/* Alias */ { "pong", 129, 0, 0xFF },
+
+	{ "router-solicitation", 133, 0, 0xFF },
+
+	{ "router-advertisement", 134, 0, 0xFF },
+
+	{ "neighbour-solicitation", 135, 0, 0xFF },
+	/* Alias */ { "neighbor-solicitation", 135, 0, 0xFF },
+
+	{ "neighbour-advertisement", 136, 0, 0xFF },
+	/* Alias */ { "neighbor-advertisement", 136, 0, 0xFF },
+
+	{ "redirect", 137, 0, 0xFF },
+}, igmp_types[] = {
+	{ "membership-query", 0x11 },
+	{ "membership-report-v1", 0x12 },
+	{ "membership-report-v2", 0x16 },
+	{ "leave-group", 0x17 },
+	{ "membership-report-v3", 0x22 },
 };
 
-static void xt_print_icmp_types(const struct xt_icmp_names *icmp_codes,
+static void xt_print_icmp_types(const struct xt_icmp_names *_icmp_codes,
 				unsigned int n_codes)
 {
 	unsigned int i;
 
 	for (i = 0; i < n_codes; ++i) {
-		if (i && icmp_codes[i].type == icmp_codes[i-1].type) {
-			if (icmp_codes[i].code_min == icmp_codes[i-1].code_min
-			    && (icmp_codes[i].code_max
-				== icmp_codes[i-1].code_max))
-				printf(" (%s)", icmp_codes[i].name);
+		if (i && _icmp_codes[i].type == _icmp_codes[i-1].type) {
+			if (_icmp_codes[i].code_min == _icmp_codes[i-1].code_min
+			    && (_icmp_codes[i].code_max
+				== _icmp_codes[i-1].code_max))
+				printf(" (%s)", _icmp_codes[i].name);
 			else
-				printf("\n   %s", icmp_codes[i].name);
+				printf("\n   %s", _icmp_codes[i].name);
 		}
 		else
-			printf("\n%s", icmp_codes[i].name);
+			printf("\n%s", _icmp_codes[i].name);
 	}
 	printf("\n");
 }
-- 
2.38.0

