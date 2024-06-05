Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A272F49657
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 22:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717626288; cv=none; b=Dod7tkFrl38szJz9SJIkyHTE/FPkNKDvgKGat98W6eJHSt3dLbUZoROIxtAkWG+2BHdkp6dz8xev21GyYtht/Mmbqm7myOESDKTiWfXrxmRHQZu2MbmPhASckxaYYIePvVqQlXRkiW5+3R+btspxMJgzV5coB0aLmmuFwUJaR0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717626288; c=relaxed/simple;
	bh=7esYb5c8qMbDN5Hd2Fb9ni4hdOTmBYtBHJE2BU1o52Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4XujOWksapHWIgueLSPzLyTQ21LmvA93ZqN4u7vk8e4+urTpzMVZPTT4n+4xffL4PdOYrVyZ+B1jDEcfc5eaWMvxpj3x3DJz5A/spAHA3Q+io7vBLSRf8JCMO5Xjl++NPxdLFQ+JNr3DZ6PXgBF53rvduM6lujJrNih5w0vywU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [31.221.188.228] (port=12062 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sEz3h-00B95N-W2; Thu, 06 Jun 2024 00:24:44 +0200
Date: Thu, 6 Jun 2024 00:24:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Lion Ackermann <nnamrec@gmail.com>
Subject: Re: [PATCH 1/1] netfilter: ipset: Fix race between namespace cleanup
 and gc in the list:set type
Message-ID: <ZmDlqGtGv_LdMj6k@calendula>
References: <20240604135803.2462674-1-kadlec@netfilter.org>
 <20240604135803.2462674-2-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240604135803.2462674-2-kadlec@netfilter.org>
X-Spam-Score: -1.9 (-)

Hi Jozsef,

On Tue, Jun 04, 2024 at 03:58:03PM +0200, Jozsef Kadlecsik wrote:
[...]
> @@ -424,14 +428,8 @@ static void
>  list_set_destroy(struct ip_set *set)
>  {
>  	struct list_set *map = set->data;
> -	struct set_elem *e, *n;
>  
> -	list_for_each_entry_safe(e, n, &map->members, list) {
> -		list_del(&e->list);
> -		ip_set_put_byindex(map->net, e->id);
> -		ip_set_ext_destroy(set, e);
> -		kfree(e);
> -	}
> +	BUG_ON(!list_empty(&map->members));

It would probably be better to turn this is WARN_ON_ONCE, such as:

        WARN_ON_ONCE(!list_empty(&map->members);

BUG_ON is only allowed to be used in very particular cases these days.

I can update this patch if you are fine with it.

>  	kfree(map);
>  
>  	set->data = NULL;
> -- 
> 2.39.2
> 
