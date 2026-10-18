Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401F9336EC0;
	Sun, 18 Oct 2026 02:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792288821; cv=none; b=BrpcEGD5yCDfdUQSo7eUStR5govzceasDjYnamvlVhZuQWwwzhyetFgt3uP0WlYI3wUeOpO36jgT30dT0CT1lYaFG145TUHL/6HPA9oylMb7HUrhuETGaMOY+MYKRFcUFdRuC0t8AvmRYIOTU9mwB6mi4PR+u4XX9YtxO2gJExw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792288821; c=relaxed/simple;
	bh=tkhALo7p8bPjiOBzEVwqowwIYESdvXmRS2qtTVXCqJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Udb8WtWCMawAVz9fAmLFNK1mu5k9/+9GJk7OaRicyQB83ziSfANcuZA0nAS00q0/gHI+1NxAHK65ppiXNJnIf7G9iA3FJ2jCqMrnP4zePGECLDwSnJscn2PGKdQWxVBFu2j1dh+Eq6HDeGmTXR9vd9SeZ7KQSisPjSIIVO4rTpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RxS7MXVJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RxS7MXVJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792288817;
	bh=LLrnhPCaiTDl5/1/QyNZD9wbfp0FSugQO9AzosYJuZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RxS7MXVJuDhT1nUKioQPXZePMzjykxqSsm/Lz0aQBjZOjBGt9k8k0kqSOE6niCadW
	 7RK1kaFRCe9s/ytWsbnwu94HiEn9loot1Yx4occ7wk8SMUa62lUugUrSKuCEoQyTMt
	 Cp4OzAjyKD1RmZRoYosXBH569FmunfRiB6FbzKFGAsgetrOpxMw08o7XWG3mAh7rGi
	 LqYuTvFbPP+o7opQ6d6iG0VhZ6vEc1PHrFgZi6FqDhE2cbvdom4QsLklyEfGFaGLVy
	 qt0V7m+hL0O9mKxeZdLArzf1s/GKD64buiJxe1Do5uYD0B9UEZybb5Csx03hADlDKj
	 flLi1TPXAx/+g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A578F6005A;
	Sun, 18 Oct 2026 04:00:17 +0200 (CEST)
Date: Sun, 18 Oct 2026 04:00:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	geldot@protonmail.com, shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/4] netfilter: offload a TCP flow whose reply
 is never seen
Message-ID: <atQoL7WUM3BvDwbI@chamomile>
References: <20261004171628.3544978-1-julius@bairaktaris.de>
 <20261018015434.3326758-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261018015434.3326758-1-julius@bairaktaris.de>

On Sun, Oct 18, 2026 at 03:54:34AM +0200, Julius Bairaktaris wrote:
> On Sun, Oct 18, 2026 at 03:42:58AM +0200, Pablo Neira Ayuso wrote:
> > This series are a no-go in this approach.
> 
> Understood, I drop it.
> 
> > Please, given we are discussing one series of you quite recently...
> > let's handle one thing at a time.
> 
> Agreed, the fdb series first.
> 
> Some context on why there are so many: they all come from the OpenWrt
> PR that adds flowtable offload for the Qualcomm IPQ807x PPE:
> 
>   https://github.com/openwrt/openwrt/pull/24806
> 
> That PR carries the kernel changes it needs as patches. I am sending
> them upstream so that OpenWrt can carry backports instead of local
> patches.
> 
> I know the rule that there must be an in-tree user. The PPE driver is
> not upstream, so I only send changes that stand on their own: fixes to
> the software path, or features that existing drivers like airoha and
> mtk use.

Thanks for the context. As said, let's go one by one after each
issue/scenario. We will eventually get to all of your described
scenarios.
