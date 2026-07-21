Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EBD3B2D00
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2026 20:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667184; cv=none; b=EhQz9TPgoQFLIeiqLxbglaxdaH93Wmcy7rmXJPTZX4wZW3Isqn+e/zdaNEsEqR3+KR/PtLDXrLu/pz8EzbJymevr8ESH75KDkkGTJvU7bdSahR9w2b+5sA/s4ue0WaYR1mWZM1SFYGeV0DtpLTbh4LYKtFXwVteRgztE0PIYf8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667184; c=relaxed/simple;
	bh=3TZQQr+Be0XoMb+2MliQFS7z0wVIk2EkFHiDQLu73ig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DhMm4XKTKPkzGbIytqETwRgMbYcnw9RUKG5Kt/Y7BYMnSF1MLyKWTPgsx/PV0L6EK6ApFBbXnmLqmobVORGIommgJjOt6qW84u+B6V6AvyQsyuf0vcO3nq+HyWHZytcW+cDGbZqn2tBeqjFK7YkKsYXln4n2y/09gW+nxx5Dn9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gZj/daKr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gZj/daKr"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DBDFF6019F;
	Tue, 21 Jul 2026 22:52:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784667180;
	bh=HLlHkhi9daUBfuKz/leAw/lOBHJhuIWqLIcLLvXRCGo=;
	h=From:To:Cc:Subject:Date:From;
	b=gZj/daKr6SeZnE4oMiSHmABiHSz55Mxh/EwWAxRSvyteexZBpIL9bJPG3OMpfmVV0
	 gL9/OGDsE3q2p5WEGgVBvyXX7YHCcFeeJ1qmKb8Xce+szItogmVjwKieADfvDVDxOy
	 yREUu1Fik1NdonEmAVoNAE5ZZmZx3G7u6oOFCsZCbtRuHEyJnnjZbsl62THgrtB2ss
	 /cGmn/v35DXr7h+1mUvUw4UgZtjCWJX36JahYw/gKQJ/zaXLUy6Yb4HrHEelRaEy0C
	 MzkHZDYakK5obKsD4PY64sQrRRlpWdpR7mG60FyY+8mEPe07errdjbM4edqdg5Vb24
	 Gp6NtFmPpgWzg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: talha.anything.info@gmail.com
Subject: [PATCH nf,v3] netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH
Date: Tue, 21 Jul 2026 22:52:56 +0200
Message-ID: <20260721205256.28769-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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
Reported-by: Talha Berk Arslan <talha.anything.info@gmail.com>
Link: https://patch.msgid.link/20260721074629.668-1-talha.anything.info@gmail.com/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: reject XT_HASHLIMIT_RATE_MATCH for revision less than 3 too.

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

