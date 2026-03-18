Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41CF31353B
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773841137; cv=none; b=iPtKx3wZsxJzJxTM37h4Ud962a/4vXeFgQgh54obkGqB8P8tf3EfyJdlIhStMLfVI/EEwbRS4VnvmMK1GxUqWMLckc5YUU1ZtgouJj4ZbE/5UmtSVQUQlJodApgrPGuKexw+9AJxffKAeV6x5/OEYnQSepavTYlxqYR3ZxJxCf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773841137; c=relaxed/simple;
	bh=EJuP/OxzZQ5hmNNJ4qM0cHEavix/d8zMB/GPo11ntsU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lz2CDKdLiLoOfgPMk1b1VeAcBotdZD2aKTYfRGg50TEhhXz32n3gvOl+y3GzTcy1wsK1wbKgQjJmkbEToM1z4Hdc/3AI7aulIdYKQro2zKlooD6h+mGHquenSW8F284JHLrZdVfQ70igrrZ1s9XeJ2Wa4aOcKyMtgpDF+S24vXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7D54A605C3; Wed, 18 Mar 2026 14:38:53 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nft_set_pipapo: increment data in one step
Date: Wed, 18 Mar 2026 14:38:34 +0100
Message-ID: <20260318133840.1334-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For unkown reason the C version increments the data pointer in two steps.
Switch to a single invocation of NFT_PIPAPO_GROUPS_PADDED_SIZE() helper,
like the avx2 implementation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7fd24e0cc428..50d4a4f04309 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -452,8 +452,6 @@ static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
 			pipapo_and_field_buckets_4bit(f, res_map, data);
 		NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
 
-		data += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
-
 		/* Now populate the bitmap for the next field, unless this is
 		 * the last field, in which case return the matched 'ext'
 		 * pointer if any.
@@ -498,7 +496,7 @@ static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
 		map_index = !map_index;
 		swap(res_map, fill_map);
 
-		data += NFT_PIPAPO_GROUPS_PADDING(f);
+		data += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
 
 	__local_unlock_nested_bh(&scratch->bh_lock);
-- 
2.52.0

