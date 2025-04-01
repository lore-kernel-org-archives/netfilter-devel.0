Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EA41ACED1
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 14:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743517642; cv=none; b=FbT9uywKMicp1TMvKO7ty3TkMdnbQY4yKeVnzcHuwT3fw6jQoMlSYsHjqruI2axm9p4cq535r91TEPwAvZQr+OfrL+tDRh2DS/fUABdMdNadkP2KKjGENrXjcj0P+d/EWR9Y5ic21i0aBFPHSSj8V3yAGW19bXPaq2/4goGSW3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743517642; c=relaxed/simple;
	bh=PYgiRT/k+MUoA7BnV33IXgh2Vrc45OXbXow2Jh+YY8U=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=VwYqUrXI9TTPoOfKixiMu+sFsQF7VLXUlGpOl6ohS2Pg8vxXtxaIriVceh6uAnG0jE+vuDlPDvFqHovjNojpfbNODi4WU8OhAVg0Kr5jVyntdE9mlFsw/Fwe+lfMlg6HQD0YHy3drnh9DrL6PMXDcAjIs96FFL0KYzMjIKCXG+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RPELyqVw; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cLN58vBi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RPELyqVw";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cLN58vBi"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 695766037D; Tue,  1 Apr 2025 16:27:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743517630;
	bh=e+rfHHz2jxMTB24rci3gtIvf9izAh2uMUitksj2HEfA=;
	h=From:To:Subject:Date:From;
	b=RPELyqVwyZI1T/4D2W6Mnj3qTvuxJZxEYWVKuSJ68qrXs3G8o8SENyROqofVwlNIu
	 uZ6j3ShckXRkSAI9lFNtn0ViloxAoUMJnXNye//hbrVVROaBMZeNGWXArkq1H/O+id
	 LMiuSk5n/UzW9VvG1QsS4lSmZ3pS/X2phsFi7iWR7n0MuHZbrhJhiEOnb/I/Yyo52q
	 DlvTiw62wVbJM5jfQ8I35z/ZXCsPbjoJagV13EfIrRlo1xOI7HPAVYG7LWPJRKomHm
	 OcJV5IgFPb2ZoqeXeaiAWghrd6zV/8NsjFucO8bD8zkIu6MAbSQGh6F9xI2kkmJ/XF
	 fOnvCcfifjGYA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7E77560375
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 16:27:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743517628;
	bh=e+rfHHz2jxMTB24rci3gtIvf9izAh2uMUitksj2HEfA=;
	h=From:To:Subject:Date:From;
	b=cLN58vBi3dUvphvh6C5teL6Q3LArLzCF+BrvMW/F2NrTYsooiGOjdpPGOkV+GBwAB
	 VHLWGdm2Hjl2qCWl/aT8+w/FE1dBgs/2VHW7TF5TLB9AauDVIHICudypdW90gKg1i+
	 /O7xP1C54py/u4vAQ9HwOrpFpDgDavlwS7RifqGNQ/08EjyoDwQryHJ5CUNRkwxwyI
	 vEVynHNmEeQMOPCYxCD/EnfTVlznz2s1VVxLNsvt05OCPHxXJ4cWwjvMUalk3DPNf6
	 axtofMta59BQe4YxhgIX1kVwCyyQhHdCaXEqSzqgsAAY4h4EicqGz3y0miFyy5bAhr
	 5EZKBULryMnbQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_set_hash: GC reaps elements with conncount for dynamic sets only
Date: Tue,  1 Apr 2025 16:27:02 +0200
Message-Id: <20250401142702.1312902-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

conncount has its own GC handler which determines when to reap stale
elements, this convenient for dynamic sets. However, this also reaps
non-dynamic sets with static configurations coming from control plane.
Always run connlimit gc handler but honor feedback to reap element if
this set is dynamic.

Fixes: 290180e2448c ("netfilter: nf_tables: add connlimit support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 8bfac4185ac7..abb0c8ec6371 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -309,7 +309,8 @@ static bool nft_rhash_expr_needs_gc_run(const struct nft_set *set,
 
 	nft_setelem_expr_foreach(expr, elem_expr, size) {
 		if (expr->ops->gc &&
-		    expr->ops->gc(read_pnet(&set->net), expr))
+		    expr->ops->gc(read_pnet(&set->net), expr) &&
+		    set->flags & NFT_SET_EVAL)
 			return true;
 	}
 
-- 
2.30.2

