Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA8C1420A1
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706882002; cv=none; b=jA3ZNOofYsRHpgwzD4r8pYVHhuuWv9NNaFEuXoe6i9VKDIYsz/AnRaccG5eeDw1ZJCdsv070R2c3IzpYuUxLb9ANZT8kFyo8D9sK6yzdVb5pfKFgFuUyvN71/AZjTMsC+ztWNR3IfGpubF7deaXgLvQcoBz05pdFNFjTZwNCI0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706882002; c=relaxed/simple;
	bh=ZDv445iWkl+Z++7Yb/TepD0p/wGim9s6+pRQlMfWfJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAnE5Vq6m2XWOlR7jmERaNMybsR4XEeVAnG8ogMQKuRU95C8BSPIHtg3L2ew1ephgSjdpE2xZ/853hrDYmZ4Hsrz8T6YPbEuRfcRwDl6ChciTabAxDEDquv/AVEdyok4zYhxA+o69Pw1GgxBZZ7JXUZAiUhdVndtbhMM3fp8m10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B8ayaoRT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B8ayaoRT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+43oNp3yeC6mKtobgfL+kFbf5P0uWePoTdNQOi4X4Es=; b=B8ayaoRTGGcs4RSKg0b0ihZAWM
	C0OPNluCcfpRla7wUhIEcrsAMnJdhxNBs00NWZAAXoBGAQsqFx1qaFtQtU8REdr5XpVXMpMHigJr/
	fJw/bPhm7/xNFm5kHORlouQdHuhldrtQA4FeD0wmWTGNn0n3Qb8BOvgzkVOcpfYBu63UHSc9RqbmP
	fFWKKbwCEttNQ8g3sz9IUpWcHvHUEF6b2BH+/C9hwBVjsJF6pvKyv/trEsvxnIS9LNPzL2SyumoIX
	H1IbRNZGfCPWkNJtygvj1S9oV3m1RhM7Xvj+FU+pDgIfCi+oYcLRplFc3l/qqBnuZ8fnYF1EBjKxy
	wQPHpXSA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyj-000000003Bx-2b9v;
	Fri, 02 Feb 2024 14:53:13 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 08/12] extensions: esp: Save/xlate inverted full ranges
Date: Fri,  2 Feb 2024 14:53:03 +0100
Message-ID: <20240202135307.25331-9-phil@nwl.cc>
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

Also add a translation for plain '-m esp' match which depends on the
address family: While ip6tables-translate may emit an exthdr exists
match, iptables-translate must stick to meta l4proto.

Fixes: 6cfa723a83d45 ("extensions: libxt_esp: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_esp.c      | 26 ++++++++++++++++++--------
 extensions/libxt_esp.t      |  2 +-
 extensions/libxt_esp.txlate |  8 ++++----
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 2c7ff942cb9e0..8e9766d71ed57 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -39,13 +39,18 @@ static void esp_parse(struct xt_option_call *cb)
 		espinfo->invflags |= XT_ESP_INV_SPI;
 }
 
+static bool skip_spis_match(uint32_t min, uint32_t max, bool inv)
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
+	if (!skip_spis_match(min, max, invert)) {
 		if (min == max)
 			printf(" %s:%s%u", name, inv, min);
 		else
@@ -69,11 +74,10 @@ esp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 static void esp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_esp *espinfo = (struct xt_esp *)match->data;
+	bool inv_spi = espinfo->invflags & XT_ESP_INV_SPI;
 
-	if (!(espinfo->spis[0] == 0
-	    && espinfo->spis[1] == 0xFFFFFFFF)) {
-		printf("%s --espspi ",
-			(espinfo->invflags & XT_ESP_INV_SPI) ? " !" : "");
+	if (!skip_spis_match(espinfo->spis[0], espinfo->spis[1], inv_spi)) {
+		printf("%s --espspi ", inv_spi ? " !" : "");
 		if (espinfo->spis[0]
 		    != espinfo->spis[1])
 			printf("%u:%u",
@@ -90,15 +94,21 @@ static int esp_xlate(struct xt_xlate *xl,
 		     const struct xt_xlate_mt_params *params)
 {
 	const struct xt_esp *espinfo = (struct xt_esp *)params->match->data;
+	bool inv_spi = espinfo->invflags & XT_ESP_INV_SPI;
 
-	if (!(espinfo->spis[0] == 0 && espinfo->spis[1] == 0xFFFFFFFF)) {
-		xt_xlate_add(xl, "esp spi%s",
-			   (espinfo->invflags & XT_ESP_INV_SPI) ? " !=" : "");
+	if (!skip_spis_match(espinfo->spis[0], espinfo->spis[1], inv_spi)) {
+		xt_xlate_add(xl, "esp spi%s", inv_spi ? " !=" : "");
 		if (espinfo->spis[0] != espinfo->spis[1])
 			xt_xlate_add(xl, " %u-%u", espinfo->spis[0],
 				   espinfo->spis[1]);
 		else
 			xt_xlate_add(xl, " %u", espinfo->spis[0]);
+	} else if (afinfo->family == NFPROTO_IPV4) {
+		xt_xlate_add(xl, "meta l4proto esp");
+	} else if (afinfo->family == NFPROTO_IPV6) {
+		xt_xlate_add(xl, "exthdr esp exists");
+	} else {
+		return 0;
 	}
 
 	return 1;
diff --git a/extensions/libxt_esp.t b/extensions/libxt_esp.t
index 686611f22b457..ece131c934b90 100644
--- a/extensions/libxt_esp.t
+++ b/extensions/libxt_esp.t
@@ -5,7 +5,7 @@
 -p esp -m esp ! --espspi 0:4294967294;=;OK
 -p esp -m esp --espspi -1;;FAIL
 -p esp -m esp --espspi :;-p esp -m esp;OK
--p esp -m esp ! --espspi :;-p esp -m esp;OK
+-p esp -m esp ! --espspi :;-p esp -m esp ! --espspi 0:4294967295;OK
 -p esp -m esp --espspi :4;-p esp -m esp --espspi 0:4;OK
 -p esp -m esp --espspi 4:;-p esp -m esp --espspi 4:4294967295;OK
 -p esp -m esp --espspi 3:4;=;OK
diff --git a/extensions/libxt_esp.txlate b/extensions/libxt_esp.txlate
index 3b1d5718057b1..5e8fb241beaf4 100644
--- a/extensions/libxt_esp.txlate
+++ b/extensions/libxt_esp.txlate
@@ -11,13 +11,13 @@ iptables-translate -A INPUT -p 50 -m esp --espspi 500:600 -j DROP
 nft 'add rule ip filter INPUT esp spi 500-600 counter drop'
 
 iptables-translate -A INPUT -p 50 -m esp --espspi 0:4294967295 -j DROP
-nft 'add rule ip filter INPUT counter drop'
+nft 'add rule ip filter INPUT meta l4proto esp counter drop'
 
 iptables-translate -A INPUT -p 50 -m esp ! --espspi 0:4294967295 -j DROP
-nft 'add rule ip filter INPUT counter drop'
+nft 'add rule ip filter INPUT esp spi != 0-4294967295 counter drop'
 
 ip6tables-translate -A INPUT -p 50 -m esp --espspi 0:4294967295 -j DROP
-nft 'add rule ip6 filter INPUT counter drop'
+nft 'add rule ip6 filter INPUT exthdr esp exists counter drop'
 
 ip6tables-translate -A INPUT -p 50 -m esp ! --espspi 0:4294967295 -j DROP
-nft 'add rule ip6 filter INPUT counter drop'
+nft 'add rule ip6 filter INPUT esp spi != 0-4294967295 counter drop'
-- 
2.43.0

