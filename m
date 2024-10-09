Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5233191F75
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 11:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474509; cv=none; b=l7r+K6QlpxLqolM3nIMmDF6HS9yvnoNUAZM/uybvirq0Iav7h995YHuUY+e6uqlOUskawRlXlTcroaQs4XIdp3HlQwsQAKljxdOLLdt+I06n77vipG901Gxu3zZRzggrJDKVplPykpI+CZ+Oaub2Bn6AKjdPfJyxOteci0m4UTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474509; c=relaxed/simple;
	bh=TxX/0hq5GcZErA4RSQso4WVzewcJOXIoBPQE/nv4EMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPhCWBh8QW3zP1/WUYjcXE5KIpgUJjb2cgGrX9SYPva9G0PRoZXV/D0+ucFexp4SVCiIGkiHozGGwAXi25cgbg1EhOSX5V48QX0KqJEiEsux/wNkCgXYTTLerWkfqghBTirbqsuKE6nAY2Jzor1WkbjldwjXzLbbAYVH7j9JwTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mLhz9BxK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mLhz9BxK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tDl/fyCnbkiMdHGJzMZ5exGqU3od1t7vbfLUGrEqqCc=; b=mLhz9BxK6TZ6AhniUy8A5CUkmH
	/YNLzmwCa5c7o/HeNqfznqFHFt9Ay1XnDunTqjAl/h3qVFY4ZuZakR8mU3t/j0hy4i3lq9yTUEFKN
	cYJX5Eh761qqWyEmg4SiJgbSXkvVe92/TbZxr9dIxO1sbmykVeuXM3B4JIQgECjdRPUf17duFXs1S
	MRHgmHoJC8jE1s+oyJM8XNZPLCpuc/T9kyXIDFTb0P/C0w61+cLrvBsbPaxFlzIxCoM83XluFwThT
	minB1H1GcHpY8D9/xq25Yr8Qp99O2T3B0mzwoktU4aNt81HGOeYtlfDXUwBiMuPseljBbLYbw+YoL
	MF2mZHlw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syVB3-000000008HU-11GW;
	Wed, 09 Oct 2024 13:48:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 4/8] nft: Introduce UDATA_TYPE_COMPAT_EXT
Date: Wed,  9 Oct 2024 13:48:15 +0200
Message-ID: <20241009114819.15379-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009114819.15379-1-phil@nwl.cc>
References: <20241009114819.15379-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This new rule udata attribute will contain extensions which have been
converted to native nftables expressions for rule parsers to fall back
to.

While at it, export parse_udata_cb() as rule parsing code will call it
in future.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 11 +++--------
 iptables/nft.h | 12 ++++++++++++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index e629f995b7709..2cc654e2dd91d 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1670,14 +1670,7 @@ int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes)
 	return 0;
 }
 
-enum udata_type {
-	UDATA_TYPE_COMMENT,
-	UDATA_TYPE_EBTABLES_POLICY,
-	__UDATA_TYPE_MAX,
-};
-#define UDATA_TYPE_MAX (__UDATA_TYPE_MAX - 1)
-
-static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
+int parse_udata_cb(const struct nftnl_udata *attr, void *data)
 {
 	unsigned char *value = nftnl_udata_get(attr);
 	uint8_t type = nftnl_udata_type(attr);
@@ -1691,6 +1684,8 @@ static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
 		break;
 	case UDATA_TYPE_EBTABLES_POLICY:
 		break;
+	case UDATA_TYPE_COMPAT_EXT:
+		break;
 	default:
 		return 0;
 	}
diff --git a/iptables/nft.h b/iptables/nft.h
index 49653ecea7330..f1a58b9e52865 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -275,4 +275,16 @@ void nft_assert_table_compatible(struct nft_handle *h,
 int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 			      const char *chain, const char *policy);
 
+struct nftnl_udata;
+
+enum udata_type {
+	UDATA_TYPE_COMMENT,
+	UDATA_TYPE_EBTABLES_POLICY,
+	UDATA_TYPE_COMPAT_EXT,
+	__UDATA_TYPE_MAX,
+};
+#define UDATA_TYPE_MAX (__UDATA_TYPE_MAX - 1)
+
+int parse_udata_cb(const struct nftnl_udata *attr, void *data);
+
 #endif
-- 
2.43.0

