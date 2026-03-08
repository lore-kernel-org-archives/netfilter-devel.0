Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5837B31B828
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Mar 2026 11:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772968318; cv=none; b=uQhzI3R0X/kpHPyjzBsrh1vwl8n3h0kFQFISsczEPhGNv55jTb33r3ZHH5igGW774TsOyLgaZ5KirUNdo3hhIDQ0iK0g4hdkXR07ZxaR9Tg8GTMVKQ3OuyZqermSnRy7kuV3CM0kfGnVVpXYwLeDbX0PZoYotR2tqNq4d7GOsdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772968318; c=relaxed/simple;
	bh=gkGefTtxzZrHQY+k55TdJmonoALHIeC7Wek/bXNJHto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TAdGBCCs/BK5zFoe234xiXZepx2JMT+sbhxoGYudaHGaD9hCXhPkvf7/O2/DuR8bTb/xtR20OWNFAztbet69BRFVLq9vTGLc0NQHIXfEdTQ/0frz4zY7pIs5+xzcxEF8ojdsojoe47+jZ4R5OJmgoKpWkyZmZksBTZoQO0IhMmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=koCjqqC7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="koCjqqC7"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 75C276017C;
	Sun,  8 Mar 2026 12:11:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772968315;
	bh=kQpFah0Pwve5BgHQhHos1QBe8H7wkPEBsqa/4UrwjC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=koCjqqC7m/L+jg5uyWmKd1QM9mZTn4xqgefjAK7T3smKseuSEDjI+ZtUdMiKCQefA
	 IrXf4ditai1s5SDa2H9po/kY64rep7hKogFImuzlEQWPevMFRsrW0gUblqLjqCoHiM
	 kciLC4kMoLpb5HXnVyER/a4bSXcrhiRDSG3eyqlgT4vhZe4cdq1fGyA4DpqnM0Pw1G
	 j52uspXGF4h7bBr0y2G2ORvk3ndToq6nggTuE70pjg24phsnpomu+E/uAkwxfqbYLP
	 ae5Vfdzx0HtbufaKKDSDj55jCzJPHxorBx2BDZx13ebWpKTh/tITWKy1uoiBSMVyl/
	 rd/IO1hHuM6EA==
Date: Sun, 8 Mar 2026 12:11:53 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Dull <monderasdor@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v2] netfilter: guard option walkers against 1-byte tail
 reads
Message-ID: <aa1ZeSRNg3HMo7JR@chamomile>
References: <20260307182621.1315-1-monderasdor@gmail.com>
 <20260307184553.1779-1-monderasdor@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260307184553.1779-1-monderasdor@gmail.com>

On Sat, Mar 07, 2026 at 08:45:52PM +0200, David Dull wrote:
> When the last byte of options is a non-single-byte option kind, walkers
> that advance with i += op[i + 1] ? : 1 can read op[i + 1] past the end
> of the option area.
> 
> Add an explicit i == optlen - 1 check before dereferencing op[i + 1]
> in xt_tcpudp and xt_dccp option walkers.
> 
> Fixes: 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables")
> Cc: fw@strlen.de
> Cc: stable@vger.kernel.org
> Signed-off-by: David Dull <monderasdor@gmail.com>
> ---
>  net/netfilter/xt_dccp.c   | 4 ++--
>  net/netfilter/xt_tcpudp.c | 6 ++++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
> index e5a13ecbe6..037ab93e25 100644
> --- a/net/netfilter/xt_dccp.c
> +++ b/net/netfilter/xt_dccp.c
> @@ -62,10 +62,10 @@ dccp_find_option(u_int8_t option,
>  			return true;
>  		}
>  
> -		if (op[i] < 2)
> +		if (op[i] < 2 || i == optlen - 1)
>  			i++;
>  		else
> -			i += op[i+1]?:1;
> +			i += op[i + 1] ? : 1;
>  	}

To improve this area, I'd suggest:

		if (op[i] < 2) {
 			i++;
                        continue;
                }

                if (i + 1 >= optlen)
                        break;

		i += op[i + 1] ? : 1;
 	}
