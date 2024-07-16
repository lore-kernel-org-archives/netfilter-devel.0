Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D171991B0
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 12:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721132895; cv=none; b=f9GmAZ8u/CZDca0Ku8g7X3Jkm2vEpoilQ4ld9DY45n74+ACFvvSmWAfOV59xDjnH6QiQNtOK2op3A0enp+dHEsahOBk+2Nhbe0EkIcC1Lzkd+53DVFppkMZT5lIOX4ya0re9knCCE+IudkTyXmo9IstDSnEe9xpq6HPfHLvozHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721132895; c=relaxed/simple;
	bh=kqreRsjj8elBF2Gix/Fr85jjiypRibF0LpL5sVb+1VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GX7zNR6RhqrKpTd77b8XYXJL79V4rlD4R74L4R3aDqkLS0DUw3Tu5LXd6Ukl/DUOhpK5o7djRe105Xu5Amy5sBtz0GwGNhHerjdybNAraOBligpA11ZHC60YYnayOjg4B1o0+cETuNTLFoIu5I506vyzgVqYYrKOdfa1kLdumfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fRFly2Tv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fRFly2Tv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IduPTip0XZKJDPDLt2+lxkaZxLaqKo5PSxZ3HJFb5tk=; b=fRFly2TvOs1DyI2ou+m/VWzW+2
	56NWFL7BAt8Qk6O9xts2VzDrC4ldd2SBCwREEde+zHW+7LCRjmbrM4S8zjHynrCKVtiLmO/fxwy98
	sPIgFt4lfrZ7n1FNXnyIFgYldX9OBSLuYlo7Ttfu38ViUigqvpLAA+jJqDlq3AQjBeBV1L05jXvuw
	/aWn4mdgT2gDSqVo7OnKK5tNmzoEuuTVS7CRhn/zBOTuyu+CwonMhJvUHM1nI5iDUgqjrdc8Q0fsA
	gY1vFF0JJYug9cUibBGG4Hw0a9f8aw05I7zmZMl2LrK55oFti+H5h6rAVDpmjWGRGAjPcc3qWFmBH
	LMaBWE7A==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sThHv-000000007tQ-3wQD;
	Tue, 16 Jul 2024 14:28:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 7/8] xtables-monitor: Ignore ebtables policy rules unless tracing
Date: Tue, 16 Jul 2024 14:28:04 +0200
Message-ID: <20240716122805.22331-8-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240716122805.22331-1-phil@nwl.cc>
References: <20240716122805.22331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not expose this implementation detail to users, otherwise new
user-defined chains are followed by a new rule event.

When tracing, they are useful as they potentially terminate rule
traversal.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                                        |  2 +-
 iptables/nft.h                                        |  1 +
 .../shell/testcases/nft-only/0012-xtables-monitor_0   | 11 ++---------
 iptables/xtables-monitor.c                            |  7 +++++++
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 884cc77e647ba..83fb81439ccb1 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1813,7 +1813,7 @@ nft_rule_print_save(struct nft_handle *h, const struct nftnl_rule *r,
 	return ret;
 }
 
-static bool nft_rule_is_policy_rule(struct nftnl_rule *r)
+bool nft_rule_is_policy_rule(struct nftnl_rule *r)
 {
 	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] = {};
 	const void *data;
diff --git a/iptables/nft.h b/iptables/nft.h
index b2a8484f09f0a..8f17f3100a190 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -185,6 +185,7 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain, const char *tabl
 int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format);
 int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table, bool verbose);
 int nft_rule_zero_counters(struct nft_handle *h, const char *chain, const char *table, int rulenum);
+bool nft_rule_is_policy_rule(struct nftnl_rule *r);
 
 /*
  * Operations used in userspace tools
diff --git a/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0 b/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
index 0f0295b05ec52..ef1ec3c9446ae 100755
--- a/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
+++ b/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
@@ -51,7 +51,6 @@ EXP="\
  EVENT: -6 -t filter -A FORWARD -j ACCEPT"
 monitorcheck ip6tables -A FORWARD -j ACCEPT
 
-# FIXME
 EXP="\
  EVENT: nft: NEW table: table filter bridge flags 0 use 1 handle 0
  EVENT: nft: NEW chain: bridge filter FORWARD use 1 type filter hook forward prio -200 policy accept packets 0 bytes 0 flags 1
@@ -70,10 +69,7 @@ monitorcheck iptables -N foo
 EXP=" EVENT: -6 -t filter -N foo"
 monitorcheck ip6tables -N foo
 
-# FIXME
-EXP="\
- EVENT: nft: NEW chain: bridge filter foo use 1
- EVENT: ebtables -t filter -A foo -j ACCEPT"
+EXP=" EVENT: nft: NEW chain: bridge filter foo use 1"
 monitorcheck ebtables -N foo
 
 EXP=" EVENT: -0 -t filter -N foo"
@@ -110,10 +106,7 @@ monitorcheck iptables -X foo
 EXP=" EVENT: -6 -t filter -X foo"
 monitorcheck ip6tables -X foo
 
-# FIXME
-EXP="\
- EVENT: ebtables -t filter -D foo -j ACCEPT
- EVENT: nft: DEL chain: bridge filter foo use 0"
+EXP=" EVENT: nft: DEL chain: bridge filter foo use 0"
 monitorcheck ebtables -X foo
 
 EXP=" EVENT: -0 -t filter -X foo"
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 7079a039fb28b..b54a704bb1786 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -96,6 +96,13 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 	arg->h->ops = nft_family_ops_lookup(family);
 	arg->h->family = family;
 
+	/* ignore policy rules unless tracing,
+	 * they are reported when deleting user-defined chains */
+	if (family == NFPROTO_BRIDGE &&
+	    arg->is_event &&
+	    nft_rule_is_policy_rule(r))
+		goto err_free;
+
 	if (arg->is_event)
 		printf(" EVENT: ");
 	switch (family) {
-- 
2.43.0

