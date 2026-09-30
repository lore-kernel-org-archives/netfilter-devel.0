Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAE644C64B;
	Wed, 30 Sep 2026 07:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754118; cv=none; b=ZEWrHG7vfU8JgkcJSfPypdA8jFboh5aZtTIoQGbk6w9t3u9nOR5lffkgI4/AGq3CroUH5MIgpWtI9foMUXj1/M/t1FQE0WK2kN2/xuenajMLre/t4l2ePJPay5i3WcQlKoiWJEeC0wKTKHATPFx5yY3mp0XpaZwv2V4pfVA1sWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754118; c=relaxed/simple;
	bh=hvKl/MVOWB90vjhvMf6KtdrTPfMUV/fDGAwguKby5x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hc2Q5EGG4Rwwt9BtLR3IU2dZOVPQsKmL1nwGoDygfu89iMk8xpYbcqxV0rfQZuS62Tn5YXQgiPOLCDbv7Sr2/szRUPrgSGKNsPEe0VBp2kORgIIlMBAQL/ugkNK0SJDzm6DGsQ/RtuNWhEUPai9wOMRjQRXZ6SWwIUj1E48+zYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ppQTMYIA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ppQTMYIA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790754108;
	bh=obLcSQDIiPunVN8yOBpGpgQLMPs0/ghhehx7yiIyNlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppQTMYIAzOoqzeYYpDidUXQ5bgPzubBzWBLEmgjEOqdcEU/6lCCpSSUKqDL+VeM4i
	 mhw5K9xiKcoCZtv4qfpBxplgGhryOn4iDKGxAotCOL7essXVVB/uwzeVEaEtEQdIUZ
	 ZS0ODASrjBotLWkwR1SkJupJbkVpyJk4E1RRRRbEAgtrH9cPqdEJhsMvorPsW3B3+8
	 /AilwY6iHx9b3BtxA4312QVRGsBcS9LxalWSb2H6ayrlc3RfAAw85ybYNBb7KsdPrg
	 jWN2mLl3sGrucyXB/oKOa/0VW+I68Zdc6Ebsga84c2hW27Ea5nP/yF1LR5OhP84rNB
	 4s9oNEC1oPnjQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1348D60610;
	Wed, 30 Sep 2026 09:41:48 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 01/10] netfilter: ipset: do not update comments from kernel-side adds
Date: Wed, 30 Sep 2026 09:41:32 +0200
Message-ID: <20260930074142.298353-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260930074142.298353-1-pablo@netfilter.org>
References: <20260930074142.298353-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

'Fixes' commit stopped calling ip_set_init_comment() for hash types
from kernel-side-adds (xtables .. -j SET).  ip_set_init_comment() says:

   "The kadt functions don't use the comment extensions in any way."

But bitmap set type calls the function from kadt cb too.

While this appears to be safe (serialized via the set spinlock), it seems
better to not call the init function either, least of all to keep
behaviour consistent.

ip_set_list calls ip_set_init_comment() only from uadt cb, it can be
kept as-is.

This was triggered by yet another LLM review, hinting that the existing
rcu_dereference_protected() cannot be downgraded to only check if the
nfnl mutex is held.

Fixes: f30415929be8 ("netfilter: ipset: do not update comments from kernel-side hash adds")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index d6a7e6604542..ae376fa3e7a3 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -159,7 +159,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(x, set), ext);
-	if (SET_WITH_COMMENT(set))
+	if (SET_WITH_COMMENT(set) && !ext->target)
 		ip_set_init_comment(set, ext_comment(x, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(x, set), ext);
-- 
2.47.3

