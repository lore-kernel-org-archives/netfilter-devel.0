Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4C42FE58E;
	Fri, 22 Aug 2025 14:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755872013; cv=none; b=BpiecyVeyrp/esvW9ssRx48q5tuQkH0u5S7u7xqq14AwpbAtCB+G4pfwYq8a1uHeX1OWGruOy3+IGnRk0zfaqiqFgzhTujhuwAfC4b+zaq9iyzz7s8RSrXnnabFFQN8wEFYopnjrp2MW21jCBPkDMGEw+KfqaoETWzuhSyOMnSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755872013; c=relaxed/simple;
	bh=o+A80CtWdOnVX1yavDI9dPi2/1XRRCYN7qKt7hLkMFE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=huPURmjxUcVfB5z1CkHHX6K4nIwF2WIO2WWls60IwKeI1awm7gW83nfngTMDjBk0YLDRKOvroIp2c5dVvCHDrsyxUjx2troaMWrHXmucf3QZMvONWrmfeSnd+sVoDRbCgMKtkryYU5Wf/pSHP7FkEZhKqtM9XPRfxcTix/Kt49w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o/l/7UUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o/l/7UUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F58EC4CEED;
	Fri, 22 Aug 2025 14:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755872012;
	bh=o+A80CtWdOnVX1yavDI9dPi2/1XRRCYN7qKt7hLkMFE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=o/l/7UUv/Lv8J/4LVN0hZnOJLhX62A+ND7uLCZ8PtbnlWjahTozf5tyceZ/hhSW2j
	 vryFpli1H2jxqUJWghJ0t7lt+b9F55nUTe+pPXo9bcluo87wU4txhZQUEBQ5JNUG5S
	 Lyof45Dbe91rWpNCXo1EGWvaWi9R9wYBl8j7j8C2lPD2SnGC51xKcc0uIfbIoXbBnP
	 BJEG8BwvdZ4U6NGhckX0pOu7565LhAANjh13IYHn9NR0kUZZLBHDkUyuCUwTH6OMgf
	 ZTYImDoYRUN2t7w8E1Kx9zfxl91Bvz2wYkoh5XT8NwD+Q+UQoMHhi77f2QWPxpcm8b
	 9A1qBiccYkfLg==
Date: Fri, 22 Aug 2025 07:13:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Wang Liang <wangliang74@huawei.com>, pablo@netfilter.org,
 kadlec@netfilter.org, razor@blackwall.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 horms@kernel.org, yuehaibing@huawei.com, zhangchangzhong@huawei.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] netfilter: br_netfilter: do not check confirmed
 bit in br_nf_local_in() after confirm
Message-ID: <20250822071330.4168f0db@kernel.org>
In-Reply-To: <aKghV0FQDXa0qodb@strlen.de>
References: <20250822035219.3047748-1-wangliang74@huawei.com>
	<aKghV0FQDXa0qodb@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Aug 2025 09:50:58 +0200 Florian Westphal wrote:
> Wang Liang <wangliang74@huawei.com> wrote:
> > When send a broadcast packet to a tap device, which was added to a brid=
ge,
> > br_nf_local_in() is called to confirm the conntrack. If another conntra=
ck
> > with the same hash value is added to the hash table, which can be
> > triggered by a normal packet to a non-bridge device, the below warning
> > may happen. =20
>=20
> I placed this in nf.git:testing.

=F0=9F=91=8D=EF=B8=8F

> In case netdev maintainers want to take it directly:

Unrelated, but while I have you -- nft_flowtable.sh is one of the most
flake-atious test for netdev CI currently :( Could you TAL whenever you
have some spare cycles?

https://netdev.bots.linux.dev/contest.html?test=3Dnft-flowtable-sh
