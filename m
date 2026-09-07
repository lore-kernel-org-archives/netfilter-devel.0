Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD76353EC0;
	Mon,  7 Sep 2026 08:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788769950; cv=none; b=cMBkRpQZizopgdl5cGuEXP0Zqm16u8Qemqc2txfqy5lgc7RCaGRKSEJugdc4BuDn2JClEUkOzs5CyruTZkqX9U2kHN7vDV9wY+GtVhmfx4A41JfD6gcBhI9OK5e6gtnZjE0jy/YQvpR1G1ftZa1PKIktfOGs2QWgwRg9eRqZs5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788769950; c=relaxed/simple;
	bh=33/vBjN58npWZlFTkx8RTWH5vrr8A8x8/+LolLX000U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rn/fWDs0pcwKKvQNpYI4oNNL9JrArCjYvCtdEq4VmcZtGI02jXUXkjQYHqNF7twviX5KGkKl7TzHSD0F3gzagTsM40T4X4i6Lrw16Bw9I+StmBxUHxGqblpNd96k9y3YcRjfxShGraYpn+mw6YF6MntFrTP0AEqfeEyXbDY0ufI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 53FDF60544; Mon, 07 Sep 2026 10:32:18 +0200 (CEST)
Date: Mon, 7 Sep 2026 10:32:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack_irc: fix port value truncation in
 parse_dcc()
Message-ID: <ap52kSh-U0VQ7z8P@strlen.de>
References: <AS8P251MB0001B81958B28F762352EF3DC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8P251MB0001B81958B28F762352EF3DC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>

Aamir Ahmed <elb12345@hotmail.co.uk> wrote:
> diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
> index 92360963757a..8321f12dbf15 100644
> --- a/net/netfilter/nf_conntrack_irc.c
> +++ b/net/netfilter/nf_conntrack_irc.c
> @@ -64,6 +64,7 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
>  		     u_int16_t *port, char **ad_beg_p, char **ad_end_p)
>  {
>  	char *tmp;
> +	unsigned long tmp_port;
>  
>  	/* at least 12: "AAAAAAAA P\1\n" */
>  	while (*data++ != ' ')
> @@ -88,7 +89,10 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
>  		data++;
>  	}
>  
> -	*port = simple_strtoul(data, &data, 10);
> +	tmp_port = simple_strtoul(data, &data, 10);
> +	if (tmp_port > 65535)
> +		return -1;

Your other patch also rejects port == 0.
Maybe also check and refuse for tmp_port < 1024 here.

This patch can be handled via nf-next, I think.
