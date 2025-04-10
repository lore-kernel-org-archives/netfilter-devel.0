Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FB527CB0B
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 10:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744279507; cv=none; b=rVnvuljT5NCjxXoFzSsr1OMoF1vaDNhOzO6saneOMdw2oGozAmDZjBjHb6IKt9gcMoaZOkTDCZ9U5fVescTOBzbv6+jtX41ytg4xaeoBSHPv/mmSpP5/cImlWfCI2j399nGmLPh12qAh8qbs98FzgYeDR1ovE5Kz1UO1iusOooQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744279507; c=relaxed/simple;
	bh=JX8qz5sg+CpL2Rn9vMzFW5lGLmyqCJAXp3U1GGha+gk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iGTI0vOgca8n5bBwFKIB72HwpAyZPAPC3LwQGhs4HMDyN9mPtmqMUC8ZH24NiaQIEYclBuqFwldnKqPZ28dnH6AHlWBNp825+DBokwZWLlFTEoBbvhvp5FWiy+AoRf/RTrBUvZkEMvqrizAAad+cQfI2OHFuPChxbY6SRGbl6mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aqKAC/6Z; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D7iZtOvT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aqKAC/6Z";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D7iZtOvT"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 16E2660694; Thu, 10 Apr 2025 12:05:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744279502;
	bh=DQLcodXF9PYCbMBESeAaeeugdd+8HMiZR1Mxr42qrrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqKAC/6ZXfRgnDbpgFsIaCnR+4rlXwZ7D8SxACqafW7qSf5xxyK8paH3GODhs87Z9
	 d5MLYFP9XjDDcTUPS8QgXmyHPl2NOrfJfK3XzBhYm1SdQIduAkcIJ4D2s2JGCLG0bp
	 /c8dTL9Owey5HLH5YVRJ8LChdpA9aQkFYU4XN0LIXk0NCkIobR2lp4InwPlQPzpKA1
	 uBqn3jVWwpV6QmmQn6uT4gP7e9ERkp7vCeepw3S8rxa85fZLuuW4Q8su+yzfoo8Uo9
	 CXM0drm/kb8JBesfw8MicNsDFZXkyAfi0PyF1Wul+I+OVMBL3us6uucFqLqPmjsir3
	 yjgKDgdPQ53gg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 74ED260681;
	Thu, 10 Apr 2025 12:05:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744279501;
	bh=DQLcodXF9PYCbMBESeAaeeugdd+8HMiZR1Mxr42qrrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7iZtOvTjpyvxkDkK1ch2WNgX5pkJBbqpxM/SI3p6zWGxeYkzS8ed04q7CEz2R+R+
	 +DRAdb5JsVEufSTYOclPnjhGx7LWl6MAVcoaudpBSMQ1OmGujoahs3zTAGDSvzK8Wz
	 xXCgHPTdm+27TWyJDpuCB7Pyi3fHLWTpuxVjK4w+uAc03/AqheqwzIJNG4QFh+6Ilj
	 viz5ZmbsEFUIkt0svoxDBDG4xD3R2pB1HDP5VfTV8uZVYt4ZeSeMDYxqURiUiA639p
	 sV9yps3PSzrF9RuT57/xVWMrLaqg7j7G+C5wTyAAz58dJo9rt6h0PNPzmjbyZt8Jxp
	 h0MvoYSYj1uIQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	sbrivio@redhat.com
Subject: [PATCH nf-next,v2 2/2] netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX
Date: Thu, 10 Apr 2025 12:04:56 +0200
Message-Id: <20250410100456.1029111-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250410100456.1029111-1-pablo@netfilter.org>
References: <20250410100456.1029111-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, it is possible to hit WARN_ON_ONCE in __kvmalloc_node_noprof()
when resizing hashtable because __GFP_NOWARN is unset.

Similar to:

  b541ba7d1f5a ("netfilter: conntrack: clamp maximum hashtable size to INT_MAX")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: detached from patch 1/2 posted as v1.

 net/netfilter/nft_set_pipapo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 1b5c498468c5..ffb8c3623a93 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -663,6 +663,9 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
 	    check_add_overflow(rules, extra, &rules_alloc))
 		return -EOVERFLOW;
 
+	if (rules_alloc > (INT_MAX / sizeof(*new_mt)))
+		return -ENOMEM;
+
 	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL_ACCOUNT);
 	if (!new_mt)
 		return -ENOMEM;
@@ -1491,6 +1494,9 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
 		if (src->rules > 0) {
+			if (src->rules_alloc > (INT_MAX / sizeof(*src->mt)))
+				goto out_mt;
+
 			dst->mt = kvmalloc_array(src->rules_alloc,
 						 sizeof(*src->mt),
 						 GFP_KERNEL_ACCOUNT);
-- 
2.30.2

