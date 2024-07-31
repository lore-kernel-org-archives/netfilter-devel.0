Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB64316D4D0
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 22:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722464833; cv=none; b=eGI2nsRkK/Zsxqtf2Wucuiap+wAGvKcdKutjZJ7GLkOJm4cIIfSWTbkvOcP0ykGo6NzmpAWcaMHLnMsAkfM1kozIV4z2BW9n1QIu5pwvEEamYQkpG0KbnL1xE1bTT0S2WbFgkzHVzseGm1Pfd3hN1UbO+zH1oCCA+bxWpkv7Q94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722464833; c=relaxed/simple;
	bh=G8mnnKWCS5fteAeMjTmJ0uBe1zansgTNyWL9H6dqvHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/l7Yx+m9mfLortBKQhVz0w06/3FsnQp9Gp/YVmwXqeGRZdrqqfgk4wnhTUVlMqX4S59PVDyEJaqdUaO1xmCrr66q5UwGj1mSlNPEmxtBk96gpvNMf1Rfmj8RY8pmFnrOhgopTPXc3pgKluKtJsPYPpqEqdXl6zSSI9pHBA+YjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KFFDarmv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KFFDarmv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=E9/YT/09w4PvdAlQJAKTvpIk8XD9N9aiMzcB6JCnQ+8=; b=KFFDarmvpuaQafYCvSc3CRThlU
	ja6eePc6LorB6EPsct5ttTRWYIVVNrJ9rHU45XmSVaukw+7veMmcWx7omtdPSBqZcw5OoyU8j4OsL
	/dnQao+/2GTfwEfV/zgWXZyfKbbHr1dJhOJ4SCsQtxqaR2eS8NQjy78GHcxw097ARLathgCzA8Xh/
	SrD1fXLc6PPZrjqzFFqR2madcaavgFqUBbBXbC5Vm4RmEMUmZKLp4EyeVZYvTB7bdcYcDEb7xmbKW
	/x/u07hAepEAzcUFleCqUflG+GvghJpLgGfumiyk53Fht5229jsFk2l47LLmd1yOHHzqk5mIZFhrE
	5ny4pylg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sZHmm-000000003iO-2DRn;
	Thu, 01 Aug 2024 00:27:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 7/8] nft: Introduce UDATA_TYPE_COMPAT_EXT
Date: Thu,  1 Aug 2024 00:27:02 +0200
Message-ID: <20240731222703.22741-8-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240731222703.22741-1-phil@nwl.cc>
References: <20240731222703.22741-1-phil@nwl.cc>
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
index cabcc884b4069..64ac35f2edcf3 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1668,14 +1668,7 @@ int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes)
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
@@ -1689,6 +1682,8 @@ static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
 		break;
 	case UDATA_TYPE_EBTABLES_POLICY:
 		break;
+	case UDATA_TYPE_COMPAT_EXT:
+		break;
 	default:
 		return 0;
 	}
diff --git a/iptables/nft.h b/iptables/nft.h
index 54fe5210ad1ac..d6424f499cfcf 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -276,4 +276,16 @@ void nft_assert_table_compatible(struct nft_handle *h,
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

