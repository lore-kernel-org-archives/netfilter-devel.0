Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3CF14A0AB;
	Sat, 19 Oct 2024 21:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729372227; cv=none; b=ohoa5LtpQS+Ae4iFEzahH8Pe7Pl0r0RpxxcrerZPqNoqQKrQDGube5rYG8FxMAoqXWwS9tXg/VcjYjzqnvBPn37U6YJCfHlydt12T1wbYYeizPUpPSIr791lg73zAOM+uF8+YmX7JUwZTHZjrzfsNri5JHcVDhzcweSn8UAKckE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729372227; c=relaxed/simple;
	bh=Pf8KBJGBznaRnp52DEerLqhbkqXf0FW3J9pFxzpaIKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/Zwk+7/eiAyWWJj5KPyCr1GCoU5eqUs/tLuGJJNRKqp7M9vvFK8TGe6ywtGNFmu1AwDiyPFusYL63KmryojxrCd24iF0EUhDjtw67izC9OInU7ArwfUP/c+RmSRZKwkW52xOY87atS9kQ1tSrGuh5kZy0b0MLpT1W2x8CpfAxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46706 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t2GiH-004jXn-5P; Sat, 19 Oct 2024 23:10:19 +0200
Date: Sat, 19 Oct 2024 23:10:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ilya Katsnelson <me@0upti.me>
Cc: Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>, linux-kernel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Eric Dumazet <edumazet@google.com>, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, ignat@cloudflare.com,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [netfilter-core] [PATCH v2] netfilter: xtables: fix typo causing
 some targets to not load on IPv6
Message-ID: <ZxQgOCqORNuAhltX@calendula>
References: <20241019-xtables-typos-v2-1-6b8b1735dc8e@0upti.me>
 <ZxP2FUVCmettzj7B@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZxP2FUVCmettzj7B@calendula>
X-Spam-Score: -1.9 (-)

On Sat, Oct 19, 2024 at 08:10:29PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> Thanks for your patch.
> 
> On Sat, Oct 19, 2024 at 08:05:07AM +0300, Ilya Katsnelson wrote:
> > These were added with the wrong family in 4cdc55e, which seems
> > to just have been a typo, but now ip6tables rules with --set-mark
> > don't work anymore, which is pretty bad.
> 
> There is at least one more issue, TRACE is missing this chunk:
> 
> diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
> index f3fa4f11348c..a642ff09fc8e 100644
> --- a/net/netfilter/xt_TRACE.c
> +++ b/net/netfilter/xt_TRACE.c
> @@ -49,6 +49,7 @@ static struct xt_target trace_tg_reg[] __read_mostly = {
>                 .target         = trace_tg,
>                 .checkentry     = trace_tg_check,
>                 .destroy        = trace_tg_destroy,
> +               .me             = THIS_MODULE,
>         },
>  #endif
>  };

I will post a v2 including this chunk.

Thanks.
