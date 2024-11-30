Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E447081A
	for <netfilter-devel@vger.kernel.org>; Sat, 30 Nov 2024 21:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733001884; cv=none; b=s6ppiAu582zXmkaGG5EOhdfotjOQK6ig+G9r4kXhGyUQtR+f/wKputQ/vHF7MeRRMx3XEIQPufcGeiWPLNP0WyEYS+UqQS83i9Lf7D+AHF5ssk8NdazJYHT8dyOev6OdISjPehzIFnZ1WZDCIK8+Y9YQJfGdUIJ9u/dMuoQ5C78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733001884; c=relaxed/simple;
	bh=p98m7P9ruh7NcemiAWjj6k7rFMIS3Rxhmg+jbggdCwY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Zqds8lFPb4pjp2c7dYKsX8pvqohEE8iSxE27RRZwgegBB2J4pMhhFALFICiyn9v+YJvaz8ubkdaMLSUPwEoX+rVdZ9OZO6pqu5odN4daFSISnyOlGtIzuPTdm+WmCCWjIZLhozI80XwIwaDLR0FnR3XqwL6k0vXHUHlTIfq4I2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 1EA7632E01D7;
	Sat, 30 Nov 2024 22:17:00 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id jfSh9haPJRss; Sat, 30 Nov 2024 22:16:58 +0100 (CET)
Received: from mentat.rmki.kfki.hu (84-236-122-158.pool.digikabel.hu [84.236.122.158])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 95E7932E01D4;
	Sat, 30 Nov 2024 22:16:57 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 72AA5142958; Sat, 30 Nov 2024 22:16:57 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 6F077142957;
	Sat, 30 Nov 2024 22:16:57 +0100 (CET)
Date: Sat, 30 Nov 2024 22:16:57 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] ipset: core: Hold module reference while requesting
 a module
In-Reply-To: <20241129153038.9436-1-phil@nwl.cc>
Message-ID: <2bbcc17c-d6e8-8369-57fd-a31afe6272dd@netfilter.org>
References: <20241129153038.9436-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 0%

Hi Phil,

On Fri, 29 Nov 2024, Phil Sutter wrote:

> User space may unload ip_set.ko while it is itself requesting a set type
> backend module, leading to a kernel crash. The race condition may be
> provoked by inserting an mdelay() right after the nfnl_unlock() call.
> 
> Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Good catch! It's an unlocked area, so the module reference is indeed 
required.

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
> ---
>  net/netfilter/ipset/ip_set_core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 61431690cbd5..cc20e6d56807 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -104,14 +104,19 @@ find_set_type(const char *name, u8 family, u8 revision)
>  static bool
>  load_settype(const char *name)
>  {
> +	if (!try_module_get(THIS_MODULE))
> +		return false;
> +
>  	nfnl_unlock(NFNL_SUBSYS_IPSET);
>  	pr_debug("try to load ip_set_%s\n", name);
>  	if (request_module("ip_set_%s", name) < 0) {
>  		pr_warn("Can't find ip_set type %s\n", name);
>  		nfnl_lock(NFNL_SUBSYS_IPSET);
> +		module_put(THIS_MODULE);
>  		return false;
>  	}
>  	nfnl_lock(NFNL_SUBSYS_IPSET);
> +	module_put(THIS_MODULE);
>  	return true;
>  }
>  
> -- 
> 2.47.0
> 
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
