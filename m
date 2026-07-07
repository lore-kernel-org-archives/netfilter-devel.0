Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D833749F1;
	Tue,  7 Jul 2026 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783436307; cv=none; b=UwuI5oe1vVbwX4TlWPPu+rgS5RNVJCTRRlF1Y9uOfZ3OVt/jFFhNCcgUIN42Cy0Y0E1y1Y3CZMVWA4u8ZHpzgSduOqWvrCqWR6okddnv5YarBr7JcVsMPz6SVHxTDdTu8kHpewt0Uwyy65+/xef/1CN1cW3PVfk1pNfDYWP8wIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783436307; c=relaxed/simple;
	bh=gkT4fBpYj7Wq2Ei/WmCz0J1IQbcqQSzsmjcTji6ZxOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y7sjKa35MNPNbNkDy6ySvrTKMVEjCfokWIHkO24OT0X2+o5PUFoaG6lg7tqLWhI98OFFnnAKyBhIexLV9NOST9n35JRHJ7We3PGp83Q+I8CBZjRZqSPYu9UO5L6oC73Jse8dKazFkz7Re2YtErSrHZgM0TmWdlkYdlwmj2qej+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A06D16032C; Tue, 07 Jul 2026 16:58:22 +0200 (CEST)
Date: Tue, 7 Jul 2026 16:58:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>, Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>, Ke Xu <xuke@tsinghua.edu.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conncount: fix zone comparison in tuple
 dedup
Message-ID: <ak0UDVc4gZbfzrtM@strlen.de>
References: <20260706114820.74006-1-zhaoyz24@mails.tsinghua.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706114820.74006-1-zhaoyz24@mails.tsinghua.edu.cn>

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn> wrote:
> The "already exists" dedup logic in __nf_conncount_add() decides
> whether a connection has already been counted and can be skipped instead
> of incrementing the connlimit count.  It compares the conntrack zone of a
> list entry with the zone of the connection being added using
> nf_ct_zone_id() and nf_ct_zone_equal(), passing conn->zone.dir or
> zone->dir as the direction argument.

Right, thats bogus.

> @@ -211,8 +220,10 @@ static int __nf_conncount_add(struct net *net,
>  			/* Not found, but might be about to be confirmed */
>  			if (PTR_ERR(found) == -EAGAIN) {
>  				if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
> -				    nf_ct_zone_id(&conn->zone, conn->zone.dir) ==
> -				    nf_ct_zone_id(zone, zone->dir))
> +				    nf_ct_zone_id(&conn->zone,
> +						  nf_conncount_zone_dir(&conn->zone)) ==
> +				    nf_ct_zone_id(zone,
> +						  nf_conncount_zone_dir(zone)))

Should this be a simpler:

                                if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
-                                   nf_ct_zone_id(&conn->zone, conn->zone.dir) ==
-                                   nf_ct_zone_id(zone, zone->dir))
+                                   nf_ct_zone_equal(&conn->zone, &zone), IP_CT_DIR_ORIGINAL)

?

The tuple is always the 'original' direction, so it would follow that
we should not care about reply zone dir.

Also see:
https://sashiko.dev/#/patchset/20260706114820.74006-1-zhaoyz24%40mails.tsinghua.edu.cn

