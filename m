Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4873A3A0E86;
	Mon,  5 Oct 2026 20:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233632; cv=none; b=SAUl5Fl81q/u42ZJ6U9qv39bfbPx+tWKMwdWDaDLLNaFyvnMTVI1/pjAugvfkj/EuPWxCfA4K3zl23RWV66dJ8q06lYBU017WrfcbTUNSUPZQf/Wxa+0zYQAXENOie9Ct6eF9LkPV3grXB/nQplHmA04qPvdpLRi/n9RbIGwbO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233632; c=relaxed/simple;
	bh=3x5t01ay1qSBp1J/+mth8N83KaCu/K1uZw3wLKlFaek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UUrpg248KKbOkBTcXaL9qHyqPSxxGP8bgD3NzsQ6azcDO+bsXlunLchE5i6OdjrL0hxPB0d4WJDVS2cpMQT2WGLXzNgH4Xrq0ZksyRvcLRuSNPF8YzrE9527wFZCMfPv2bFOBY1M3nGCMDOfXvXSut9GGXB17unjK0PIxqQMyqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YG3ejdeF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YG3ejdeF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791233615;
	bh=1pw4mRK8KHKeEH3wBx+GXpr0RKs9zTH6aWVAX8TBUzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YG3ejdeFdTshsujcpmAE9hrlvuwQZ3MKC6aDO23rJMWMixXaXfeYOCPx15OXUlTs/
	 1zi0ZfO+F8JpCmktAD6OPKqxMFnUPwfMrE5g/bU/g4GQXcQIKIEL6eT/7oUjpFSQZG
	 XzRLIhMJJ/htszx6p1B3s7h88XSa9sZGf+83vRHqIPbtHR5cSu4Wv6AkKTqcvpknhY
	 BfEse7AWaQ5AmI4TCSZyHhG4NfhF0+qQH6g6XRGg5qZd2I4B4kE/VYJYwPrloKNyEc
	 IIciA9+NoqELOU63PcG/SuIp77sa5YfIqPnuO09DxCKdi5tgR2vuFFLpyc/fJ+A8Mb
	 A8fpg8m+Z8G2g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id EDD5E603D6;
	Mon,  5 Oct 2026 22:53:34 +0200 (CEST)
Date: Mon, 5 Oct 2026 22:53:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netdev-bot+sinfo@kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, horms@kernel.org,
	fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/11] netfilter: synproxy: fix reset of ct
 seqadj when reopening a connection
Message-ID: <asQOSwu0g7m5M43w@chamomile>
References: <20260927223436.269024-1-pablo@netfilter.org>
 <20260927223436.269024-2-pablo@netfilter.org>
 <179054884482.31693.9985445366421543993@kernel.org>
 <armg511ZWKl5ZqhZ@chamomile>
 <asKoa2wFW5QneXEA@chamomile>
 <e909312d-76bd-498b-afec-86a1cd611e1c@ovn.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e909312d-76bd-498b-afec-86a1cd611e1c@ovn.org>

On Mon, Oct 05, 2026 at 03:04:18PM +0200, Ilya Maximets wrote:
> FWOn 10/4/26 9:26 PM, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > Just a gentle bump to this net-next PR containing Netfilter updates.
> > 
> > Let me know if there is anything that needs to be addressed.
> 
> AFAICT, this PR was merged to net-next on the 29th:
>   https://git.kernel.org/netdev/net-next/c/0a1a3898ab64fd4f7b90816fc61186d8eb5302a7
> 
> The bot was a little confused, but the reply was actually sent:
>   https://lore.kernel.org/all/179064961102.229594.11396134169189168960.git-patchwork-notify@kernel.org/

Indeed, all then, thanks!
