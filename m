Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B49A4973B0
	for <netfilter-devel@vger.kernel.org>; Sat, 10 Oct 2026 12:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791633997; cv=none; b=UPnw+Co4AIXR71NT1lsfTFU001EjZ04dZRl1yo5GrEJ7+adJbVAsfuBt+d/oedGcQbPt/nDiGqZsyrC5y8LgDnzeYlmQy6XePNWnkvCIDwAJzZTZv88V3bIBC/1QigHPDYoxkGkUtiCP5CAeBy+fpZSc8vnG5uxLd6P6oYnGX9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791633997; c=relaxed/simple;
	bh=c6R/HMX9UdwvshKUArbM+BShOO0B0p0jNJq4Z1oLlXQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ra5DogLs3MSvVe/xkaNLDV+vm9OrB0rz4CUFy2PXoLQH332SjrExxd8JxLePTgzAktfAD+bdO+51jFtMBAwheIYeTBteVmC6usH8OfN4xGf66mgcGtsDeh9vlX9/eO59X8WCGvBiiK+0VsCO8wHQk/21vwd1aOhmQgpwON36eQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XBQ7+Qik; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBQ7+Qik"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1635f7c89so5429115e9.2
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Oct 2026 05:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791633992; x=1792238792; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pf93fAStQFQmMPyWTZnqmgHvVU3/s2D82vsfqUoiRMc=;
        b=XBQ7+QikmVoz/PJOWWWMLXAUastRMEGijjmpTay0t1cOOZTBbdWC8NUpv6s1p3ApVJ
         q5LT56oeBWKAblerx3D62ci7iltlvfJq7Md9LwMDlypNsMakftbkspyrCYl+q9JA5fUY
         aFrjC/Kc/hqDWUb6VPSnHyIcMtWWSdaAb2YBILO3z+BMYis9f8MpSc39FdHySN+zLUBQ
         dvHxwEKMeYRtSBFbPlAznipLNblDs1lOkFPLiPY6b3Vt1OM/aFfujRXjTdGyST5cfKLK
         NC93FYs9RrD+zvs8oz//UQouIifuxlotjigxMdsPFBjp2jrGLbxD8HnhNMn4w/T9sPMF
         XqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791633992; x=1792238792;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Pf93fAStQFQmMPyWTZnqmgHvVU3/s2D82vsfqUoiRMc=;
        b=cZ8YUZ/1FoyM/6eRJSq5Ai6a3htQqR2N+HMA5+XnfYoEhGM3XcTxhE2j/c8fU9Gr06
         jaes+VhEXwRLdzjG+AoM2Bwvq6PFKH0dD0zN6qd7rcrhVDi+q8lqoM1a8yKzL0x8Chbi
         YvpCEvHVVZHVEEWixS+Qto1YDriVI8Ize7hOn+7A8rgF58ODIqgki4zOrC34WyYepRfB
         UtTVGo5WJK57bgc0hj/fD0Ko0dWsdhZn3gGqsBiY2utkbk22cWYyVj5V3sWRK3sPtdcR
         DoxzVFJWOR25OtnmZyFPbQZu122tzpiNfa3iJ7e03ukRn9NDQ9gaiSDuNplotsGXmk+q
         2U9g==
X-Forwarded-Encrypted: i=1; AKwUvBwIQtqE893OOJ+C+EIPZGb+UK/blfgk8fOP24eLXHQSwWYM+LkX6ylmkcJ0F2OK/Trzd9ajPOchkaXhtTp2AJg=@vger.kernel.org
X-Gm-Message-State: AFq9FYLkPkvZBtFvW71YpOdP6rydmDuFVAvuo8tpeNh67N1xclgMPetu
	WhRg4xzPREoKgULtpNi1qDMDbI7hux4GJu7pAIwFXsiLnWD/dWSvpFpE
X-Gm-Gg: AYBFou2hN0GH3v7lMr0HSwVz0/UFbckN/xYrWXAB+MDhg5XU9A7HM58aQqkf19I2YUh
	0U8KW3nXmVbuRldADWuaRY2i43IDuxYVrY0UbJosRp7R294LvBOli3qWjh9loI/s/LRgZjnXpJE
	jm26nsFOrIDWRJ/ceWz/scshHrRn8L0QB7HfZapQdcDfB5JsrWAEgn/3sPNKzCvsza3QwDKoGxY
	JelbYQagARql3/xaoNZ+by3w6vn0w0UqsOaeME2l9k5fsU6ODr0NrAhVfnVuzcq1ur2uMtZPpkI
	SJFrCDtAzSI9g+o0r6ZoFEOfncVs2UrYQTK8yN711LvIRgNoDrTqhQ1Eim92mI+l9/c6dnUYQlL
	ihnyJYQvd0xAeOpfD6EzK12PM7z3ksEAgzJNeNnfvpOMBnbtiAhItWHwRqTPqOZBoNOgQlcm1Hz
	rv9mGZvyPj+kMD1MM6LPiA0xtYmrl4FYOgyw07scfT8FXu9GwyEHsODAD7QYSaYzucDwnrNaGzi
	X5mkrRf3B/JGrqdYAsKxoFDiePSRnXK8tTAiMG6pWTL4M9f8PXQFV5xwjg3CU48B5gmFr0Y30Kn
	LFkSYNz5iGWJR9P2cHlOFr0uyDsaIR18TnJISlYBW1GKzyhVr69PHSti52wmYkFGjGf42P6ujEQ
	=
X-Received: by 2002:a05:600c:8209:b0:4a0:2375:dc1a with SMTP id 5b1f17b1804b1-4a18e4cb771mr86143615e9.21.1791633992086;
        Sat, 10 Oct 2026 05:06:32 -0700 (PDT)
Received: from imx93-evk.localdomain (dynamic-2a02-3100-9d3f-0d01-48c7-5d76-0ec6-9dac.310.pool.telefonica.de. [2a02:3100:9d3f:d01:48c7:5d76:ec6:9dac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18beabbd0sm150904195e9.12.2026.10.10.05.06.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 05:06:30 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: stable@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mukul Sikka <mukul.sikka@broadcom.com>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>,
	Bin Lan <lanbincn@139.com>,
	XiaoHua Wang <561399680@139.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1.y v2] netfilter: nft_set_pipapo: restore cloned mapping table memcg accounting
Date: Sat, 10 Oct 2026 14:06:24 +0200
Message-Id: <20261010120624.4946-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The 6.1.y backport of commit 69e687cea79f
("netfilter: nf_tables: missing objects with no memcg accounting")
changed the pipapo_clone() mapping-table allocation to
GFP_KERNEL_ACCOUNT.

The later stable backport of commit 07ace0bbe03b ("netfilter:
nft_set_pipapo: do not rely on ZERO_SIZE_PTR") rewrote this allocation
and changed the flag back to GFP_KERNEL. Upstream applied the
ZERO_SIZE_PTR change before the memcg accounting change and retains
GFP_KERNEL_ACCOUNT after both.

nft_pipapo_deactivate() clones a populated set before looking up an
element to delete. If the element is absent, priv->dirty remains false
and the clone is retained. Its mapping tables therefore remain allocated
without being charged to the requesting memory cgroup.

Restore GFP_KERNEL_ACCOUNT for the cloned mapping table.

Fixes: a4983e89e3b1 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Changes in v2:
- Split the combined 6.1.y/6.6.y submission into one email per branch.
- Keep only the Fixes tag for this branch.
- Refresh the diff against 6.1.189; the code change is unchanged.
- Add fresh build, runtime and matched A/B results for this branch.

Original submission:
https://lore.kernel.org/r/20260831194905.45045-1-kmehltretter@gmail.com/

Testing on 6.1.189: built a minimal x86_64 kernel with GCC 15.2.0
and booted it in QEMU with CONFIG_MEMCG=y. A 64-element two-field
interval set passed creation, lookup, update, rollback, deletion, flush
and reuse checks.

Matched unpatched and patched boots used the same kernel configuration
and initramfs. During a normal update from a memory cgroup, both cloned
mapping-table allocations (512 bytes each) had accounted=false without
the patch. With the patch, both used GFP_KERNEL_ACCOUNT and had
accounted=true. Both variants passed normal set operations without
kernel warnings.

Earlier A/B testing on 6.1.186 and 6.6.155 measured 524,288 additional
charged bytes for the cloned mapping tables of a 32,768-element two-field
set. An unmodified 6.12.107 control already accounted that allocation.

 net/netfilter/nft_set_pipapo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 4b37c6684bff..456779003f58 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1466,7 +1466,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 				goto out_mt;
 
 			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt),
-						 GFP_KERNEL);
+						 GFP_KERNEL_ACCOUNT);
 			if (!dst->mt)
 				goto out_mt;
 
