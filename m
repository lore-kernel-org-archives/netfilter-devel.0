Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795658563;
	b=LYnw4erXvvgPiwWUEQp5NUEnXLM/iAKoRWHQYe15gk+nyMaTahfe0ORefAQkCTuEmmsB
	 x1gaJaxtH+LFwJ0v2iw/1+cnb6Bawv156SYEt0OrMUL0YTCeIlkfbo7wJn3mYDUnMeldg
	 6toZuVGrIYtZ/PFVJbRwWrRQJ+yts+TFg9d7ass5ozMF8idAi9UWq2RE2V4eWbxMmC44s
	 N4IwZHFvVdjUbpxX0+Ok/CmiuSZlzA7DNJhjWPJhtEG4M8uMxfsNBjFMPEXDWg5qXGZBp
	 j48JQpMfL8Zhao8JeygcNwcxxQ9RlW+LthKXXK8drCT3Z0NvIYAKteyNWYJ6IaluPiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795658563;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=fZkgrWh/UxdfRwGSrdhHZkQzn2DEerdY4pbXGUDAU5E=;
	b=Wj6XDEuHnUo9y6h9b8x2Z2sxZ1/dHR0p9ScZwirFfM03xJPLpqWuuqZB4Mfx78NZPzKm
	 8cp0Tv8l6gCQqzlHk3vMbGDwx0D9UJSblqn5GtA9bG55A8ZLyeBU3VdfIKzZDzZUD2Vpc
	 xMqDUZ01/hl9gO8tn4j9gtTHu3LAEXrbZjNSZYgCsbV7loR8nVK6zkz0HnT4bIZnCrafN
	 HPcN/UcnaacfCrFsyAxDi2w8CppMjsUU5ZZRCXwEHszcSg3MQQS2ubWTqNN1efNWG51fw
	 p/IrOftfO6n+kNPr5i6vCXxo7tU6w9Nes5OI+fqfDE+lrWxn/LXEotgAeeGi21/TB8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=iYysVkgG;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53901606A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 02:02:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53901606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=iYysVkgG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795658560;
	bh=fZkgrWh/UxdfRwGSrdhHZkQzn2DEerdY4pbXGUDAU5E=;
	h=From:To:Cc:Subject:Date:From;
	b=iYysVkgGdzXoRWK4N5o5aewQzhGVznkKix3gmAT/huIrl50Hq9NBx5juq/tSmShM0
	 WjuN/Ula8n3Ld/bmh4/OOw22cLQd9TMd3fLqELb7F0wRhLUJJDigmViPkWm0V6LNDd
	 KzJArkOrsWxNB2lZkthV0Ni87B5AOLu/NneXFhpWy/yi3fNgu4PSlKBY07wATWmK4I
	 +tW+cQVckfBclCBsdWV34wbFY7MoIIZpj14azmC1Z+UV2xwy1eeIjZNUVpf0DNFAjX
	 3onRjP0sBo+cE/7IRQdzfvNQGf57Uc0OcfPn9RICxnWXS2TKSm2eh4MkkxHJ+UCFF3
	 yB1PkSAIsvcjw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2E6B860187;
	Thu, 26 Nov 2026 03:02:40 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	eric@garver.life
Subject: [PATCH nft,v2] rule: revisit standard bridge filter and raw priorities
Date: Thu, 26 Nov 2026 03:02:35 +0100
Message-ID: <20261126020236.2482286-1-pablo@netfilter.org>
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

While at this, add the raw priority at -300 just like the same existing
families.

The remaining priorities are related to br_netfilter, so still allow to
parse them for backwards compatibility, but let's only print filter and
raw.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt |  4 ++--
 src/rule.c  | 14 +++++++++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

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
index d232582b6080..c1f6da763676 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -902,18 +902,26 @@ static const struct prio_tag std_prios[] = {
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
 	if (family == NFPROTO_BRIDGE) {
 		switch (prio) {
-		case NF_BR_PRI_NAT_DST_BRIDGED:
+		case NF_IP_PRI_FILTER:
+			return true;
+		case NF_IP_PRI_RAW: /* NF_BR_PRI_NAT_DST_BRIDGED */
 			if (hook == NF_BR_PRE_ROUTING)
 				return true;
 			break;
@@ -1007,7 +1015,7 @@ static const char *prio2str(const struct output_ctx *octx,
 
 	mpz_export_data(&prio, expr->value, BYTEORDER_HOST_ENDIAN, sizeof(int));
 	if (family == NFPROTO_BRIDGE) {
-		prio_arr = bridge_std_prios;
+		prio_arr = new_bridge_std_prios;
 		arr_size = array_size(bridge_std_prios);
 	} else {
 		prio_arr = std_prios;
-- 
2.47.3

