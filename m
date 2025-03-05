Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8800415575B;
	Wed,  5 Mar 2025 01:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741139917; cv=none; b=oxuX/EGNMGkpPhqItMPSM8H7+13Sop73GkwfTZO3EPBlupTLct5cZkIl1NLelH2Mgw1hT/4EPESAr9N0ldHtmXO/sgQEn8yBcq9t2jRmMi08BGmDofCjk8WH4D5hjAqS/36Lm/O7olZe+b4ce0QFd62sip6ufTc1s8nQ2/gofMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741139917; c=relaxed/simple;
	bh=faPPTc6fEqFkFFgMOn0XiUUr2KwsjokpKxnGBmLUfb4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NxbwM4yN96GZpEuswSMRJusM6hEnNfWdrk4EYX2hAd7RjtmjFbhVS6C6nAsddjj6p3EzR2LaNK0EPn7NU6fIUDA0/1Mp1Lt3nWO0W9c3iRChnuiHADPRcFWMfRAMEKC6PP1Pgs/O2NF8SrCL8aa6FFTlRhpsGME+nT521i2ltlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BaX8Oa72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BaX8Oa72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964B6C4CEE5;
	Wed,  5 Mar 2025 01:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741139917;
	bh=faPPTc6fEqFkFFgMOn0XiUUr2KwsjokpKxnGBmLUfb4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BaX8Oa727DhaBLVOvWypoECVFTTcmn6+Wx3yBzMVT6rm7vhjZLt3VJHewLq0r1Y4c
	 QtFWcquZ/i9LIVonDQaO3cuQsC5t8rWZ1W03jRgIwZFiJ+ZgRtIboC7S2URCj+UaEo
	 dvOVJCsvqim32rLbUhnX4DbVsM0mu9cAMoqTBdzKDS2a/yHoUY5EQtdmsMVHlEpgQK
	 Dy/83nzSNqk8XVhbipHuO+T5mHBrMDcHuS6UfPgDmRcx6gpNHqdfle3WBOdIoeMZOA
	 RyTkq0EAcgIT1eAq7dLfE1itPJlInCwUB/hRAzzwJWV7xN1kpSHVYrr7JFKSeCj/uU
	 AVTFBSIxa/cvQ==
Date: Tue, 4 Mar 2025 17:58:34 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Michal Ostrowski <mostrows@earthlink.net>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef
 Kadlecsik <kadlec@netfilter.org>, Jiri Pirko <jiri@resnulli.us>, Ivan
 Vecera <ivecera@redhat.com>, Roopa Prabhu <roopa@nvidia.com>, Nikolay
 Aleksandrov <razor@blackwall.org>, Matthias Brugger
 <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Ahmed Zaki <ahmed.zaki@intel.com>, Alexander Lobakin
 <aleksander.lobakin@intel.com>, Vladimir Oltean <olteanv@gmail.com>, "Frank
 Wunderlich" <frank-w@public-files.de>, Daniel Golle
 <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>, "Gustavo A.
 R. Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH v8 net-next 00/15] bridge-fastpath and related
 improvements
Message-ID: <20250304175834.4306c670@kernel.org>
In-Reply-To: <20250228201533.23836-1-ericwouds@gmail.com>
References: <20250228201533.23836-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Feb 2025 21:15:18 +0100 Eric Woudstra wrote:
> This patchset makes it possible to set up a software fastpath between
> bridged interfaces. One patch adds the flow rule for the hardware
> fastpath. This creates the possibility to have a hardware offloaded
> fastpath between bridged interfaces. More patches are added to solve
> issues found with the existing code.

For some reason this series didn't get ingested by patchwork correctly.
Instead of reposting for net-next maybe lets use this opportunity to
resend to netfilter instead? Looks like we have some acks from Nik but
none from Pablo.
-- 
pw-bot: cr
