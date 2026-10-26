Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792987030;
	b=PJQxKgNunA+TzAIOSQa9oeUS2/hCVXbeqKm8BWAUx0PTO8fLSmakD/kUG6t0wbqmH4ge
	 73afu/9agZeTXr3rPDFjNsJib/nB5v9zpcCofoE0ic0Gtlf98v+HuwxYoR2TxpRU4y125
	 gfWT+eGQ9xkIzK4+kK7f8amqIa8ZPYLAuuDXauCEgME6x4w/bt5oraBa320408cCFpEBm
	 in/LLp/f0a3GqNRO3DORXa58zTgOXMIi2M7puczjoAXE0RbEXnl/NECwUKQJMQCQW50A6
	 ld2yGbcwNonPPMAcShb654oXUv+qupIYwPsjNEu5Suw53hIEx2hW5L9PR01nbfNyvgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792987030;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+ScCUUWyJM//qpTpz7tt0Fdxp9XvYrNhMa0jbjZM+Ng=;
	b=G6agzp1HZrdZb0kiHU2vZoeGdOMW+ziv1/cd8zfLeLT4os5NQiurm/0Y+psbjA9T9ulV
	 E5/S2Y5jrn0S/pikeYBWI6cQW/PlpHrtSZJ+gGNKAgxJS3JN/U7GmGucI7J3YfPm2cBck
	 ngWviSkWClGm1knrd83e4x5pZaH7zOFeHs05462p+1GIMkWBav7fQJdCVcxSp7VTxB/bF
	 HCrJaBJKbxW7veJJJlTt97thdKa6jJz2Em9epNfWZwgk6pQTSntcjk7wnDYnWU76ptkzS
	 150SXsZ3y64SzFvBEti0pYCrch6D+BuRRhrLurX7jIxBaYu7rEn2NPJSbslDqlB3LwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CzHL8JAA;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C861606A31E
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Oct 2026 03:57:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C861606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CzHL8JAA
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36681e85e87so538400eec.1
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2026 20:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792987029; x=1793591829; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+ScCUUWyJM//qpTpz7tt0Fdxp9XvYrNhMa0jbjZM+Ng=;
        b=CzHL8JAAhVXZp+BFIea6XXS5CXvIdKyvTb9rotyb9xP51zqNOdUyULSyK62QT2G7qO
         7v7qzFb4ekjP8THGtkchX7EdobigL2eBQbw+WhyrhbXrSIQnzUg+mhL33OKcdQw/kCOl
         zq1zDO6mrkZUzmX7FZqHcqcNncLTFdoz8LPdi0HLuB1F1rfz8enfQHRYXYoq422/oXFK
         mPtlgYSvIeU9kcWQBdlA3APCubO0DXLc4kb8YveBwZWFD9FPg86N0L1cKM2rfH9DDam2
         E2jObCINjT2AdecrPCYLiQbyEsbP7oepRFvC9D5xQPmCjEWHmKY3xEsXTQ/XabPJaAj2
         pxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792987029; x=1793591829;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+ScCUUWyJM//qpTpz7tt0Fdxp9XvYrNhMa0jbjZM+Ng=;
        b=QtrHFvyqTnEkXVmx9yDQYH4ynVvr3TEIAeGPR8I9Xl7B9XleHeTXy3/0HnjBf/T50V
         DizauJMMwrOKpuuh3fCidJtRZE5BLAWAjSAMoRMGrbVmEOJd7RfnvKStrPgqfjo9/Gec
         c3EV70V6fq3sgnLOm2s2zBkBsEtr56JtdC86skxJ3E/N0nBYqL+140OpilNx7dxU0Dk3
         rBMkbsJRBoS+rCw75fxpH5mfL0nEGnnzVwKJej7aEdG0sHhkk+HXQKIMrmECKNg7tHYP
         SvsJTg55ZenuYUz2Z17hurrE0g+BHprd7k3G79kmNDvNfEW1Mlcy+2GvMhvsoLRHggtg
         hScA==
X-Forwarded-Encrypted: i=1; AKwUvBwP9get7cjm7TYfWaKb8A+anHuWwtvZtCu4OaXXUcsTFr5QF+fbURszsEaoUk4qE1TnfnjuNvW0/ao0McXV+FU=@vger.kernel.org
X-Gm-Message-State: AFq9FYKBPOcjbdSD/EeMaAtS4Cyaefx+U1870BT0Hd01EjTq0ehWbaEV
	318Xi1wYtqjp5dTwtCKHeR3OEbhf+MT9T8SSP3WD7z52Vq8mT4X7B4Qa7jwOAqEqpZf8+w==
X-Gm-Gg: AYBFou22briuzVz38yLYNM7In/RhPLp44uT5PjOK0JoBqNyir2fc7X1OM1Qohw7P0gL
	DEdh3rmqckcwR4fNUNRlOgZ1Ro5PBf5rN9Vlp1cnAjQox7qQfLbhr36Ca6Fh3clTDFIwrZe2TXV
	bvsZATGhgZ865Lud4WcOLAscjyYGn0NOq6zrFcYPKTIa8MUXrkv5Gv75r5P696zQ0BRKFqyc8eM
	LfvYr0heMVKtyWelD0f3i2/jO1aUxZATJBXhC+WSXDZwwV8DbhlksVBg/RECqMeqqiyhOz/7DLv
	RZYmoJZrVNpdDj2u+/S9GGVgq7sLbv9oLOrBZsMDbU50V1tJgIQJXES3cH9e6m5gavgxLbWCTzR
	q9Wv0ZvQG+QPn7IVIdiK0ki4ThwHNBrE5M4wh1JffE/4xydjVBFKcLmrodnc5g2Lf03nosh0nzb
	46UC7InlsCds2yqBq45gUhoIa8Hpuo97TcoWjGTBZ7RS1Moi9Z+HSgpzX8JAv2GfrM6c3CazH9f
	SNeZCTKfnhmTUirY/7Ej58HU+cj09UPBgoMNGlMBmIGroyOlGD8AvBZ6ZpXx5BpzOF3DlhnHkFd
	AJAZjon7ylXpqXu/6fVcDLuerPNQHwCm0Uiy9pdXXRSPr3LNCNE97rDnbqE99W12SiwrWDSX
X-Received: by 2002:a05:7300:f0ce:b0:366:846a:e21d with SMTP id 5a478bee46e88-369e84d35c0mr9182619eec.33.1792987028486;
        Sun, 25 Oct 2026 20:57:08 -0700 (PDT)
Received: from MacBookPro.lan (113x35x113x191.ap113.ftth.ucom.ne.jp. [113.35.113.191])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d93663sm24441240eec.13.2026.10.25.20.57.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 25 Oct 2026 20:57:08 -0700 (PDT)
From: =?UTF-8?q?Paul-Louis=20Charri=C3=A8re?= <plcharriere@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Jalen <jalen.lin@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	regressions@lists.linux.dev,
	=?UTF-8?q?Paul-Louis=20Charri=C3=A8re?= <plcharriere@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: remove hardware flows before unbinding
Date: Mon, 26 Oct 2026 12:56:51 +0900
Message-ID: <20261026035651.40052-1-plcharriere@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CAHqkChbVoGHrWtaFyGFaLQDiAunWw1qOpW-vKSgkKxWEfQ_tCg@mail.gmail.com>
References: <CAHqkChbVoGHrWtaFyGFaLQDiAunWw1qOpW-vKSgkKxWEfQ_tCg@mail.gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable
binding"), FLOW_BLOCK_UNBIND is called when the flowtable hooks are
unregistered, in the commit phase, and nf_flow_table_free() only tears
the flows down later.  Their FLOW_CLS_DESTROY requests then find no
block callback, so the rules stay in hardware: the flows keep being
forwarded, and drivers such as mtk_eth_soc and mlx5 keep their entries
and reject a later flow with the same cookie with -EEXIST.
Commit 5acab91458ce ("netfilter: nf_tables: unbind callbacks from
flowtable destroy path") had placed the unbind after nf_flow_table_free()
for this reason.

Remove the flows of the device from the hardware in
nf_flow_table_offload_setup() before unbinding it, as
nf_flow_table_indr_cleanup() does for indirect blocks.  The GC run that
nf_flow_table_gc_cleanup() waits for may skip flows with pending offload
work, or have started before the teardown, so queue the GC work once
more, wait for it and flush the delete work again.  A direct
nf_flow_table_gc_run() would race with the GC worker.  No BIND or
UNBIND call is added.

Found on a router with mtk_eth_soc flow offloading, where each firewall
reload left the flows of the old flowtable bound in the PPE.  Jalen
reproduced it on mainline with mtk_eth_soc and mlx5 and tested this
change on both, see the report.  Build-tested with W=1 and sparse on
arm64 and x86_64.  In an arm64 guest with lockdep and KASAN, with TCP
flows through an offload flowtable on netdevsim ports, the delete work
of a deleted flowtable now runs before FLOW_BLOCK_UNBIND returns instead
of after it, and nft_offload.sh passes.

Fixes: 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable binding")
Reported-by: Jalen <jalen.lin@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/CAHqkChbVoGHrWtaFyGFaLQDiAunWw1qOpW-vKSgkKxWEfQ_tCg@mail.gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Paul-Louis Charrière <plcharriere@gmail.com>
---
 net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e..3844a23af5b 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1279,6 +1279,19 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	if (!nf_flowtable_hw_offload(flowtable))
 		return nf_flow_offload_xdp_setup(flowtable, dev, cmd);
 
+	/* Hardware rules are deleted through the block callbacks, so delete
+	 * the rules of this device's flows before unbinding it.  Run the GC
+	 * twice: the first run may skip flows with pending offload work, or
+	 * have started before the teardown.
+	 */
+	if (cmd == FLOW_BLOCK_UNBIND) {
+		nf_flow_table_gc_cleanup(flowtable, dev);
+		mod_delayed_work(system_power_efficient_wq,
+				 &flowtable->gc_work, 0);
+		flush_delayed_work(&flowtable->gc_work);
+		flush_workqueue(nf_flow_offload_del_wq);
+	}
+
 	if (dev->netdev_ops->ndo_setup_tc)
 		err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd,
 						&extack);

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.39.5

