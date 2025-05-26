Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7C420127B
	for <netfilter-devel@vger.kernel.org>; Mon, 26 May 2025 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748279994; cv=none; b=G3LbGcbrB2djZEJwz16YAOkE8SCOL930dDaURd8zrkmwBqM71c2BFzYtTK807IZmiPfrqDpBs8xfkfRHUkFQg6AIeq9FcJKZNDo2j4nsA+QrqM4xxH/dRYWGV+5Uw2jsZ6hnx8lGouRubDun4LLJF5UZtywFDeprt54qO6gbio0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748279994; c=relaxed/simple;
	bh=eITOckIy0XMGlbuGVdzNwRamju67jqsmyK3vCNQNAWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJh8gGY9iUAdobGFIZ5BNLF4Oty5fuPCiuW0mka6tQu1F34JqdeAYyVMm3bM6C+R/M0ZDcrWN7gZcQvy5/+hNAIN5xzcJ8lhPHAtpChzgjuSsSfY+D0qm8jy558Fxu6KuXCTUnj61ForyJvLCmBdJq3AVWlZBAAYUMJMaK0tdfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=NrXRCjU5; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="NrXRCjU5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UTlrKAHIsbzkqgNYf+4Ks9NXm/+4VrTUa+/jig3Q3pA=; b=NrXRCjU5z0gQY0JsGGycf6tn8l
	9pJziiD1XSm6i2m6cBM3Z94pDVOpkLjbyAf5V7NAn2tn7hNW0EVFzm0qvobpc+Bist0i9bNNWOsLq
	5wVCXC1eiOjA3udnZ57vMxQgQ7sMjFeASyAiwlpCTkTAXDHXx/S4Fq5rR/86t96+iwSeSS1hNbkNV
	guf4qgxjLyK4zw+jYy/6qfhkzaUoVXk7dw+2SypfyOM0Ho8zdX9crq9OfByQFWA6Oa/xJA1QlAreK
	DYUSuPEDkdQdblKSzgfIETbnCIopH5vNRisGv0Qu/m2Jqgr4VSNk8FsdAyou7+xPPN1C0znm+vXcJ
	R3LqgLyA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uJbUK-000rKJ-1X;
	Mon, 26 May 2025 18:19:48 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc: Slavko <linux@slavino.sk>
Subject: [PATCH ulogd2 v2 2/4] IP2BIN, IP2HBIN, IP2STR: refactor `interp` call-backs
Date: Mon, 26 May 2025 18:19:02 +0100
Message-ID: <20250526171904.1733009-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250526171904.1733009-1-jeremy@azazel.net>
References: <20250526171904.1733009-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

IP2STR and IP2BIN do all family checks inside the for-loop that converts the
address fields, whereas IP2HBIN does the checks once before the loop.  Refactor
the former to do as the latter.

Also, move all the remaining contents of the for-loops, apart from the
`pp_is_valid` checks, into `ip2*` functions.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_IP2BIN.c  | 86 +++++++++++++++++------------------
 filter/ulogd_filter_IP2HBIN.c | 52 +++++++++++----------
 filter/ulogd_filter_IP2STR.c  | 76 ++++++++++++++++---------------
 3 files changed, 110 insertions(+), 104 deletions(-)

diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index f1ca4eee7d76..2667a2a7f717 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -114,14 +114,42 @@ static struct ulogd_key ip2bin_keys[] = {
 
 static char ipbin_array[MAX_KEY - START_KEY + 1][FORMAT_IPV6_BUFSZ];
 
-static int ip2bin(struct ulogd_key *inp, int index, int oindex)
+static void ip2bin(struct ulogd_key *inp, int i, struct ulogd_key *outp, int o,
+		   uint8_t addr_family)
 {
-	char family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
-	char convfamily = family;
-	struct in6_addr *addr;
-	struct in6_addr ip4_addr;
+	struct in6_addr *addr, ip4_addr;
+
+	switch (addr_family) {
+	case AF_INET6:
+		addr = (struct in6_addr *)ikey_get_u128(&inp[i]);
+		break;
+	case AF_INET:
+		/* Convert IPv4 to IPv4 in IPv6 */
+		addr = &ip4_addr;
+		uint32_to_ipv6(ikey_get_u32(&inp[i]), addr);
+		break;
+	}
+
+	format_ipv6(ipbin_array[o], sizeof(ipbin_array[o]), addr);
+
+	okey_set_ptr(&outp[o], ipbin_array[o]);
+}
+
+static int interp_ip2bin(struct ulogd_pluginstance *pi)
+{
+	struct ulogd_key *outp = pi->output.keys;
+	struct ulogd_key *inp = pi->input.keys;
+	uint8_t proto_family, addr_family;
+	int i, o;
+
+	proto_family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
 
-	if (family == AF_BRIDGE) {
+	switch (proto_family) {
+	case AF_INET6:
+	case AF_INET:
+		addr_family = proto_family;
+		break;
+	case AF_BRIDGE:
 		if (!pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
 			ulogd_log(ULOGD_NOTICE,
 				  "No protocol inside AF_BRIDGE packet\n");
@@ -129,56 +157,28 @@ static int ip2bin(struct ulogd_key *inp, int index, int oindex)
 		}
 		switch (ikey_get_u16(&inp[KEY_OOB_PROTOCOL])) {
 		case ETH_P_IPV6:
-			convfamily = AF_INET6;
+			addr_family = AF_INET6;
 			break;
 		case ETH_P_IP:
-			convfamily = AF_INET;
-			break;
 		case ETH_P_ARP:
-			convfamily = AF_INET;
+			addr_family = AF_INET;
 			break;
 		default:
 			ulogd_log(ULOGD_NOTICE,
 				  "Unknown protocol inside AF_BRIDGE packet\n");
 			return ULOGD_IRET_ERR;
 		}
+		break;
+	default:
+		/* TODO handle error */
+		ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
+		return ULOGD_IRET_ERR;
 	}
 
-	switch (convfamily) {
-		case AF_INET6:
-			addr = (struct in6_addr *)ikey_get_u128(&inp[index]);
-			break;
-		case AF_INET:
-			/* Convert IPv4 to IPv4 in IPv6 */
-			addr = &ip4_addr;
-			uint32_to_ipv6(ikey_get_u32(&inp[index]), addr);
-			break;
-		default:
-			/* TODO handle error */
-			ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
-			return ULOGD_IRET_ERR;
-	}
-
-	format_ipv6(ipbin_array[oindex], sizeof(ipbin_array[oindex]), addr);
-
-	return ULOGD_IRET_OK;
-}
-
-static int interp_ip2bin(struct ulogd_pluginstance *pi)
-{
-	struct ulogd_key *ret = pi->output.keys;
-	struct ulogd_key *inp = pi->input.keys;
-	int i;
-	int fret;
-
 	/* Iter on all addr fields */
-	for(i = START_KEY; i <= MAX_KEY; i++) {
+	for (i = START_KEY, o = 0; i <= MAX_KEY; i++, o++) {
 		if (pp_is_valid(inp, i)) {
-			fret = ip2bin(inp, i, i - START_KEY);
-			if (fret != ULOGD_IRET_OK)
-				return fret;
-			okey_set_ptr(&ret[i - START_KEY],
-				     ipbin_array[i - START_KEY]);
+			ip2bin(inp, i, outp, o, addr_family);
 		}
 	}
 
diff --git a/filter/ulogd_filter_IP2HBIN.c b/filter/ulogd_filter_IP2HBIN.c
index 48ea6a2cbc14..42ffc9497584 100644
--- a/filter/ulogd_filter_IP2HBIN.c
+++ b/filter/ulogd_filter_IP2HBIN.c
@@ -112,17 +112,32 @@ static struct ulogd_key ip2hbin_keys[] = {
 	},
 };
 
+static void ip2hbin(struct ulogd_key *inp, int i, struct ulogd_key *outp, int o,
+		   uint8_t addr_family)
+{
+	switch (addr_family) {
+	case AF_INET6:
+		okey_set_u128(&outp[o], ikey_get_u128(&inp[i]));
+		break;
+	case AF_INET:
+		okey_set_u32(&outp[o], ntohl(ikey_get_u32(&inp[i])));
+		break;
+	}
+}
+
 static int interp_ip2hbin(struct ulogd_pluginstance *pi)
 {
-	struct ulogd_key *ret = pi->output.keys;
+	struct ulogd_key *outp = pi->output.keys;
 	struct ulogd_key *inp = pi->input.keys;
-	uint8_t family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
-	uint8_t convfamily = family;
-	int i;
+	uint8_t proto_family, addr_family;
+	int i, o;
 
-	switch (family) {
-	case AF_INET:
+	proto_family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
+
+	switch (proto_family) {
 	case AF_INET6:
+	case AF_INET:
+		addr_family = proto_family;
 		break;
 	case AF_BRIDGE:
 		if (!pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
@@ -132,13 +147,11 @@ static int interp_ip2hbin(struct ulogd_pluginstance *pi)
 		}
 		switch (ikey_get_u16(&inp[KEY_OOB_PROTOCOL])) {
 		case ETH_P_IPV6:
-			convfamily = AF_INET6;
+			addr_family = AF_INET6;
 			break;
 		case ETH_P_IP:
-			convfamily = AF_INET;
-			break;
 		case ETH_P_ARP:
-			convfamily = AF_INET;
+			addr_family = AF_INET;
 			break;
 		default:
 			ulogd_log(ULOGD_NOTICE,
@@ -147,26 +160,15 @@ static int interp_ip2hbin(struct ulogd_pluginstance *pi)
 		}
 		break;
 	default:
-		ulogd_log(ULOGD_NOTICE,
-			  "Unknown protocol inside packet\n");
+		/* TODO handle error */
+		ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
 		return ULOGD_IRET_ERR;
 	}
 
 	/* Iter on all addr fields */
-	for(i = START_KEY; i <= MAX_KEY; i++) {
+	for (i = START_KEY, o = 0; i <= MAX_KEY; i++, o++) {
 		if (pp_is_valid(inp, i)) {
-			switch (convfamily) {
-			case AF_INET:
-				okey_set_u32(&ret[i - START_KEY],
-					     ntohl(ikey_get_u32(&inp[i])));
-				break;
-			case AF_INET6:
-				okey_set_u128(&ret[i - START_KEY],
-					      ikey_get_u128(&inp[i]));
-				break;
-			default:
-				break;
-			}
+			ip2hbin(inp, i, outp, o, addr_family);
 		}
 	}
 
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index fec892a62dac..194a8b103272 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -137,12 +137,44 @@ static struct ulogd_key ip2str_keys[] = {
 
 static char ipstr_array[MAX_KEY - START_KEY + 1][INET6_ADDRSTRLEN];
 
-static int ip2str(struct ulogd_key *inp, int index, int oindex)
+static void ip2str(struct ulogd_key *inp, int i, struct ulogd_key *outp, int o,
+		   uint8_t addr_family)
 {
-	char family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
-	char convfamily = family;
+	union {
+		struct in6_addr in6;
+		struct in_addr  in;
+	} addr;
 
-	if (family == AF_BRIDGE) {
+	switch (addr_family) {
+	case AF_INET6:
+		memcpy(addr.in6.s6_addr, ikey_get_u128(&inp[i]),
+		       sizeof(addr.in6.s6_addr));
+		break;
+	case AF_INET:
+		addr.in.s_addr = ikey_get_u32(&inp[i]);
+		break;
+	}
+
+	inet_ntop(addr_family, &addr, ipstr_array[o], sizeof(ipstr_array[o]));
+
+	okey_set_ptr(&outp[o], ipstr_array[o]);
+}
+
+static int interp_ip2str(struct ulogd_pluginstance *pi)
+{
+	struct ulogd_key *outp = pi->output.keys;
+	struct ulogd_key *inp = pi->input.keys;
+	uint8_t proto_family, addr_family;
+	int i, o;
+
+	proto_family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
+
+	switch (proto_family) {
+	case AF_INET6:
+	case AF_INET:
+		addr_family = proto_family;
+		break;
+	case AF_BRIDGE:
 		if (!pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
 			ulogd_log(ULOGD_NOTICE,
 				  "No protocol inside AF_BRIDGE packet\n");
@@ -150,56 +182,28 @@ static int ip2str(struct ulogd_key *inp, int index, int oindex)
 		}
 		switch (ikey_get_u16(&inp[KEY_OOB_PROTOCOL])) {
 		case ETH_P_IPV6:
-			convfamily = AF_INET6;
+			addr_family = AF_INET6;
 			break;
 		case ETH_P_IP:
-			convfamily = AF_INET;
-			break;
 		case ETH_P_ARP:
-			convfamily = AF_INET;
+			addr_family = AF_INET;
 			break;
 		default:
 			ulogd_log(ULOGD_NOTICE,
 				  "Unknown protocol inside AF_BRIDGE packet\n");
 			return ULOGD_IRET_ERR;
 		}
-	}
-
-	switch (convfamily) {
-		uint32_t ip;
-	case AF_INET6:
-		inet_ntop(AF_INET6,
-			  ikey_get_u128(&inp[index]),
-			  ipstr_array[oindex], sizeof(ipstr_array[oindex]));
-		break;
-	case AF_INET:
-		ip = ikey_get_u32(&inp[index]);
-		inet_ntop(AF_INET, &ip,
-			  ipstr_array[oindex], sizeof(ipstr_array[oindex]));
 		break;
 	default:
 		/* TODO error handling */
 		ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
 		return ULOGD_IRET_ERR;
 	}
-	return ULOGD_IRET_OK;
-}
-
-static int interp_ip2str(struct ulogd_pluginstance *pi)
-{
-	struct ulogd_key *ret = pi->output.keys;
-	struct ulogd_key *inp = pi->input.keys;
-	int i;
-	int fret;
 
 	/* Iter on all addr fields */
-	for (i = START_KEY; i <= MAX_KEY; i++) {
+	for (i = START_KEY, o = 0; i <= MAX_KEY; i++, o++) {
 		if (pp_is_valid(inp, i)) {
-			fret = ip2str(inp, i, i - START_KEY);
-			if (fret != ULOGD_IRET_OK)
-				return fret;
-			okey_set_ptr(&ret[i - START_KEY],
-				     ipstr_array[i-START_KEY]);
+			ip2str(inp, i, outp, o, addr_family);
 		}
 	}
 
-- 
2.47.2

