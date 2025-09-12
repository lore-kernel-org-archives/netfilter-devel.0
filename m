Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1B330DD2F
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Sep 2025 13:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757683217; cv=none; b=Zpm7tawgamJsXZM49RufMcHTz4k6KI99vf6/110UB0XAmW0ut3YMhIkdL5rfc3sSLXMlVFBMbMdEg6DLdruOnAErmT1gw5mXkjbzDjfU0FQ/PstAjPW7Y3wbh9UAMi7OUNJM5TFi1M71pfioi0Kw5srZag3AG3Cdywj6VETa0Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757683217; c=relaxed/simple;
	bh=RjL3Xw+fPEkYUYI5O2CnkjoJ0q7A73428m4eTN3zdUM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mOX9eX25mcfF20vRxcj0dAargFi38csBrddSV8Mx009m8rNvKvAKNmuh5VDWLDB/0lyI75R1XY/SZpC13G4fJ6ANKb/PKSRvWNjJnohhfTUlnNuvYajg+MmsS/v48v4poKCRi8l5J3hQoPSUweQ7URnBVm8VFSoevCIQ2UqDqoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3A23D601A6; Fri, 12 Sep 2025 15:20:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH RFC nf-next 1/2] netfilter: nft_set_pipapo_avx2: fix skip of expired entries
Date: Fri, 12 Sep 2025 15:19:59 +0200
Message-ID: <20250912132004.7925-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KASAN reports following splat:
BUG: KASAN: slab-out-of-bounds in pipapo_get_avx2+0x941/0x25d0
Read of size 1 at addr ffff88814c561be0 by task nft/3944

CPU: 7 UID: 0 PID: 3944 Comm: nft Not tainted 6.17.0-rc4+ #637 PREEMPT(full)
Call Trace:
 pipapo_get_avx2+0x941/0x25d0
 ? __local_bh_enable_ip+0x116/0x1a0
 ? pipapo_get_avx2+0xee/0x25d0
 ? nft_pipapo_insert+0x22b/0x11b0
 nft_pipapo_insert+0x440/0x11b0
 nf_tables_newsetelem+0x220a/0x3a00
 ..

This bisects down to
84c1da7b38d9 ("netfilter: nft_set_pipapo: use AVX2 algorithm for insertions too"),
however, it merely uncovers this bug.

When we find a match but that match has expired or timed out, the AVX2
implementation restarts the full match loop.

At that point, data (key element or start of register space with the key)
has already been incremented to point to the last key field:
out-of-bounds access occurs.

The restart logic in AVX2 is different compared to the plain C
implementation, but both should follow the same logic.

The C implementation just calls pipapo_refill() again to check the next
entry.  Do the same in the AVX2 implementation.

Note that with this change, due to implementation differences of
pipapo_refill vs. nft_pipapo_avx2_refill, the refill call will return
the same element again, then, on the next call it will move to the next
entry as expected.  This is because avx2_refill doesn't clear the bitmap
in the 'last' conditional.  This is harmless.

A selftest test case comes in a followup patch.

Sent as RFC tag because it needs to be revamped after net -> net-next
merge, there are conflicting changes in these two trees at the moment.

Another alternative is to retarget this patch to nf, but given its
a day-0 bug that only got exposed due to the use of AVX2 in insertion
path added recently I think -next is fine.

Cc: Stefano Brivio <sbrivio@redhat.com>
Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 7559306d0aed..d97b67a4de16 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1179,7 +1179,6 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 
 	nft_pipapo_avx2_prepare();
 
-next_match:
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last = i == m->field_count - 1, first = !i;
 		int ret = 0;
@@ -1226,6 +1225,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 
 #undef NFT_SET_PIPAPO_AVX2_LOOKUP
 
+next_match:
 		if (ret < 0) {
 			scratch->map_index = map_index;
 			kernel_fpu_end();
@@ -1238,8 +1238,10 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 
 			e = f->mt[ret].e;
 			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
-				     !nft_set_elem_active(&e->ext, genmask)))
-				goto next_match;
+				     !nft_set_elem_active(&e->ext, genmask))) {
+				ret = pipapo_refill(res, f->bsize, f->rules, fill, f->mt, last);
+				goto next_match:
+			}
 
 			scratch->map_index = map_index;
 			kernel_fpu_end();
-- 
2.49.1

