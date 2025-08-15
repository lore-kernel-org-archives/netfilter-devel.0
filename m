Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6DA2C21C8
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755274184; cv=none; b=YBBNGPMVxr0JQTWn8CQuBxnhfaD5hq9U3w64E90zzGeJsSLR6pBQbrPuumOy0E2Xqdy1Srnqa/V411u4qDQAXkOfSn6YJi5pbc3cSRozixW43CR4CBDhujwdZCIM01aLL+gEbw59ys22o8wEdUEi/HpN03krvh4JfBRvGjTqbFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755274184; c=relaxed/simple;
	bh=ZeJdlBnN42YP5jYwzSAFHSQ3uGpPbhrWUxQBS9TB+DI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fm66AT5ZU7jfmqGOMNne0p9YxC4NZblM6e6BLCnWRqLH5bD3HQIgJnU/fdOfm1ETGx/nXh59I2HyvWrcaFYjhW6y+NXl+MZYdDCVpVU0hCpix5X95w4s5EIlyYalYIN3WOXvnvboGEXb+R/dD25DerTQopfDn8ugWYFOXd4BbSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=OZEnNIcV; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=QxWycW6Y; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="OZEnNIcV";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QxWycW6Y"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755274181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E1C4FcL0TWd5P0VEo3Cyvp9cUqiwlBsqKAI+WAGPBwk=;
	b=OZEnNIcVpGnHPa39lhn9pTYOpsevTa4CCK4ANntev+ThsEy49U183UR/CJTxW7Rk3ugMz2
	9AMMUF22SElc/ec31cr/liBFk+uKT3nsAeWSD8yAVoG13y22H9kr4C0vU2l98Wp79QnxOo
	bdUG464VXGaoRF8fdBUqSa4Rqqh81eEDuTPCcb7WJwiwi7W6/oFT+IrGArUFV8cnKiL5Vt
	Zd7d25SbaRiJs2Adpy5yCQk73DgdHDvPCF0GS3wd10XwM+NiEQ2zESTzvmc2vaGoKhUq2E
	bbxMT38vt0zZe4NiWoOVHBFR5FK0TXFa3go/Xy/rBcx7i3eovC+LoX9xPFO1kw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755274181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E1C4FcL0TWd5P0VEo3Cyvp9cUqiwlBsqKAI+WAGPBwk=;
	b=QxWycW6YRiwM8OzDC0/PiyJH7ltq5YmEPRW93QZcaRSveWD7+10yNewf1YnlyUKfZ/mfUJ
	CC0+BGZJB25g/KCQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nf-next v2 0/3] netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch
Date: Fri, 15 Aug 2025 18:09:34 +0200
Message-ID: <20250815160937.1192748-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The pipapo set type uses a per-CPU scratch buffer which is protected
only by disabling BH. This series reworks the scratch buffer handling and
adds nested-BH locking which is only used on PREEMPT_RT.

v1=E2=80=A6v2: https://lore.kernel.org/all/20250701221304.3846333-1-bigeasy=
@linutronix.de
    - rebase on top of nf-next.

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
2.50.1
