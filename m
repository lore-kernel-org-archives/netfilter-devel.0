Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B6C200BB5
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2024 12:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733487599; cv=none; b=IHy/JJEqLJkXT8kOG8FFy67o5XbYEyvlji4RXzJjyPQoN+1KLQGBErU7PG1LTBaYoMzOwrN8X02f8OkroBHyfhtQJM89G77xiNWqWML/JPUwkJB+za/1iN+V1X2uzYjogJjFGjabLvsOfqXEGsTP+cUtTud61q1sQwW3MRf9MJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733487599; c=relaxed/simple;
	bh=4siyzwtx0SoKFEFM6fcZ0GN4NJVmR4GccRdwKuO/JY4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=FlLJnbyU5I+lDH9YxExiCl83/NNTBN/hWOjq15jSvVyEpHCd3HOt2kiH/tyf5VqikT5x2WSEB1+4ygx0tMZCwvxRdJIBoBRvhJ6FejXiiHCPe9oPJTlAtnVcy+rszUPg65BT5RlQw3BYND6TKPKcIbR7RqVoAIHpgr5ia/+wlBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=jTjz4S9w; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="jTjz4S9w"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 1972F21D96;
	Fri,  6 Dec 2024 14:19:43 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=QvUxd/vxMw8Bwuy6xT8sVlJO+DjkY4zLPCCgu87quuk=; b=jTjz4S9wmd54
	L6Dz1c6a27LaRJin11iO1/LuIDOevuvoLPkbtFgX8a9QeF+gk3Ke7ELKws4UM/wI
	Azo277jpuO6dL16+u6kzaO4XWjIKd2oZko3mhOlnhgqboDkTx+QByVc3J0wxQWGv
	BPhzSfB2p/spiH5Qlj6JavO65+dbOaxEtpzeJyU7aMrTMdcIoQyI02n9V6EC3cpI
	OFhTpOfPLOUUwI2aDh4SDcYZ0w7LwI6N69heV52JFXt0MJ52b2z5+DC7G2RUU8Pt
	47r8bhTmj+hf3eM61bUAnMMvdSFeGvqwDKlGOkP8RhoDx+LjFJKcarqGd+8UAsg3
	5xgDSC1IMtdCP8OTzIitCsAPE8ev+Accj6IoDPSdL6380Io7pOO54slJach30Lps
	fen1j9m5NDXNr0HLl3mgSb0FWpvM7lNpn393nmw+1ysq9TVZSrfqlxOomwFMYKY/
	Ub26103Wle4wX/hGBv0s5fi6Qmf/A/yspu9aSOydu6A7KbW1l8hnVDawyWTd2qXQ
	osu+i30K3PfiMBclcihy81Km6SmmF7a1FhPlBcgePEEd4KxJxJglyRHgbAFvc2eg
	MrxupfqsU6xYRI9808PMbE/8HxhmTFbbXG2PKeuDIBpHb78GOEfNaBHZRzdY16En
	gWsUWiNkgzoxMOsC7bIWmgECURJCLUc=
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Fri,  6 Dec 2024 14:19:42 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by ink.ssi.bg (Postfix) with ESMTPSA id 4E9EB15F19;
	Fri,  6 Dec 2024 14:19:31 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.1/8.17.1) with ESMTP id 4B6CJLt6022576;
	Fri, 6 Dec 2024 14:19:22 +0200
Date: Fri, 6 Dec 2024 14:19:21 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: David Laight <David.Laight@ACULAB.COM>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "'Naresh Kamboju'" <naresh.kamboju@linaro.org>,
        "'Dan Carpenter'" <dan.carpenter@linaro.org>,
        "'pablo@netfilter.org'" <pablo@netfilter.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'lkft-triage@lists.linaro.org'" <lkft-triage@lists.linaro.org>,
        "'Linux Regressions'" <regressions@lists.linux.dev>,
        "'Linux ARM'" <linux-arm-kernel@lists.infradead.org>,
        "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Anders Roxell'" <anders.roxell@linaro.org>,
        "'Johannes Berg'" <johannes.berg@intel.com>,
        "'toke@kernel.org'" <toke@kernel.org>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>,
        "'kernel@jfarr.cc'" <kernel@jfarr.cc>,
        "'kees@kernel.org'" <kees@kernel.org>
Subject: Re: [PATCH net] Fix clamp() of ip_vs_conn_tab on small memory
 systems.
In-Reply-To: <33893212b1cc4a418cec09aeeed0a9fc@AcuMS.aculab.com>
Message-ID: <5ec10e7c-d050-dab8-1f1b-d0ca2d922eef@ssi.bg>
References: <33893212b1cc4a418cec09aeeed0a9fc@AcuMS.aculab.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Fri, 6 Dec 2024, David Laight wrote:

> The intention of the code seems to be that the minimum table
> size should be 256 (1 << min).
> However the code uses max = clamp(20, 5, max_avail) which implies

	Actually, it tries to reduce max=20 (max possible) below
max_avail: [8 .. max_avail]. Not sure what 5 is here...

> the author thought max_avail could be less than 5.
> But clamp(val, min, max) is only well defined for max >= min.
> If max < min whether is returns min or max depends on the order of
> the comparisons.

	Looks like max_avail goes below 8 ? What value you see
for such small system?

> Change to clamp(max_avail, 5, 20) which has the expected behaviour.

	It should be clamp(max_avail, 8, 20)

> 
> Replace the clamp_val() on the line below with clamp().
> clamp_val() is just 'an accident waiting to happen' and not needed here.

	OK

> Fixes: 4f325e26277b6
> (Although I actually doubt the code is used on small memory systems.)
> 
> Detected by compile time checks added to clamp(), specifically:
> minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()

	Existing or new check? Does it happen that max_avail
is a constant, so that a compile check triggers?

> 
> Signed-off-by: David Laight <david.laight@aculab.com>

	The code below looks ok to me but can you change the
comments above to more correctly specify the values and if the
problem is that max_avail goes below 8 (min).

> ---
>  net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 98d7dbe3d787..c0289f83f96d 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1495,8 +1495,8 @@ int __init ip_vs_conn_init(void)
>  	max_avail -= 2;		/* ~4 in hash row */
>  	max_avail -= 1;		/* IPVS up to 1/2 of mem */
>  	max_avail -= order_base_2(sizeof(struct ip_vs_conn));

	More likely we can additionally clamp max_avail here:

	max_avail = max(min, max_avail);

	But your solution solves the problem with less lines.

> -	max = clamp(max, min, max_avail);
> -	ip_vs_conn_tab_bits = clamp_val(ip_vs_conn_tab_bits, min, max);
> +	max = clamp(max_avail, min, max);
> +	ip_vs_conn_tab_bits = clamp(ip_vs_conn_tab_bits, min, max);
>  	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
>  	ip_vs_conn_tab_mask = ip_vs_conn_tab_size - 1;
>  
> -- 
> 2.17.1

Regards

--
Julian Anastasov <ja@ssi.bg>

