Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BA7366824
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 23:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773184283; cv=none; b=MPEEOyI0PmzAO8Ssp4wCkHgr8aCkqCi7e/wZ1da8veZsZ+is7VZz8XfrL+JMXsGzAfwZcKqlUTtXi+H0wOPDMwCLpSFpBYV4Yy19edV2tLYWL+8LdXbuS6VL5wBAZ7NatEt9kyMRXyA/FE832IoFGNFIvIu6OOI7grvuwrS72sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773184283; c=relaxed/simple;
	bh=3oeWApSIfsPcJTcoSMydLzSxiHaaiu1Uoo5V1qTq3j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f65vKkUxdig0bpGPAkyyf47bXp/PHlRo162gTrOzNuZoSP2S+3pAZ3f2RU8sP13n9idQgt2LVU7qN33HY9wQfxmcDj+j8MiAUMoLiznmMOpUQZrVY/kaP1Wn6OEC+Cbt1W8TSh3OZGSMo9oEU9kt3NY70Ubg2797ugxe3FJjA40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jEnfwv9e; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jEnfwv9e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dfGwNRSm2Xxi6ZnhbUvKscFKELTQwEsc2YOwSqKEFSU=; b=jEnfwv9e6RlCu99VE1/qFbfnUq
	L3WUsYSg1orBs55/6CVPXKdDg2GZd2spThiVRoVyo1fLt64dAPqUTJIp/SPGco8WtqjpcqZrhpoZD
	vUKGXfAQLDhsC8Bcf2gnr9Rw1dL54vg8oP4mwDo7kOtbH/WRjdHrCM5ylAlnmIecoAlJCR9EvaFHT
	gX9JJb1uUbrkSEE6PYWLcn+HXQAyvyk3KrlTBCDL0iGWGCqRU6IgiWjP/rUHHETB2u2Psb9ZGOaAR
	m9JR+bhiZ/W0x5YWLFt9hXrvNsQ5ASFSlcF5x6P/U46Tx/To/8WJShNifMh73BYadpx9td9s1/lMd
	71NnZBkg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w06ES-000000004qR-1ucr;
	Wed, 11 Mar 2026 00:11:20 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/5] cache: Filter for table when listing sets or maps
Date: Wed, 11 Mar 2026 00:11:14 +0100
Message-ID: <20260310231115.25638-5-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310231115.25638-1-phil@nwl.cc>
References: <20260310231115.25638-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Respect an optionally specified table name to filter listed sets or maps
to by populating the filter accordingly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c                                 | 1 +
 tests/shell/testcases/listing/cache_filters | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/src/cache.c b/src/cache.c
index 13d4cb19eb4f6..f86d000690929 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -252,6 +252,7 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_MAPS:
 		filter->list.family = cmd->handle.family;
+		filter->list.table = cmd->handle.table.name;
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_SET;
 		if (!nft_output_terse(&nft->output))
 			flags |= NFT_CACHE_SETELEM;
diff --git a/tests/shell/testcases/listing/cache_filters b/tests/shell/testcases/listing/cache_filters
index 37c8f845dd4c7..7a89330d2b6c0 100755
--- a/tests/shell/testcases/listing/cache_filters
+++ b/tests/shell/testcases/listing/cache_filters
@@ -22,6 +22,8 @@ table ip ip_t {
 	chain ip_t_c2 {
 	}
 }
+table ip ip_t2 {
+}
 EOF
 
 $NFT --debug=netlink list ruleset | \
@@ -38,6 +40,8 @@ $NFT --debug=netlink list sets | \
 	grep -q 'family 2 ip_t_s ip_t' || fail "broken list sets"
 $NFT --debug=netlink list sets ip6 | \
 	grep -q 'family 2 ip_t_s ip_t' && fail "broken list sets family filter"
+$NFT --debug=netlink list sets ip ip_t2 | \
+	grep -q 'family 2 ip_t_s ip_t' && fail "broken list sets table filter"
 
 $NFT --debug=netlink list flowtables | \
 	grep -q 'flow table ip_t ip_t_ft' || fail "broken list flowtables"
-- 
2.51.0

