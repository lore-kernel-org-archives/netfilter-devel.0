Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A9223EA80;
	Thu, 15 Jan 2026 03:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768447690; cv=none; b=TwqAKKw08HKpoknLx/320NPcLZi0GpUnsos6o6YeB8Xl6baJeuFBQWJq9fY22ckZUzVw3lF+SFCIekpTybfE8UPk0wxnefHhMVbSHS5nBr0aIL7lisj0+fptWg23qvfwul7yXWJ/mqGm/wdnlqOf6sB8AMlzuZyTpAxAXSxwvGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768447690; c=relaxed/simple;
	bh=GZgbEfFWeHeKWcikA591J54/ZOW4C9Yf6i0L3owmtSI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZRsSgQhB2ri/Dh6kk7N8jDtZ70RoJ4ffQS81zntgosjZWHrDC5RXYwvmLADBUqZ2RMBN2xPo//DJBVNWLmVekTawRuZLIYf2hJlDA33NGAzHibEteKmYTw5WCDzrPk5mar9hgXyOPPME6FmIjkvvsmfmOesXldRU7S5r/MCGROs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBFnMmtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBFnMmtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE30C4CEF7;
	Thu, 15 Jan 2026 03:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768447689;
	bh=GZgbEfFWeHeKWcikA591J54/ZOW4C9Yf6i0L3owmtSI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CBFnMmtxqXShKlUcoLLJ10z6doACaEsceU2GAIDc7oKYPTzGOrWAIwXbGub4UcBP6
	 9ApKdgcuD6rYrgVNkNvPJLeq6VXAbVLCxRchHYn5zLblwPHy+AOO22yC9CYxz98dAH
	 unWge1vTHT2ZBSTMNXu4Tr9LmJWohfhcvdajBkj1VpNf36ZL08WWelLYHbFgAwFkGL
	 CdSAuzudTTRsljSGnw1E4bsO3hb/Bjod1818qgirHS2heu5fSO5M9G/RZKt66ut+Yg
	 tGu9vEwgEe+Xj/zLGrJlicrDdYidVrOlw1K/LB1eAAVIt7AaUOTbrIqnV4HZ9UOpQn
	 WkcHSRdmNhopQ==
Date: Wed, 14 Jan 2026 19:28:07 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 horms@kernel.org, andrew+netdev@lunn.ch, netdev@vger.kernel.org,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, victor@mojatatu.com,
 dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net,
 pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
Message-ID: <20260114192807.2f83a4bb@kernel.org>
In-Reply-To: <CAM0EoMmZA_1R8fJ=60z_dvABpW3-f0-5WhYzpn1B1uY9BA4x4A@mail.gmail.com>
References: <20260111163947.811248-1-jhs@mojatatu.com>
	<20260113180720.08bbf8e1@kernel.org>
	<CAM0EoMmZA_1R8fJ=60z_dvABpW3-f0-5WhYzpn1B1uY9BA4x4A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Jan 2026 11:40:18 -0500 Jamal Hadi Salim wrote:
> On Tue, Jan 13, 2026 at 9:07=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> =
wrote:
> > On Sun, 11 Jan 2026 11:39:41 -0500 Jamal Hadi Salim wrote: =20
> > > We introduce a 2-bit global skb->ttl counter.Patch #1 describes how w=
e puti
> > > together those bits. Patches #2 and patch #5 use these bits.
> > > I added Fixes tags to patch #1 in case it is useful for backporting.
> > > Patch #3 and #4 revert William's earlier netem commits. Patch #6 intr=
oduces
> > > tdc test cases. =20
> >
> > TC is not the only way one can loop packets in the kernel forever.
> > Are we now supposed to find and prevent them all? =20
>=20
> These two are trivial to reproduce with simple configs. They consume
> both CPU and memory resources.
> I am not aware of other forever packet loops - but if you are we can
> look into them.

Is there loop prevention in BPF redirect? Plugging two ends of veth
into a bridge? Routing loops with an action to bump TTL back up?
