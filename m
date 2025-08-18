Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF382765C2
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 11:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755514940; cv=none; b=uEb+R7cD8tewQcnr+iSE4ZrL/qDtpA1sCZPdGDhaZqym4ms+Bcaq4llKN9qtm7ERZKD6MvgKlU2w8IXxhsNcu6rxlM2W3wnvHCL7GWozpOmz5QFlTdwcE5ARyIe3x8Sb8ZQpyy6lca3m1T5fPrs7rrlinUd+CI+UMTXcev+1sVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755514940; c=relaxed/simple;
	bh=L7DA7DmrRFoFkqNgrgchXI4eLdMP5rncHq4S6jVAJ5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cwlT/fMpSwOYsSqCBGEuTcU6LkI1c8q6gcsdtbr8hQp/7WQqn6U6TAmZ4LjUZ1FnKC/h/p6svXpUlQeLXn/9gd6JbjDy9pZxh05xoYstdbG9ZNLbK5EN/O4WWXH/LTOYVjoxrm0phTtgEsc7V+lqb4jYTAnAg5BetAdA80a3XDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1TPtC+ix; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Mt2k0/7W; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1TPtC+ix";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Mt2k0/7W"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755514937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S4YWN3QJev/isMbAsgFhDSIaXyNM4p5tqig8ROVw3Lw=;
	b=1TPtC+ix3JydGJIAOddZkLWK9FDY0vJ4VC5h2Sd7zVkpJlTQfB8X2MfuzOeVIWNQdTTFLG
	d0xavlS/ZepP4PskI7jwvVkyEriY0gmZnMKXTbiaAZQfFoQWKqNhvzstiHor+bSQwgiD19
	RqTrDcVclGB19shYCrcBGxGl20gcrhDI5zjh1quFZd3N+NpBxmK5VzEAxTDlfWT5cA5kkh
	zUgmcZnuUmqp7k9ht+x516WNyGn0DdT7TuESNkNyPUARo9Xu07K6xhpJ7TfIXLd/3ZUD1f
	fHbj6lHu7+dBA5YHqhjPfwlKBVKg+iylbWvuaGRTCPsuVKBHJ/p5mI0oI0nc+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755514937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S4YWN3QJev/isMbAsgFhDSIaXyNM4p5tqig8ROVw3Lw=;
	b=Mt2k0/7W8l1AoeconGEVUoom99OQ3339/BZFMq54/uSUTtT7b49hbtZwP2/sCIqS69wfh4
	29n5Vfakmdu3yEDA==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nft-testing v3 0/2] netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch
Date: Mon, 18 Aug 2025 13:02:11 +0200
Message-ID: <20250818110213.1319982-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The pipapo set type uses a per-CPU scratch buffer which is protected
only by disabling BH. This series adds nested-BH locking which is only
used on PREEMPT_RT.

v2=E2=80=A6v3: https://lore.kernel.org/all/20250815160937.1192748-1-bigeasy=
@linutronix.de
     - dropped applied patches while rebasing to nf-testing
     - move kernel_fpu_begin() to one place so the locks need to be
       added in spot.
=20
v1=E2=80=A6v2: https://lore.kernel.org/all/20250701221304.3846333-1-bigeasy=
@linutronix.de
     - rebase on top of nf-next.

Sebastian Andrzej Siewior (2):
  netfilter: nft_set_pipapo*: Move FPU handling to pipapo_get_avx2()
  netfilter: nft_set_pipapo: Use nested-BH locking for
    nft_pipapo_scratch

 net/netfilter/nft_set_pipapo.c      |  7 +++++--
 net/netfilter/nft_set_pipapo.h      |  1 +
 net/netfilter/nft_set_pipapo_avx2.c | 19 +++++++++++++------
 3 files changed, 19 insertions(+), 8 deletions(-)

--=20
2.50.1
