Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11E372618;
	Sun, 12 Apr 2026 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776020319; cv=none; b=im2J+Y32/GOM33mXnwP//8OhCASfb7vbfm4oH89pGmhzuvmyb9tNmk2bdVcUNFoHt29jIZMB4/9H/6vXqp7bIqce5vl3TBa5meFtt+2qavu9V0c2kdJXtYZNT7difgutz03oLAqKppRfI+8hoNYRy+e6eyX2I07726256yYHEsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776020319; c=relaxed/simple;
	bh=iH4EvmRxOqT/IYuz0dKeLrMxKd9QUf80jI4i495BgSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxr+H5QNo4kBHvTiIJ4n8z+RhLmyjVBxLwajbk8BUpEqK6DQ6PdhOboxq++OqnZjMJUgzXG1Ps+9GiQn12cOY+zcv1hLvarLFVDn1+wz0ay3Ef0Kughvj4zmpLe7JqmBxc9ikEzoWb9U4rQ4NpOBNy1U0Qbr1doi63uMFXq9v6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Q2wy5pv9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Q2wy5pv9"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 16BF5600B9;
	Sun, 12 Apr 2026 20:58:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776020307;
	bh=T76DMLgCKqyBHsu8SuyCwla4NQBeBWedWAkvLEuxUJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q2wy5pv9u5hq6HDQp6YHgcTi8S5MDCl4sEZNO1oGfsomcL7PjzAS2p/6cK6fqbXFZ
	 WAAEPD4DI1VFCWARowzqU1hHnL6DTLlWIf/Xywjbr/IBH+Quw3ZxsnloKuMUkf45Vk
	 J0ZO3d8F4NO2uUmsw0wX5F2dIrVhueB80lDAv7shQirE6QIQhl96KmuqxeJl1/dugU
	 wA3BnktPPk0zwRtMRcW+lqw6g9UenTuhIOUHgMylCHxmM6CJxiybqur9NYnbZgBIPe
	 +BklFx8h6bAto2NmFM7RJKSWt6W4IBHNZuO9gZcTtTgiJ7XPK8F6PIWkVD1YhG1n2E
	 iS+f1Eb3nilrg==
Date: Sun, 12 Apr 2026 20:58:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 00/11] netfilter: updates for net-next
Message-ID: <advrUCdRWruZt2ud@chamomile>
References: <20260410112352.23599-1-fw@strlen.de>
 <20260412094049.7b01dd7b@kernel.org>
 <advOUl92VLlqaiCJ@strlen.de>
 <advTosG9qZ_ZW355@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <advTosG9qZ_ZW355@strlen.de>

On Sun, Apr 12, 2026 at 07:17:22PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Jakub Kicinski <kuba@kernel.org> wrote:
> > https://sashiko.dev/#/patchset/20260410112352.23599-1-fw%40strlen.de
> 
> Forgot to mention this:
> 
> ---------------
> AF_PACKET raw sockets or tun devices, the network_header might be
> uninitialized (~0U). In this state, skb_mac_header_len() will evaluate to
> a very large number, bypassing the ETH_HLEN check completely.
> ---------------
> 
> Really?  TIL.
> 
> ---------------------
> Furthermore, skb_mac_header_len() only verifies the logical distance between
> header offsets, rather than ensuring the bytes are actually present in the
> physical linear buffer.
> 
> ---------------
> 
> Really?  Total news to me :-(

No problem, taking a look into this.
