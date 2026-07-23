Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACE3372B53;
	Thu, 23 Jul 2026 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824790; cv=none; b=VW95J+rrVaFR8EwC5dJ8jYiVTQzVFx2zNNxf4aVATZtKY5Fl1ruQU1MSEC2rsUpqvlpQNKaquUPzhd+4lA+vXCu6PVl/CjKG37haxOYUPvFCMsibh7SELlMpi6isgyhKTWsQBFnZikVaqiMTtjXDHERK8M18KIfDXVrXgZzJK5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824790; c=relaxed/simple;
	bh=EE1owj3L4mR9GBU/chUs02gtKXGfsMrt5VMh137lJT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJ0M/aJLwqbUZ+5yDVnvkWi9lomG7wAOimbiRYX5pw//pY5VtLklzd+anHJoPOhuS7ztrrQkTNWvsil2PbrNjaVRp5Jgtn/vfpmjsQe5ZyL1ULPo6z4RkQgs1C2UxZ6b9cSLWQ8SWsCVHtGwz3Zi3ByXwGF1QRPBV8l6cuNdyi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CHhPU8ge; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CHhPU8ge"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D0A90601C1;
	Thu, 23 Jul 2026 18:39:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784824778;
	bh=LHwgdNbQGVHr6BgGMrHwVKn0AtHSLucGs6u3WEdz7G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHhPU8gevaSBYfiEPljiD7Tst0AjfgupMVu/KM07c1bvAlXCpcgbRAg40W4GuYCl7
	 lxEKLxSsjepb/67JjoaZoCk/fDFyGnSvX+OpQCGTK0xx4y9NJ/Tomqvn58Ap4wLC6+
	 Z8vtUMfrd/wWvLgHhIKfUZkDhCiErr8chk2uTLd7xo3CcNBxvedXV8mjSih9GUidcA
	 I27jsg+3NkhVQXvP/VWjawX+raeDYZ5I73VxWDdDv7HmxrEiyQ7OU9BLiIwCalegUN
	 ZhB7IGmptvFgfqHFu93hrXv0iQhIu6r/2uaDEyYxYecD92kw3Dx90ChycbI9MTmHAz
	 huKRJ9Sm9fRJA==
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
Date: Thu, 23 Jul 2026 18:39:05 +0200
Message-ID: <20260723163910.274695-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723163910.274695-1-pablo@netfilter.org>
References: <20260723163910.274695-1-pablo@netfilter.org>
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

