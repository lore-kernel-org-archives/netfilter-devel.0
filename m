Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C842D20C484
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Apr 2025 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745169650; cv=none; b=s2Jc8eggpxJAyltaH3X1wAMeU7XnGkYe3aA1IhhN6kgpMXS3LBHdmSpDHOY5sqkjHJX823RDsnhT8kh5MHDUgsedDru41AlyUnyVb9xzT3XDaWXPwm5D4RyJE4tI5f/R/6iGm2H+qSkJaNykSchA3Tdvc30utsFdKcJbiMrzhnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745169650; c=relaxed/simple;
	bh=O53q16RX7PaDT/xS4LIMC0SkzVZdiUzsmF4520RdfZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thpx843et9Vl/P+/TnAzqhSp1qVCI/nx61UXvB+qcgr+PT28Pz1tTs66svwA2wUOTWGDUorIPcZFbcqLsdg3NW2yJexlPf5y/Hr07JCR8H+eMiuN0LccT049y/w6+kFca1Id4pNIjYDhuxknrtLOvSdnlEvEg0ZK10IPIh3/leg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=PstxZMkv; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="PstxZMkv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/Dg34u6D/rEXf92oou14xVyZ2eWMIDo8Tl6kL8Zvee4=; b=PstxZMkvTIXf+63Hmd9IUnhnWr
	GzC3xsCO8KtFSH/G9O3tZWMko6gqwZs/bWOjBqtF+h8qyj+3bR7B7rl77qHrQRZzMU4SBXle181wo
	qB/LaFDsZ5NIUuUwgPJpP80VHIB4DCctILoTqzsJv6rqngDArC+OSV/+1nFgDIIFHTTBMnwARgnho
	yIODiQC56Jb+g7TvtavE3aLEPBfqQjkIHKAV/0Ptim/qUmsmoZuivxeaqr5feO7Bjqv3bNqRtt7YE
	Amj9Pw0QFsO43dZPseiRFIsiSWPHj0+1LaEraSJFOsR2Les1MPDZIC5EFXDWpw4hdSA2pBtq/Dz5c
	W3D2dFuA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1u6YLO-005Uip-0j;
	Sun, 20 Apr 2025 18:20:38 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc: Slavko <linux@slavino.sk>
Subject: [PATCH ulogd2 4/6] IP2BIN, IP2HBIN, IP2STR: refactor `interp` call-backs
Date: Sun, 20 Apr 2025 18:20:23 +0100
Message-ID: <20250420172025.1994494-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250420172025.1994494-1-jeremy@azazel.net>
References: <20250420172025.1994494-1-jeremy@azazel.net>
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
`ps_is_valid` checks, into `ip2*` functions.

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

