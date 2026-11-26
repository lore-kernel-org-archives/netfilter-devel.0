Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795657923;
	b=nJM/xl+jMko8TuTWyzH3NWvdyMO+RaM1YIhMsx/YY3UEzPsVMZClzuFOCxo2XX/7SrxW
	 W7tpPURDrnTtaSZuvInILVaBoNeRyISHLgV4jz5KnVUEGyLA/wbIkcHKUZcoBHhPvBWVV
	 REZE3tl+pIRDA6KbNiMGcMtNjtggLEr+3KDbHKVXO/57Sqki91dN9c4p7+eXenvJvLCSO
	 Fi8yF3OG0vX3aDUGflVoEQ0wAO/cpktsqpbiausrd1rNPoQ1mKYaR4HTm1xh4zkCFLHta
	 z7J1WsdMS4PZQQjw9JWUhWWI0flJywoRJeGr2BliID8M3Jnl4SdBCpGQtQjgSXNMhyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795657923;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=rAxZWeNjRGuF6wfEkJ3IDtkyzw6UKlCgsHKilmvBhWw=;
	b=r0zb2ARxibrBCfd4PY46VdzI+QS76Sy50aB9JhVBUznEuKSFOnr3AeV+v2g07UO+WJY9
	 2AhhF1MH5MqEg3IZXi6+Ro/6s+d5BcRUWDqHIKE5j/Ll0toreeC8E2bbduMDBh6gJRIT+
	 uNlCC650qjitcxzIESLVXCDiLQfQkO4ANOOZ782r8TyP6p8zuZV4Q1yDQXanXluq2EaQJ
	 +peW6vOZmLtY6U01vIjWR+8Bwx0XcfLMCO2yzK/9uV5P90+b1Dmufm2Z8q5PoqYosKJtY
	 7Ib/zkQtIAObIY9axJwGad9a6HPFv83pI5rpjzK7f1OWgk8eOLZFnS++zVj92l2X+8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dRK+pNZ1;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B25E606A323
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 01:52:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B25E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dRK+pNZ1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795657920;
	bh=rAxZWeNjRGuF6wfEkJ3IDtkyzw6UKlCgsHKilmvBhWw=;
	h=From:To:Cc:Subject:Date:From;
	b=dRK+pNZ12WPwWHb9fbklS83YgBk0ua+0IXAjl+go8rNY0kLpC72Ch4d7TH9NFA7dV
	 wwUP1lxVc+2Lgqc8rXImhcJI+ftVZxUXMnPDpcYIj8Qhmyxkp6sJDfEXJZD+XAlFQU
	 ThZrYYyQB73IzCxeB4rDL1LQON9HaCHBZWOgDf0TxnA+RXs26XC+7M3LhPa9DyJt5G
	 or33fUOYXLPlOADOPMDHaGU3eB1KG6IvC90xF+XxZkWgtSkcp63hkN4YEBihNJJ1x3
	 UegpmrQcqFxfHiX/2yZXtGcsPd3SgfX5uPabvZBPFZV0F8wnOUpEibJ9iUbd7k8xE7
	 gIOtSOYJyGYBw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E195D60085;
	Thu, 26 Nov 2026 02:51:59 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	eric@garver.life
Subject: [PATCH nft] rule: revisit standard bridge filter and raw priorities
Date: Thu, 26 Nov 2026 02:51:54 +0100
Message-ID: <20261126015154.2391412-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit c8a0e8c90e2d ("src: Set/print standard chain prios with textual
names)" introduces legacy standard priorities for the bridge which have
been never documented.

Use 0 as the filter priority for parity with existing families,
currently this uses -200 which is exactly the prerouting/conntrack hook.
Behaviour of hooks registered at the same priority is undefined, ie. it
depends on whether the basechain or conntrack registers first.

While at this, at also the raw priority, at -300 just like the same
existing families.

The remaining priorities are related to br_netfilter, so still allow to
parse them for backwards compatibility, but let's only print filter and
raw.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt |  4 ++--
 src/rule.c  | 10 ++++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index a7ef9a7183b5..09d5193890fd 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -487,10 +487,10 @@ the others. See the following tables that describe the values and compatibility.
 [options="header"]
 |==================
 | Name | Value | Families | Hooks
-| raw | -300 | ip, ip6, inet | all
+| raw | -300 | ip, ip6, inet, bridge | all
 | mangle | -150 | ip, ip6, inet | all
 | dstnat | -100 | ip, ip6, inet | prerouting
-| filter | 0 | ip, ip6, inet, arp, netdev | all
+| filter | 0 | ip, ip6, inet, arp, netdev, bridge | all
 | security | 50 | ip, ip6, inet | all
 | srcnat | 100 | ip, ip6, inet | postrouting
 |===================
diff --git a/src/rule.c b/src/rule.c
index d232582b6080..67f897819b50 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -902,12 +902,18 @@ static const struct prio_tag std_prios[] = {
 };
 
 static const struct prio_tag bridge_std_prios[] = {
+	{ NF_IP_PRI_RAW,	      "raw" },
 	{ NF_BR_PRI_NAT_DST_BRIDGED,  "dstnat" },
-	{ NF_BR_PRI_FILTER_BRIDGED,   "filter" },
+	{ NF_IP_PRI_FILTER,	      "filter" },
 	{ NF_BR_PRI_NAT_DST_OTHER,    "out" },
 	{ NF_BR_PRI_NAT_SRC,          "srcnat" },
 };
 
+static const struct prio_tag new_bridge_std_prios[] = {
+	{ NF_IP_PRI_RAW,	      "raw" },
+	{ NF_IP_PRI_FILTER,	      "filter" },
+};
+
 static bool std_prio_family_hook_compat(int prio, int family, int hook)
 {
 	/* bridge family has different values */
@@ -1007,7 +1013,7 @@ static const char *prio2str(const struct output_ctx *octx,
 
 	mpz_export_data(&prio, expr->value, BYTEORDER_HOST_ENDIAN, sizeof(int));
 	if (family == NFPROTO_BRIDGE) {
-		prio_arr = bridge_std_prios;
+		prio_arr = new_bridge_std_prios;
 		arr_size = array_size(bridge_std_prios);
 	} else {
 		prio_arr = std_prios;
-- 
2.47.3

