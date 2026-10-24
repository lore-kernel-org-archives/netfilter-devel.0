Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792872704;
	b=HMd2ZKWG5+gIJ8g6xeLTqg5k52n1qeXx5OcBANoWhiwFTuhAqd1v9GXR2jIL1K3VVMXQ
	 IwU2c4D6z0oEJxlTeqFzKGc8tkaKMWPbcLE5xNEjSfbVSaNbXpe9oXCNfuWY4uFl/EBMR
	 aT+VR5cP2Lr85p9w22Hb7EWhtPFUX8jYfid1J0nygE2iabaoHswJv2UumSy+a7pgRPpGp
	 K1HHfCXanEjQ07sji6BozTtUB35VCXRO8Df4hG3N8kZR36Utz6zqp7ZoRPqqTHzpf3Ujy
	 H4ZTRjqTVqnq1HzYsZauekirXMSMnKGeX4U38/I7yfFFYLoQ/yuMwVe6Z+T7iubNF7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792872704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=//fvzA8kbQyZa3SpAFB/ooiGxjzKhbptuzdSrnozyWw=;
	b=krhLZ5VSgvT2Tjr0DlWvhjrSmJY0ZAHbMY0dSsoK1NXB/OSRbN/QA/EKAMAlx/ymogq1
	 8R8tbw7A5gw/xO0p+x3Ec5Yrd9OsQPh6JL2v9BYx8tMeaM0txituiWWrqgGyX/kgFilNc
	 cE9pB3vet5FxMpVN10chQQVFyFKEyAbEw87jm4yXt30JUoOM/OVfjGJ92wFYfdpV5iA5T
	 x44LSInkgxh3W077hFUBkcAIVKce7JenJKmDxqP7amFim/uH5HIhi7p54U/CJYmf3SHYr
	 t8uS02iRd4lwmwHAmv+hTpmQykJQuKEK9NxKbltf58XDPVXh0lBVvKvVCUG3xSXBFYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X5u5ng1t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C18B606A31A;
	Sat, 24 Oct 2026 20:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X5u5ng1t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEB31F01828;
	Sat, 24 Oct 2026 20:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792872704;
	bh=//fvzA8kbQyZa3SpAFB/ooiGxjzKhbptuzdSrnozyWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5u5ng1tBKWLv4XR/kwlCR+SPNG5Cz3heQvlnDBZryJx2c5cuKtxAc2lGpLaz/ygP
	 i9zxZ0GbBGTukAPOZtDogkN5B972VUgsltuKld8aUd1hYp/kxhQypsVVcNu82vDS+b
	 gzmTczwHQOODF4QNDWnl7Izw9vu/E59r/gvlGalQOGUNvLnxXpwpeB8SWEAhlJFd0P
	 d0ACuR9yn5KNhZfPB6tOr4qPMwz8AUeLL0rqlWeX7wZMZBgNC4mJIFK6A87kFXpJNO
	 rWyzYnLfABlkWjfS3wpyW/1c0Nr7MxLniMFZkkck350FMGPulTBFx2lDx0Di//oHo4
	 jq/7081wAnR3A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Subject: Re: [PATCH 5.15.y] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Sat, 24 Oct 2026 16:11:17 -0400
Message-ID: <2026-10-24-1-daily-reply-0020-nft-addchain-uaf-5-15-bounce@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261024124926.5225-1-steffen.pfendtner@kernelscan.io>
References: <20261024124926.5225-1-steffen.pfendtner@kernelscan.io>
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

> [ Backport to 5.15.y: 5.15 lacks d472e9853d7b ("netfilter: nf_tables:
>   register hooks last when adding new chain/flowtable"), so the hooks are
>   registered before the chain is added to table->chains and there is no
>   err_register_hook label.

This is a custom stable-only fix rather than a backport of
71e99ee20fc3 ("netfilter: nf_tables: fix use-after-free in
nf_tables_addchain()"): the synchronize_rcu() goes in the register_hook
failure branch instead of upstream's err_register_hook label, and only the
packet-path half of the upstream commit applies on this tree.

A change like that needs an ack from a netfilter maintainer on the thread
before stable takes it. Pablo, Florian: could you take a look? Please resend
with the ack once you have it.

-- 
Thanks,
Sasha
