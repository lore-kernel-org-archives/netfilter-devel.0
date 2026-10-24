Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792872699;
	b=s/N77hOVsLvZD34kCEW9YhgvfFWAn42VCoRbEPv/jXAqx83WFdNN1KPudYcIvP6nf+hj
	 vl67J1qaaeVOZ1cAlvgTNmLNbB2SHRo/Hi7OI12qDrXfxz7aHDEDJtOGh4kYvV4i6FIuW
	 9IP4pAa5+uaby99reVO1RNQzn+r/y5OZUEPBu4qNzQdALzNRjLi/JyW0/u3ydluaGCCmu
	 1gbmT9P0KGlyzWRXIcyNoJgp2Gyh2RZw8UxtCLk7/MOkW7nUT5dKsfprI/gX9M6GRsZAd
	 KevUaiqC1A11iiKYZyEilCpoKdVc2tL/QXWZFzUEgBkmv/dyaYrZZxMrQwsyguNlUkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792872699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=YfVzyXmiR2nJpJ3XKPrgobh9BEn9GXJgi7lwRKpXnIo=;
	b=LyQLdmCFDrwwwaMSfUTLD0Mvwl8IV/ERQoi2XC5NzpOlY4DD8V/i2ofqb0rfv4pfuWU9
	 vCXA2qtEnxIPohqU13H8+PtGf0kwaaWAu5N+3/WJnKvbouP+eFVMD7+97MoXKwrZLtgBt
	 bFcixCGLA72GVu/OeaYfZpddYNmRuNWXSEQQSHb6F5PbESvO7r+HLi4rMHTT9D9aaUQZw
	 FIjasu3vGMa42RVKHh1xdimhz2cCuZ3rmWVkd2vJ51JSFFw53C5OFEamwq/UncwC4aTab
	 P9aggZrduvBor/+Ojflu7vziYkTUZEvnQ/saglytaDk84djD6J2TYulAKMJccRu8aiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RuyQceAa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471CE606A31E;
	Sat, 24 Oct 2026 20:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RuyQceAa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708AF1F031E0;
	Sat, 24 Oct 2026 20:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792872699;
	bh=YfVzyXmiR2nJpJ3XKPrgobh9BEn9GXJgi7lwRKpXnIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuyQceAaLFQLgMCntuY4YJHeqPW8oUFH9VX6OnjQfhi8CCy97hOXue+qt/v9fwDbr
	 RHzNp2pSDQaAGgi7uhSgYn4KIDKQSN9C1VFzMqfwfpA7Hg2xAo9m1blSAO3jcz/fEi
	 huHudG/U3M87PhCecGQN9wv+U3qVrpEJxvf948vOqQY+d0DBZEFPqlEB9kie46BaEc
	 QHMTVSyK8CvsrLaXnrvWpMhnY4XAlh82kq+uSkTwvxwL+xTWFoQOV28gs5C82PxEfH
	 X98pMa7NU1TxelQB6tOa1PzoRDBXh3wRJodxgv81ikSj7h7rHU9k2geOY5r9LlS3hS
	 gDP373UX5Rsvw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Subject: Re: [PATCH 5.10.y] netfilter: nf_tables: release flowtable after rcu grace period on error
Date: Sat, 24 Oct 2026 16:11:12 -0400
Message-ID: <2026-10-24-1-daily-reply-0015-nft-flowtable-rcu-grace-5-10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261024124931.5443-1-steffen.pfendtner@kernelscan.io>
References: <20261024124931.5443-1-steffen.pfendtner@kernelscan.io>
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

> Call synchronize_rcu() after unregistering the hooks from error path,
> since a hook that already refers to this flowtable can be already
> registered, exposing this flowtable to packet path and nfnetlink_hook
> control plane.

Queued for 5.10, thanks.

-- 
Thanks,
Sasha
