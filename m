Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792872695;
	b=e38gJltxRmNHHf0+8Ubafqy2/6u1A9ufUzwMcyvMfvZ9I1aIOT5rX77TDPa7dJ1O2w1p
	 KHcScMCaDKEeVxiDLK6W1Di46SaRnLO+me3KyQOKBfe909GBhi8dQah9cIXMA2J+H2W94
	 GoQ26TjAyoYrN/1Xu5hXTPfO8eMo0IW80JYcpwaZGT/AFJgBVPC1orE12xRWARMDj8qJ8
	 OeWVjxbUg2SQNqXMW5MVqJp8jYAhFzNWCts0pZ5No5MITkWo8jEloyLTbD5HjBC8aKDJV
	 7BWscb44Hb8lQ/9piLCWk4yI66SZg+yp1ZPnYU1fCsoPSdRGraQ+WtxlatqC5DfbuHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792872695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=S9I31SJcXPNYb4HfBVZgbTD4XI1Km5egr1nEMyGBnSQ=;
	b=x2dgtvk1t6MM1E6lIXR1XgIXGDcV/Y98QUzZctk0Ewp3YAVBmCgHo8+x0+eN8G2fG2o4
	 uEgVtk70XHkvEfh8O2mJWFkMsfeUEGvln+RtVe6Bs2tFmFDnI1efL5RXk7SRqIGDDFFdn
	 LkpLglR8iYA5VgN/giJl1aJK2o3+sHtK55lTkw5/Qw+/KuFNoX14Nmc7MxJVFfMWX4KbF
	 5pnI/P3nRylOelk4n78sDPtz0d7/poAWe4i5Ahzt76l35x/TW411pNQIQtfN5EYiAKca5
	 CspQGYn6eLAVYw5bjJwP0VBIkxjJ65xe/GTB0Fxk9KOHOdsXblhhp3YkZu6PdWrxkUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DhMa5ck2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95260606A31D;
	Sat, 24 Oct 2026 20:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DhMa5ck2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2B71F031E1;
	Sat, 24 Oct 2026 20:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792872695;
	bh=S9I31SJcXPNYb4HfBVZgbTD4XI1Km5egr1nEMyGBnSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhMa5ck2GjxP77YHl7F/hyskFRNYhCwMATbi2P6+LB13bRz5z7J7tkwVUe6e2LI8y
	 6VCmTqIxeXc9qz4evF63VMOyDYhTSyEUXcbefveret62XNingWEZ54QJIM9oXdbxeX
	 CplRr/ZMZ0EJI9gO6nQPYGzogvQ95z+GTvRGanalsY5UZx9rLDILaMDaNK5dc7Vi7/
	 1abP6dxcrw9+tRpiFZqs8B5w4Ssc546spzyLuLiTtz7P3q2kPPbH0QlKsmWmLbjAKu
	 2tlojqlZHDBAQKoVP2pf23IATYzCv+chFshtxESSFXxDos/0kSzz9x0TVYsikYJ5HF
	 B3x742r2f0obA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Subject: Re: [PATCH 5.10.y] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Sat, 24 Oct 2026 16:11:08 -0400
Message-ID: <2026-10-24-1-daily-reply-0010-nft-set-nelems-5-10-bounce@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261024111611.51303-1-steffen.pfendtner@kernelscan.io>
References: <20261024111611.51303-1-steffen.pfendtner@kernelscan.io>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Upstream commit def602e498a4f951da95c95b1b8ce8ae68aa733a ]
>
> In case that the set is full, a new element gets published then removed
> without waiting for the RCU grace period, while RCU reader can be
> walking over it already.

The patch has no in-body "From: Pablo Neira Ayuso <pablo@netfilter.org>"
line, so git am records you as the author. Please add it so his authorship
is preserved.

It also needs the prerequisite d4b7f29eb85c ("netfilter: nf_tables: always
increment set element count"), as the 6.1 backport has it. Without it
set->nelems can go negative, and the new unsigned nelems > max comparison can
then return a spurious -ENFILE on dynset-bound sets.

Could you send a v2 with both fixed?

-- 
Thanks,
Sasha
