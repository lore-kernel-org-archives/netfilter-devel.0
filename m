Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFF060249
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706882000; cv=none; b=AV47XYRT5uKtpwPkuR1NXgcIq6vlVZTJCgTg5z6V5Cad4y32VTIkJ3twmz0pRCiRNkQ/k5x86ORFggsOIkp0uu2ZXQjdxHQI9XEws8SiLZT1MqsF6KPxsn2LDHV57ZgECxHQW3d6JFMnLdnzJypauLN5CAAM6s2KE+nrCYcSC7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706882000; c=relaxed/simple;
	bh=ouwbM3tCttkuXMRvYLecLiRBd2xTpdUwUcX+7M0o5AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4uy+OBzYFpF7pmm7utLcBuJvopM5RZLngowi5V3T+/hpSm0Aq9h5uKJKtFPC3zFzaI5bWznFcvfazYkzrfh1j4Lr9lH4Zane6GicuNiPFEz/qP8Kz6M1GIMDtjBG/vW5SsixFJafofrvJazO9FWJosJIdXf1vqYmg8HyigawDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=oKfI+2zw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oKfI+2zw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lG5gc6miByE/7KaolWk7clDf+RA3GfoKDEY1CxRVMmE=; b=oKfI+2zwCOE/J+PZ9DU35nvOJy
	y8ruRsKvfRkO5sHQOGH6Adycc/0BG08xENukY8WZlxjnKhZGDhXabwK92M5BL5UfKt/o0rnoHc3uI
	qnAs7pHb54GPWScioAdJfyzMTu5GvsefV0hLes507vjZIzS/MdfNk8/FSoXgG3XQliJDiRgNhVtoC
	mh1qkNXcrmapFTw5MxDQzNjH7rXUiCM9n8kcT1uaq+Bf0z0lRb3+YTEIrIRmF1/sz/cg7cH2fQMCz
	Ci+hC1X2dcS3a/NEdqnR/10F8lF30fJxDfewULXvp4AlA/8O2WS3mY54orDFY+u3ua6iX0PgGqvMI
	iDhjTriw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyh-000000003Bg-0cYP;
	Fri, 02 Feb 2024 14:53:11 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 04/12] extensions: ah: Save/xlate inverted full ranges
Date: Fri,  2 Feb 2024 14:52:59 +0100
Message-ID: <20240202135307.25331-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202135307.25331-1-phil@nwl.cc>
References: <20240202135307.25331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While at it, fix xlate output for plain '-m ah' matches: With
ip6tables-translate, one should emit an extdhr exists match since
ip6t_ah.c in kernel also uses ipv6_find_hdr(). With iptables-translate,
a simple 'meta l4proto ah' was missing.

Fixes: bb498c8ba7bb3 ("extensions: libip6t_ah: Fix translation of plain '-m ah'")
Fixes: b9a46ee406165 ("extensions: libipt_ah: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_ah.c      | 22 +++++++++++++---------
 extensions/libip6t_ah.t      |  2 +-
 extensions/libip6t_ah.txlate |  4 ++--
 extensions/libipt_ah.c       | 22 ++++++++++++++--------
 extensions/libipt_ah.t       |  2 +-
 extensions/libipt_ah.txlate  |  4 ++--
 6 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index f35982f379d76..0f95c4735eabd 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -58,13 +58,18 @@ static void ah_parse(struct xt_option_call *cb)
 	}
 }
 
+static bool skip_spi_match(uint32_t min, uint32_t max, bool inv)
+{
+	return min == 0 && max == UINT32_MAX && !inv;
+}
+
 static void
 print_spis(const char *name, uint32_t min, uint32_t max,
 	    int invert)
 {
 	const char *inv = invert ? "!" : "";
 
-	if (min != 0 || max != 0xFFFFFFFF || invert) {
+	if (!skip_spi_match(min, max, invert)) {
 		if (min == max)
 			printf("%s:%s%u", name, inv, min);
 		else
@@ -103,11 +108,10 @@ static void ah_print(const void *ip, const struct xt_entry_match *match,
 static void ah_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)match->data;
+	bool inv_spi = ahinfo->invflags & IP6T_AH_INV_SPI;
 
-	if (!(ahinfo->spis[0] == 0
-	    && ahinfo->spis[1] == 0xFFFFFFFF)) {
-		printf("%s --ahspi ",
-			(ahinfo->invflags & IP6T_AH_INV_SPI) ? " !" : "");
+	if (!skip_spi_match(ahinfo->spis[0], ahinfo->spis[1], inv_spi)) {
+		printf("%s --ahspi ", inv_spi ? " !" : "");
 		if (ahinfo->spis[0]
 		    != ahinfo->spis[1])
 			printf("%u:%u",
@@ -132,11 +136,11 @@ static int ah_xlate(struct xt_xlate *xl,
 		    const struct xt_xlate_mt_params *params)
 {
 	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)params->match->data;
+	bool inv_spi = ahinfo->invflags & IP6T_AH_INV_SPI;
 	char *space = "";
 
-	if (!(ahinfo->spis[0] == 0 && ahinfo->spis[1] == 0xFFFFFFFF)) {
-		xt_xlate_add(xl, "ah spi%s ",
-			(ahinfo->invflags & IP6T_AH_INV_SPI) ? " !=" : "");
+	if (!skip_spi_match(ahinfo->spis[0], ahinfo->spis[1], inv_spi)) {
+		xt_xlate_add(xl, "ah spi%s ", inv_spi ? " !=" : "");
 		if (ahinfo->spis[0] != ahinfo->spis[1])
 			xt_xlate_add(xl, "%u-%u", ahinfo->spis[0],
 				     ahinfo->spis[1]);
@@ -158,7 +162,7 @@ static int ah_xlate(struct xt_xlate *xl,
 	}
 
 	if (!space[0]) /* plain '-m ah' */
-		xt_xlate_add(xl, "meta l4proto ah");
+		xt_xlate_add(xl, "exthdr ah exists");
 
 	return 1;
 }
diff --git a/extensions/libip6t_ah.t b/extensions/libip6t_ah.t
index eeba7b451fc6d..19aa6f55ec0e9 100644
--- a/extensions/libip6t_ah.t
+++ b/extensions/libip6t_ah.t
@@ -14,7 +14,7 @@
 -m ah --ahspi;;FAIL
 -m ah;=;OK
 -m ah --ahspi :;-m ah;OK
--m ah ! --ahspi :;-m ah;OK
+-m ah ! --ahspi :;-m ah ! --ahspi 0:4294967295;OK
 -m ah --ahspi :3;-m ah --ahspi 0:3;OK
 -m ah --ahspi 3:;-m ah --ahspi 3:4294967295;OK
 -m ah --ahspi 3:3;-m ah --ahspi 3;OK
diff --git a/extensions/libip6t_ah.txlate b/extensions/libip6t_ah.txlate
index fc7248abba001..32c6b7de00937 100644
--- a/extensions/libip6t_ah.txlate
+++ b/extensions/libip6t_ah.txlate
@@ -17,7 +17,7 @@ ip6tables-translate -A INPUT -m ah --ahspi 500 --ahlen 120 --ahres -j ACCEPT
 nft 'add rule ip6 filter INPUT ah spi 500 ah hdrlength 120 ah reserved 1 counter accept'
 
 ip6tables-translate -A INPUT -m ah --ahspi 0:4294967295
-nft 'add rule ip6 filter INPUT meta l4proto ah counter'
+nft 'add rule ip6 filter INPUT exthdr ah exists counter'
 
 ip6tables-translate -A INPUT -m ah ! --ahspi 0:4294967295
-nft 'add rule ip6 filter INPUT meta l4proto ah counter'
+nft 'add rule ip6 filter INPUT ah spi != 0-4294967295 counter'
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index fec5705ce6f53..39e3013d3e74b 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -39,13 +39,18 @@ static void ah_parse(struct xt_option_call *cb)
 		ahinfo->invflags |= IPT_AH_INV_SPI;
 }
 
+static bool skip_spi_match(uint32_t min, uint32_t max, bool inv)
+{
+	return min == 0 && max == UINT32_MAX && !inv;
+}
+
 static void
 print_spis(const char *name, uint32_t min, uint32_t max,
 	    int invert)
 {
 	const char *inv = invert ? "!" : "";
 
-	if (min != 0 || max != 0xFFFFFFFF || invert) {
+	if (!skip_spi_match(min, max, invert)) {
 		printf("%s", name);
 		if (min == max) {
 			printf(":%s", inv);
@@ -75,11 +80,10 @@ static void ah_print(const void *ip, const struct xt_entry_match *match,
 static void ah_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_ah *ahinfo = (struct ipt_ah *)match->data;
+	bool inv_spi = ahinfo->invflags & IPT_AH_INV_SPI;
 
-	if (!(ahinfo->spis[0] == 0
-	    && ahinfo->spis[1] == 0xFFFFFFFF)) {
-		printf("%s --ahspi ",
-			(ahinfo->invflags & IPT_AH_INV_SPI) ? " !" : "");
+	if (!skip_spi_match(ahinfo->spis[0], ahinfo->spis[1], inv_spi)) {
+		printf("%s --ahspi ", inv_spi ? " !" : "");
 		if (ahinfo->spis[0]
 		    != ahinfo->spis[1])
 			printf("%u:%u",
@@ -96,15 +100,17 @@ static int ah_xlate(struct xt_xlate *xl,
 		    const struct xt_xlate_mt_params *params)
 {
 	const struct ipt_ah *ahinfo = (struct ipt_ah *)params->match->data;
+	bool inv_spi = ahinfo->invflags & IPT_AH_INV_SPI;
 
-	if (!(ahinfo->spis[0] == 0 && ahinfo->spis[1] == 0xFFFFFFFF)) {
-		xt_xlate_add(xl, "ah spi%s ",
-			   (ahinfo->invflags & IPT_AH_INV_SPI) ? " !=" : "");
+	if (!skip_spi_match(ahinfo->spis[0], ahinfo->spis[1], inv_spi)) {
+		xt_xlate_add(xl, "ah spi%s ", inv_spi ? " !=" : "");
 		if (ahinfo->spis[0] != ahinfo->spis[1])
 			xt_xlate_add(xl, "%u-%u", ahinfo->spis[0],
 				   ahinfo->spis[1]);
 		else
 			xt_xlate_add(xl, "%u", ahinfo->spis[0]);
+	} else {
+		xt_xlate_add(xl, "meta l4proto ah");
 	}
 
 	return 1;
diff --git a/extensions/libipt_ah.t b/extensions/libipt_ah.t
index d86ede60970ac..6059366013ad7 100644
--- a/extensions/libipt_ah.t
+++ b/extensions/libipt_ah.t
@@ -12,7 +12,7 @@
 -m ah;;FAIL
 -p ah -m ah;=;OK
 -p ah -m ah --ahspi :;-p ah -m ah;OK
--p ah -m ah ! --ahspi :;-p ah -m ah;OK
+-p ah -m ah ! --ahspi :;-p ah -m ah ! --ahspi 0:4294967295;OK
 -p ah -m ah --ahspi :3;-p ah -m ah --ahspi 0:3;OK
 -p ah -m ah --ahspi 3:;-p ah -m ah --ahspi 3:4294967295;OK
 -p ah -m ah --ahspi 3:3;-p ah -m ah --ahspi 3;OK
diff --git a/extensions/libipt_ah.txlate b/extensions/libipt_ah.txlate
index e35ac17ab6c64..baf5a0ae6182a 100644
--- a/extensions/libipt_ah.txlate
+++ b/extensions/libipt_ah.txlate
@@ -8,7 +8,7 @@ iptables-translate -A INPUT -p 51 -m ah ! --ahspi 50 -j DROP
 nft 'add rule ip filter INPUT ah spi != 50 counter drop'
 
 iptables-translate -A INPUT -p 51 -m ah --ahspi 0:4294967295 -j DROP
-nft 'add rule ip filter INPUT counter drop'
+nft 'add rule ip filter INPUT meta l4proto ah counter drop'
 
 iptables-translate -A INPUT -p 51 -m ah ! --ahspi 0:4294967295 -j DROP
-nft 'add rule ip filter INPUT counter drop'
+nft 'add rule ip filter INPUT ah spi != 0-4294967295 counter drop'
-- 
2.43.0

