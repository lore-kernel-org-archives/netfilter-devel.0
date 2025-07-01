Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634D3218ADC
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 22:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751407992; cv=none; b=Dwso+h1DSD52l+9nzxukkSXMOkzOnyBr/fQAs/mXAiDY2F+meOBjLgooCuTFmGPQaipXBgYrjuSWtVJ0bgovih1W9/83ccVeu0y+erC7+eJTicQZc9bXB0YTSIhhhpOx7LTYkIMBnJzQxBqDKLNkkoYSJTwTyfT9g7wGszoxItU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751407992; c=relaxed/simple;
	bh=3JwnaM/UJ6kumdtoZVY5llEeNo1fIH6Y3f9krTVPJ5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aq4v/irDzOYiThAHNvOKirUfyiNv3NNvwO+mmnC2pqTiZbOOrhEvDWW3tEB4KF+XkZVoLau9AbdBjfF3E60hVyxV9U9L7RHzr/An3QzqCadqou2dkGHPcNRn0n33NZ7aA0mJzYrhvHGCd/zl470vxI0V+BP7hJRFnVSPSQ9dWQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=g0i5YbCr; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=W2wCKCnr; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="g0i5YbCr";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="W2wCKCnr"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751407989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ORcAEKOAXhqe1UhaME2h4j2Qs3l2C44gW6sWmDaNFDA=;
	b=g0i5YbCrYzB2/SCaahT1jGucLpHcVL5I+Jz2CowHkF44bvo3LYo9y8ez6Ms6oLVfduenAd
	uEsyeHOWTfUz9E+emaS1t1G62L4LtqvB3tbVpJ22w4Ei2zMlCTfgYGyeRu962H/xIHG86k
	9gJi8KxjSInoxEX7uyTRWEj2zx6JTSe9/RKDbG8Vwh7JD7yIX1CJkLJ7SgziX6HqqilDI0
	9AWLytdbuWY8YKU7DlmoT35DJAOzLlqDGCDKGjbdzyiLQsCDhds+PyfqPplD3VqN1Y5zFM
	jUNJy2jfrFVvwKbSX3fRdr6U6pvRHB/dfw6+OFhO7egSaEifX9nfx8tRqETH8g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751407989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ORcAEKOAXhqe1UhaME2h4j2Qs3l2C44gW6sWmDaNFDA=;
	b=W2wCKCnrhX5i/BI5LbVm5oqwuFslecYrLHj19mXkbf/3IlVZWH6NnwjOBmWb7FkDX8q5VP
	zsez+2K5055T+VDQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nf-next 0/3] netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch
Date: Wed,  2 Jul 2025 00:13:01 +0200
Message-ID: <20250701221304.3846333-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The pipapo set type uses a per-CPU scratch buffer which is protected
only by disabling BH. This series reworks the scratch buffer handlingand
adds nested-BH locking which is only used on PREEMPT_RT.

This series requires a reworked __local_lock_nested_bh() which can be
pulled in via
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git local-lock-for-=
net

It has been made available so that the netfilter changes can go
independantly of the TIP tree changes.

Sebastian Andrzej Siewior (3):
  netfilter: nft_set_pipapo: Store real pointer, adjust later.
  netfilter: nft_set_pipapo_avx2: Drop the comment regarding protection
  netfilter: nft_set_pipapo: Use nested-BH locking for
    nft_pipapo_scratch

 net/netfilter/nft_set_pipapo.c      | 45 +++++++++--------------------
 net/netfilter/nft_set_pipapo.h      |  6 ++--
 net/netfilter/nft_set_pipapo_avx2.c | 27 ++++++++---------
 3 files changed, 28 insertions(+), 50 deletions(-)

--=20
2.50.0

