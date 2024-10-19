Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2122D8BEC;
	Sat, 19 Oct 2024 18:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729361446; cv=none; b=H1+Fcxg+ADhPzZB0Tun2EjxaQgX9JYFPlbAeqYmKS+iNI6nPQGVTV1OLmY47Adt9zE9GpFPeFgATEasTgIaoQT96+CtzazmhTE2R0mt6pDyigWonY5SG/PQTS1P0XAOOPh+2J9NYacvEoNnb6yoOguKHMhBe6D8b+KLFPhACydQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729361446; c=relaxed/simple;
	bh=e1kwW6oqJtPR3kUxGh9gF7pabWu8VMmDmw978jmL250=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvYf7KDXr+BuSz1rpAoRlikBobI2xTjVl36qyusekdqWuJOB4pNcB4c5qI5KfiGk84b3o/pdVqPHwZQvqky7H4lzkiOx2uGRsBpr7cmHYws94b3kisp7Vychp8uhyxwG6L5nRx4o9BzvJ/B2oA4/MjaImxd3XMNEvSsSVudbGsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46366 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t2DuI-004JIk-QF; Sat, 19 Oct 2024 20:10:33 +0200
Date: Sat, 19 Oct 2024 20:10:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ilya Katsnelson <me@0upti.me>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Florian Westphal <fw@strlen.de>, Sasha Levin <sashal@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ignat@cloudflare.com, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH v2] netfilter: xtables: fix typo causing some targets to
 not load on IPv6
Message-ID: <ZxP2FUVCmettzj7B@calendula>
References: <20241019-xtables-typos-v2-1-6b8b1735dc8e@0upti.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241019-xtables-typos-v2-1-6b8b1735dc8e@0upti.me>
X-Spam-Score: -1.9 (-)

Hi,

Thanks for your patch.

On Sat, Oct 19, 2024 at 08:05:07AM +0300, Ilya Katsnelson wrote:
> These were added with the wrong family in 4cdc55e, which seems
> to just have been a typo, but now ip6tables rules with --set-mark
> don't work anymore, which is pretty bad.

There is at least one more issue, TRACE is missing this chunk:

diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index f3fa4f11348c..a642ff09fc8e 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -49,6 +49,7 @@ static struct xt_target trace_tg_reg[] __read_mostly = {
                .target         = trace_tg,
                .checkentry     = trace_tg_check,
                .destroy        = trace_tg_destroy,
+               .me             = THIS_MODULE,
        },
 #endif
 };
