Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF5943F4D3;
	Wed, 22 Jul 2026 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754881; cv=none; b=Qnm0FZ8JDJB0vcQzI4V5Ujemedh60dSOIikd0jgvsps5LTGDWDPm/hOMNeXXZRQeax9vF43IdFwtKaMeSmUmQ1dOhb36izM21mYb8Sm/tBHa/ybYflDc+o1mtKHO9vlvak0Iodq427nFodozae15R/FS4Tmod3phdPPAq6U7CBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754881; c=relaxed/simple;
	bh=EE1owj3L4mR9GBU/chUs02gtKXGfsMrt5VMh137lJT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buH/N78p8zVFGvrV/koWJGK9O7XLehv7Yheuo6CO0XcnIKrKTXxjtsEmaWI5prLeMaNoHfFY7g28dhUzNrSS4bYBGKmN3UpMd9aLiwegC2aSzrck8eTQ/0g5nOfBc4x+EcTkleVye3nGxyA4Z4tDjgpvZHaH9WUAfb32PMuZXGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dYAmOSSb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dYAmOSSb"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 061AE6019F;
	Wed, 22 Jul 2026 23:14:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784754878;
	bh=LHwgdNbQGVHr6BgGMrHwVKn0AtHSLucGs6u3WEdz7G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYAmOSSbUzng37CJXXMn0u0hgh6a4UBXvcbNPQJhNR3aiwCMsmghDTfr4gwPw4XoO
	 x3Wnc1wgRK8/6QTdYG10yhIR74d8S96+vQp49jZF2k5q4Nl0Kd+oO1UOxEJNo41B19
	 G5kBBjuul3yaE//9X3yiNoBBVcUhcqYspLawGrcGm6FGmVSPhmRJlsZWrOJzyX6r/v
	 3WM6v2whGZECieN/31d7Nr38JRxTOlNq2MK6OXSM8DuPQqM92emF76sg487f2Fr8Je
	 +1mr3lefF9xm9hpGUtVTAmjaIXXxxd14RagzsrxB3eXS2SSI//g44FemdcLf1EPMXb
	 67fmIAiUgScNQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 08/13] netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH
Date: Wed, 22 Jul 2026 23:14:15 +0200
Message-ID: <20260722211420.153933-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722211420.153933-1-pablo@netfilter.org>
References: <20260722211420.153933-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The XT_HASHLIMIT_RATE_MATCH flag mode changes the semantics of the
dsthash_ent structure which represents an entry in the hashtable.  There
is a union area which uses a different layout to express the rate match
mode.

Update .checkentry path to validate the XT_HASHLIMIT_RATE_MATCH mode
flag is requested by two or more different rules that refer to the same
hashtable. Otherwise, uninitialized access to the burst field in the
union is possible.

Reject the use of the XT_HASHLIMIT_RATE_MATCH mode flag if set on by
revision less than 3 too.

Fixes: bea74641e378 ("netfilter: xt_hashlimit: add rate match mode")
Reported-and-tested-by: Talha Berk Arslan <talha.anything.info@gmail.com>
Link: https://patch.msgid.link/20260721074629.668-1-talha.anything.info@gmail.com/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 2704b4b60d1e..9af0fa895f73 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -117,6 +117,7 @@ struct xt_hashlimit_htable {
 	refcount_t use;
 	u_int8_t family;
 	bool rnd_initialized;
+	bool ratematch;
 
 	struct hashlimit_cfg3 cfg;	/* config */
 
@@ -323,6 +324,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		kvfree(hinfo);
 		return -ENOMEM;
 	}
+	hinfo->ratematch = !!(cfg->mode & XT_HASHLIMIT_RATE_MATCH);
 	spin_lock_init(&hinfo->lock);
 
 	switch (revision) {
@@ -872,7 +874,10 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 	}
 
 	/* Check for overflow. */
-	if (revision >= 3 && cfg->mode & XT_HASHLIMIT_RATE_MATCH) {
+	if (cfg->mode & XT_HASHLIMIT_RATE_MATCH) {
+		if (revision < 3)
+			return -EINVAL;
+
 		if (cfg->avg == 0 || cfg->avg > U32_MAX) {
 			pr_info_ratelimited("invalid rate\n");
 			return -ERANGE;
@@ -905,6 +910,15 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 			mutex_unlock(&hashlimit_mutex);
 			return ret;
 		}
+	} else {
+		if ((cfg->mode & XT_HASHLIMIT_RATE_MATCH &&
+		     !(*hinfo)->ratematch) ||
+		    (!(cfg->mode & XT_HASHLIMIT_RATE_MATCH) &&
+		      (*hinfo)->ratematch)) {
+			mutex_unlock(&hashlimit_mutex);
+			htable_put(*hinfo);
+			return -EINVAL;
+		}
 	}
 	mutex_unlock(&hashlimit_mutex);
 
-- 
2.47.3

