Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBDE4779C
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706881998; cv=none; b=MwrVQaPBRBJAmN7twGOf44bjfc+lWkDaNw/TklWWB4jSpwD1M0XkcKx4OXezjMfLsgoHZGp7VOSgP26OF8UXYNplpOUP3/ftM9XqbMVEmir0yZOKptAcgQ3goo2ZJ78naZ3yBHuPh9q2n01ZsvQ3+3ZpDqGf0YxYeYCDrHhHve0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706881998; c=relaxed/simple;
	bh=k4mZA8xK8/PT/L+JrHBYXxP7soBzL32rEk9yIRFqcv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da54ENsglxJFDgyz2dK7J6YrroioNaYZrVE/Vh23r50kXxxN+ysSuZX/VQkyXNIho/Jd+T5fVNmn7kH641WTZCcnzaIpEEHv9SuQzLBdEtp85hKoD+eT3ZaOnNxA6QB2S3YpncOoACMFE3z4cYvY2fp7zWqBOX52Vb8xjR1dOUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LTHYs9RI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LTHYs9RI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=slmBxg7IT+jpN9T5Q4fjaFI+q2WmZb9AMpdH7IbUae0=; b=LTHYs9RIbg1CLGur2spMyTvG1r
	snOMF7yG1E/uA1xQhEy0b4WmXSwup3ZF6vslcyMuEBX96EC2OOMluUn4/uMwAkB0rOvgF2KVg7hlJ
	9qF8SPwzmTrQ/51EtpXLyvTr+ZVXCh9SheS+sU30Zn/5zzOboDebH5lNdSqsDu6BnwWlx7sXZ4a+4
	gM48WV4Z782gLMljOqcoHMCdw++JmJmKAsKxoI4qorF8He2PdGVP8eNJP/GF4sTqyAOm64/JtBP08
	nx+kB2TH5SLc55wQmfvYJfsY/6swmL9a0F7JCMeIPvyjzyd/YZEPTs+Xnbj42kKjJ7Gam09JUKnjn
	TAWkqVpQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyl-000000003CE-1Q8i;
	Fri, 02 Feb 2024 14:53:15 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 06/12] extensions: mh: Save/xlate inverted full ranges
Date: Fri,  2 Feb 2024 14:53:01 +0100
Message-ID: <20240202135307.25331-7-phil@nwl.cc>
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

Also translate '-m mh' into an exthdr exists match unless '-p mh' is
also present. The latter is converted into 'meta l4proto mh' which might
need fixing itself at a later point.

Fixes: 6d4b93485055a ("extensions: libip6t_mh: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_mh.c      | 20 ++++++++++++++++----
 extensions/libip6t_mh.t      |  2 +-
 extensions/libip6t_mh.txlate |  4 ++--
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 1410d324b5d42..3f80e28ec94c8 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -17,6 +17,7 @@
 #include <stdlib.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_mh.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
 
 enum {
 	O_MH_TYPE = 0,
@@ -154,11 +155,16 @@ static void print_type(uint8_t type, int numeric)
 		printf("%s", name);
 }
 
+static bool skip_types_match(uint8_t min, uint8_t max, bool inv)
+{
+	return min == 0 && max == UINT8_MAX && !inv;
+}
+
 static void print_types(uint8_t min, uint8_t max, int invert, int numeric)
 {
 	const char *inv = invert ? "!" : "";
 
-	if (min != 0 || max != 0xFF || invert) {
+	if (!skip_types_match(min, max, invert)) {
 		printf(" ");
 		if (min == max) {
 			printf("%s", inv);
@@ -189,11 +195,12 @@ static void mh_print(const void *ip, const struct xt_entry_match *match,
 static void mh_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
+	bool inv_type = mhinfo->invflags & IP6T_MH_INV_TYPE;
 
-	if (mhinfo->types[0] == 0 && mhinfo->types[1] == 0xFF)
+	if (skip_types_match(mhinfo->types[0], mhinfo->types[1], inv_type))
 		return;
 
-	if (mhinfo->invflags & IP6T_MH_INV_TYPE)
+	if (inv_type)
 		printf(" !");
 
 	if (mhinfo->types[0] != mhinfo->types[1])
@@ -206,9 +213,14 @@ static int mh_xlate(struct xt_xlate *xl,
 		    const struct xt_xlate_mt_params *params)
 {
 	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)params->match->data;
+	bool inv_type = mhinfo->invflags & IP6T_MH_INV_TYPE;
+	uint8_t proto = ((const struct ip6t_ip6 *)params->ip)->proto;
 
-	if (mhinfo->types[0] == 0 && mhinfo->types[1] == 0xff)
+	if (skip_types_match(mhinfo->types[0], mhinfo->types[1], inv_type)) {
+		if (proto != IPPROTO_MH)
+			xt_xlate_add(xl, "exthdr mh exists");
 		return 1;
+	}
 
 	if (mhinfo->types[0] != mhinfo->types[1])
 		xt_xlate_add(xl, "mh type %s%u-%u",
diff --git a/extensions/libip6t_mh.t b/extensions/libip6t_mh.t
index 151eabe631f58..b628e9e33fd3e 100644
--- a/extensions/libip6t_mh.t
+++ b/extensions/libip6t_mh.t
@@ -5,7 +5,7 @@
 -p mobility-header -m mh ! --mh-type 4;=;OK
 -p mobility-header -m mh --mh-type 4:123;=;OK
 -p mobility-header -m mh --mh-type :;-p mobility-header -m mh;OK
--p mobility-header -m mh ! --mh-type :;-p mobility-header -m mh;OK
+-p mobility-header -m mh ! --mh-type :;-p mobility-header -m mh ! --mh-type 0:255;OK
 -p mobility-header -m mh --mh-type :3;-p mobility-header -m mh --mh-type 0:3;OK
 -p mobility-header -m mh --mh-type 3:;-p mobility-header -m mh --mh-type 3:255;OK
 -p mobility-header -m mh --mh-type 3:3;-p mobility-header -m mh --mh-type 3;OK
diff --git a/extensions/libip6t_mh.txlate b/extensions/libip6t_mh.txlate
index 825c956905c22..3364ce574468f 100644
--- a/extensions/libip6t_mh.txlate
+++ b/extensions/libip6t_mh.txlate
@@ -8,7 +8,7 @@ ip6tables-translate -A INPUT -p mh --mh-type 0:255 -j ACCEPT
 nft 'add rule ip6 filter INPUT meta l4proto mobility-header counter accept'
 
 ip6tables-translate -A INPUT -m mh --mh-type 0:255 -j ACCEPT
-nft 'add rule ip6 filter INPUT counter accept'
+nft 'add rule ip6 filter INPUT exthdr mh exists counter accept'
 
 ip6tables-translate -A INPUT -p mh ! --mh-type 0:255 -j ACCEPT
-nft 'add rule ip6 filter INPUT meta l4proto mobility-header counter accept'
+nft 'add rule ip6 filter INPUT meta l4proto mobility-header mh type != 0-255 counter accept'
-- 
2.43.0

