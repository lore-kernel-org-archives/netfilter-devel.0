Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87F939449F;
	Tue, 14 Apr 2026 09:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776158395; cv=none; b=DHugoVe0yQRavKZzGKkgD7jvUOEtl77zq8IWQQKZwhbBungUTe1Vdoe8ggAahNpL2709iIZiM0InnBvf+w0FUxc3SlaMPta/R4t8B39JM38keCBC2HzmOEKHnazWr/gKfi7J3TMW/atT9DONIN0oxtc+Sxpcv0AkbajPNDKUFx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776158395; c=relaxed/simple;
	bh=sKcZLVNvHb8yRmI5awUWTQYuQwCIJK/UBSfJEIr4aDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qjvIE/QXEPHm2QperPMIxEe1mmD3y+TiaE3pJDH4Yq30spAz7B35MDAMl+BDc2ApGm3hmrEkTG7IFRnHjrx7lwG0gJns9p7x+tndWfYYExJhJm83FjnRPSPN8xgbScqmzIyO1a7lefRgKZFqMQacB/UalmyoPV+/f5W+z6yd1HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Nd4HUkeC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Nd4HUkeC"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C853A60177;
	Tue, 14 Apr 2026 11:19:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776158392;
	bh=enhIhzXsyFp7SQFqWZ5qyLY/Tha2IbAP5uxa7ljAgCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nd4HUkeCQIE9WHRXag+SQsjaW8Jf1IIhzD0zrvZY/I5zJfKJDCqpPTOxBD3sg4y6E
	 WwhV7gjIubLFcgr69eQz9EvikaQfqnicZoYEHKeGZBy+Gv5FR9aqqzHb3Cvve0yWJQ
	 2xr9xR1//WcTzwFua7tn8kS6wmL0VaD7mFCzR610UhYMMatzQWGJX+2+oHEVZo97yD
	 I7/m92lmBKn4p4pFf7H0SvI5jtBIHguqsP/c0wWT2aEuoz6G4kCLqFhsmW0ps3ghwh
	 g/1MW03sybdsM2UD6O+5l00CJe9/bEFWDBgFA36+9CqmJ6ezrHvDAt7KdwiL0TenZ4
	 4ouVo5HNbulvQ==
Date: Tue, 14 Apr 2026 11:19:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: "Kito Xu (veritas501)" <hxzene@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnetlink_osf: fix null-ptr-deref in
 nf_osf_ttl
Message-ID: <ad4GtgPqTcXl8hUC@chamomile>
References: <20260414074556.2512750-1-hxzene@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260414074556.2512750-1-hxzene@gmail.com>

On Tue, Apr 14, 2026 at 03:45:56PM +0800, Kito Xu (veritas501) wrote:
> diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
> index d64ce21c7b55..85dbd47dbbd4 100644
> --- a/net/netfilter/nfnetlink_osf.c
> +++ b/net/netfilter/nfnetlink_osf.c
> @@ -43,6 +43,9 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
>  	else if (ip->ttl <= f_ttl)
>  		return 1;
>  
> +	if (!in_dev)
> +		return 0;
> +

I suggest you add this check a bit earlier:

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 5d15651c74f0..e8069f4e139b 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -36,6 +36,9 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
        const struct in_ifaddr *ifa;
        int ret = 0;
 
+       if (!in_dev)
+               return 0;
+
        if (ttl_check == NF_OSF_TTL_TRUE)
                return ip->ttl == f_ttl;
        if (ttl_check == NF_OSF_TTL_NOCHECK)
@@ -43,9 +46,6 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
        else if (ip->ttl <= f_ttl)
                return 1;
 
-       if (!in_dev)
-               return 0;
-
        in_dev_for_each_ifa_rcu(ifa, in_dev) {
                if (inet_ifa_match(ip->saddr, ifa)) {
                        ret = (ip->ttl == f_ttl);

Thanks!
