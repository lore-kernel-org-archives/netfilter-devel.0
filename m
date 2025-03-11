Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314891E1021;
	Tue, 11 Mar 2025 23:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741736666; cv=none; b=hujV7AcWdNARRveF5ttWCOqEPqtOdpJkj4vGr836DFLeuQnErRwr8PTEZyvZYRjefHDUFx7VN/txNVXY/8AaDFJgaNNu4+iP4jc9y5f9a5+1XzG8TYPA9dGNODA94RFxA/7vUzRmfSaTYbYvDW5K+fBQuU6plNQzWdde1sYNNFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741736666; c=relaxed/simple;
	bh=zo5S5g9SDDg5D0vyXj5+j5Nom1Jl/tHuPw0zZZUjYXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nHJuKiBFDHP5R+MrqO3nJ7rjmM286jINy6zJr+uS5ZjlDTlY4Myu2Px+4tNLAJBsjuHkXd9+cRrgGp41tJ/k/vpApivC4GKSyaZdk4vB2Zv/ToOFL7XEdooaIipNkbIAbomT8BGvgKYxRVprpOMm26qPQYMy43pW9JXT/B46+xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dCuQrjld; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kLBL1Hza; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dCuQrjld";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kLBL1Hza"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CE1CD60292; Wed, 12 Mar 2025 00:44:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741736653;
	bh=Zy4H9Jv5YfvsQEUnC9uG0DhMz5JfwXq9yCcEHqiTgoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dCuQrjldqeqnYI/PldvkMU2V6Bp+hA/HwlY9EMQeDrnYiBAjZICwM9gPlxhJoSSpG
	 wZ3sm4kF8H+BL9z6zaEdVcQ/LglJa/NqsPKC27g454L/lUFHDW99BptODIrzN/yyHT
	 t/yZoMDc9WykSeScCm4MMymPj4k/tiOEdh21gQNHONXTisiY59ILJiAUrofoANGdla
	 oFfcx2OdWhPYSQhr+vFxI8YONrevo7KDoM2OkKZf1Esg6h8lTFFECWmg0bTtYGIVCM
	 QdlSGFdCQdx27d6o0ZttuKXJdvlJ8iVY9nlduIVZMRIFYGUp4iyjX6OFh030AcfvYT
	 EskUkG6I4SoAA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F13DD60281;
	Wed, 12 Mar 2025 00:44:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741736648;
	bh=Zy4H9Jv5YfvsQEUnC9uG0DhMz5JfwXq9yCcEHqiTgoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kLBL1Hzar1cmkrQuKybLF66CTNES1VcZwNNIMmceAZVUWG5+PeM/BvDuffpu85yec
	 wSCdNGmitWR2/y3qO93O7m5UoYNKtgV+UMNE3RSCZLEtC3QrrCx5Ui7dzYI58OpWlx
	 NwubfakCqFL6Je9par6JdWhDjcNJFmritUaP6eC06ocENmPzpiec0y8GuyB+7RNRpX
	 yhqSCf2339YL33+0nTwjf5i1QZ20gGgH7fTS6Lw5NjdHN+qVQ+1exZ2T3tciJq/8kh
	 KqPz2aZ2hTBXT2boxpytoDg2qPdtF3KzUcG9KrRXHFunP2n1vk46/9Q2OKi2SN/ESu
	 yNF8SeDIdPDXQ==
Date: Wed, 12 Mar 2025 00:44:04 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Roopa Prabhu <roopa@nvidia.com>, Ivan Vecera <ivecera@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH v9 nf 00/15] bridge-fastpath and related improvements
Message-ID: <Z9DKxOnxr1fSv0On@calendula>
References: <20250305102949.16370-1-ericwouds@gmail.com>
 <897ade0e-a4d0-47d0-8bf7-e5888ef45a61@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <897ade0e-a4d0-47d0-8bf7-e5888ef45a61@gmail.com>

Hi,

On Tue, Mar 11, 2025 at 09:22:35AM +0100, Eric Woudstra wrote:
> 
> 
> On 3/5/25 11:29 AM, Eric Woudstra wrote:
> > This patchset makes it possible to set up a software fastpath between
> > bridged interfaces. One patch adds the flow rule for the hardware
> > fastpath. This creates the possibility to have a hardware offloaded
> > fastpath between bridged interfaces. More patches are added to solve
> > issues found with the existing code.
> 
> 
> > Changes in v9:
> > - No changes, resend to netfilter
> 
> Hi Pablo,
> 
> I've changed tag [net-next] to [nf], hopefully you can have a look at
> this patch-set. But, after some days, I was in doubt if this way I have
> brought it to your attention. Perhaps I need to do something different
> to ask the netfilter maintainer have a look at it?

Apologies, this maintainance service is best effort.

I am also going to be very busy until April to complete a few more
deliverables, I cannot afford more cancelled projects. I will try to
collect what is left for net-next and wait for the next merge window.

Therefore, I suggest you start with a much smaller series with a
carefully selected subset including preparatory patches. I suggest you
start with the software enhancements only. Please, add datapath tests.

As for the hardware offload part, I have a board that I received 4.5
ago years as a engineering sample that maybe I can use to test this,
but no idea, really.

You are a passer-by (ahem, "contributor"), this will get merged
upstream at some point and we will have to maintain all this new code
without your help maybe ... (people change bussiness units...), I have
to understand what is going on here. The throughput available is
limited, I am afraid we can only go _slow and careful_.

Thanks.

P.S: You work is important, very important, but maybe there is no need
to Cc so many mailing lists and people, maybe netdev@,
netfilter-devel@ and bridge@ is sufficient.
