Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53DB1FC8
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764351604; cv=none; b=icDFKzrF4afBkRBVAaepndHdtNmKRXRxZsTQwtdryxWT52kGdH17eCCdMHoAkdtQfsv+1Qo4ygL4yT1M26GdWa//jtaFcYh9gi4YG6gfTxhktghbJ3dwDF6lxRjiWCXXQElOkS3oCMS6GwEfssEaeJNUNTpz8A3uo3ABtNnE2HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764351604; c=relaxed/simple;
	bh=L0KC5mGEjww7v/AfwvlSDJ7ERJjiLQl7j4ezXG8IHts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktzywb5X25EAmsRgNKlxTV1/yQsYEjKG9w/w2oDceaCA/MzGFqVHoZY5bXunLAHvGX7LAXAM+/CjrG737Asg+ZVhLii2XcwO7Ul+bOOpZvywi7TCCdk9Z7Bp+VLs4jcF1UHOeIbY/PqI3vJ/FIZ5vnUy2MM6QrcVombWZhENBww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 632CC604DD; Fri, 28 Nov 2025 18:39:59 +0100 (CET)
Date: Fri, 28 Nov 2025 18:40:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC 6/6] scanner: Introduce SCANSTATE_RATE
Message-ID: <aSnecCkmj1FPGFHk@strlen.de>
References: <20251126151346.1132-1-phil@nwl.cc>
 <20251126151346.1132-7-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126151346.1132-7-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
>  struct limit_rate {
>  	uint64_t rate, unit;
>  };
> diff --git a/include/parser.h b/include/parser.h
> index 8cfd22e9e6c42..889302baf5950 100644
> --- a/include/parser.h
> +++ b/include/parser.h
> @@ -47,6 +47,7 @@ enum startcond_type {
>  	PARSER_SC_META,
>  	PARSER_SC_POLICY,
>  	PARSER_SC_QUOTA,
> +	PARSER_SC_RATE,

Could this new scanstate get added in a different patch?

> -"hour"			{ return HOUR; }
> -"day"			{ return DAY; }
> +<*>"hour"		{ return HOUR; }
> +<*>"day"		{ return DAY; }

this might allow to scope this to meta+rate first before adding
the exclusive start condition change.
