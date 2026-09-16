Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAA43BD25E;
	Wed, 16 Sep 2026 01:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789523562; cv=none; b=CCEYNzVaGNgNCHg20/976NEKQqkMaH6zHb76k7tix96V+b50fs0b/aMjNAdjkxi7un4V7f0F+Ey3gZeRLNTO7BzHnDmpw1Z/25f7TR4AZO6UuUX1VLjN0rtdU13arE48xcTZ3YyjzI084eCyPg53ODtgPRJY7yM/N8GdyzeBaGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789523562; c=relaxed/simple;
	bh=S96SCCQMhEjwnXlFBOZIjSxxFW0f0No2NroXewdITh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wlc7byvfV9UTlwd4l3N1JQsjs6VBrpoDWEe+UCYPaEfMz19xypQyHMFM3ink2sI5ARb2TLlYMqStonIyYYXGJ63EDdcITXJovwEwHKlTP/ND9RVJEkCzAVCu7t3pT4bPfQEURhU7r14cpB14c2Ljv2FO3M+kuwPJcP8sZHUKvq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aYH0HZ+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYH0HZ+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B291F0089B;
	Wed, 16 Sep 2026 01:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789523548;
	bh=n/YREz5Yu4jOuw8ePgf3Z/ncnOGAJxvm8jhdmX8CkHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aYH0HZ+iSxcKu1Hg9jheC2cDtHcGdh7p82d1tO1IdgH9FKQARBdOSefdXlr9wBgO1
	 fJ3ml3HTZlgSibz67gQkO7/15v8Ssxfao45iPIWsntOeeKg7uGHi7c/o+dtHYrnxgW
	 XT2gUumHSDs1QbseVF5a9WIDTAoKqUVEQ6Plelq9Aps3IDjBDd5k3N+ivmNqzPU6TE
	 aNUxtJRlHMWt4EbaiJQUS9B6oAgI+Wa721dJwxzzboNECGC8TWNlv/cZFBwCBp7tHW
	 Shzc5yxHmQ9S2l1qxQtY4nUik3obl1P6D+RswgqtFOavjctPw/kk6/2d170dU0uQsd
	 lMn6o8b779NiA==
From: Sasha Levin <sashal@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Wei Wang <weiwan@google.com>,
	Martin KaFai Lau <kafai@fb.com>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	David Ahern <dsahern@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Miguel Gazquez <miguel.gazquez@bootlin.com>
Subject: Re: [PATCH v6.1.y 4/4] ipv4: start using dst_dev_rcu()
Date: Tue, 15 Sep 2026 21:52:10 -0400
Message-ID: <daily-reply-20260915-0005-re-ipv4-dst-dev-rcu-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <823f66b1-5a3c-4ca2-812a-de2c5281c49e@bootlin.com>
References: <823f66b1-5a3c-4ca2-812a-de2c5281c49e@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The 6.6 backport were merged in 6.6.157. Would it be possible to merge 
> the 6.1 version ?

Queued the series for 6.1, thanks.

-- 
Thanks,
Sasha
