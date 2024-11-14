Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE7918C02F;
	Thu, 14 Nov 2024 11:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731584717; cv=none; b=TKg9cmy33Xg+qVu2xz4Rs0p5fzg7n64U8MzR8E6TEIwoDx9NiwdWpyPtm2xpZKrU2X3vR23I0bhWq4BK0LdiEaWYxQE/VAktCIUvA0qdmk7WwcpvV96fr95PDFlv3JgBBHDe5/DwmPkN4grJmq1fanW3TodqcdiOB5gG+nylejo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731584717; c=relaxed/simple;
	bh=bnUVSsfKIRxnPADJrEdSRzBo/u/NdOCZ9jbg111mOBA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cf+Ym2L6uZyQhQAYGQdVTOd+XRj3eCRGgwYHCabpb7DCXv6q2SO4GV5elIyVUjFnYzg5+gtOzxDy2MwFNC0A97QqenUIR5ruLqwpMTZnch6iu+dchjBuLkj07LQmjlFo46KQDKMDQtjO9LmrsLqm0W+wZQHf5uNJ4ewYbyq2lJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 1FCAC32E01C3;
	Thu, 14 Nov 2024 12:45:05 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id hI9TfCIXrCvY; Thu, 14 Nov 2024 12:45:03 +0100 (CET)
Received: from mentat.rmki.kfki.hu (254C26AF.nat.pool.telekom.hu [37.76.38.175])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id B51AC32E01B7;
	Thu, 14 Nov 2024 12:45:02 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id CDDAD1428CC; Thu, 14 Nov 2024 12:45:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id CB601142175;
	Thu, 14 Nov 2024 12:45:01 +0100 (CET)
Date: Thu, 14 Nov 2024 12:45:01 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Jeongjun Park <aha310510@gmail.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
    David Miller <davem@davemloft.net>, edumazet@google.com, kuba@kernel.org, 
    pabeni@redhat.com, horms@kernel.org, Patrick McHardy <kaber@trash.net>, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
    stable@vger.kernel.org, 
    syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] netfilter: ipset: add missing range check in
 bitmap_ip_uadt
In-Reply-To: <20241113130209.22376-1-aha310510@gmail.com>
Message-ID: <de96a3be-deeb-efc0-dd64-8468598f15b0@netfilter.org>
References: <20241113130209.22376-1-aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 1%

On Wed, 13 Nov 2024, Jeongjun Park wrote:

> When tb[IPSET_ATTR_IP_TO] is not present but tb[IPSET_ATTR_CIDR] exists,
> the values of ip and ip_to are slightly swapped. Therefore, the range check
> for ip should be done later, but this part is missing and it seems that the
> vulnerability occurs.
> 
> So we should add missing range checks and remove unnecessary range checks.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
> Fixes: 72205fc68bd1 ("netfilter: ipset: bitmap:ip set type support")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

The patch should be applied to the stable branches too. Thanks!

Best regards,
Jozsef

> ---
>  net/netfilter/ipset/ip_set_bitmap_ip.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
> index e4fa00abde6a..5988b9bb9029 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ip.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
> @@ -163,11 +163,8 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
>  		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
>  		if (ret)
>  			return ret;
> -		if (ip > ip_to) {
> +		if (ip > ip_to)
>  			swap(ip, ip_to);
> -			if (ip < map->first_ip)
> -				return -IPSET_ERR_BITMAP_RANGE;
> -		}
>  	} else if (tb[IPSET_ATTR_CIDR]) {
>  		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
>  
> @@ -178,7 +175,7 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
>  		ip_to = ip;
>  	}
>  
> -	if (ip_to > map->last_ip)
> +	if (ip < map->first_ip || ip_to > map->last_ip)
>  		return -IPSET_ERR_BITMAP_RANGE;
>  
>  	for (; !before(ip_to, ip); ip += map->hosts) {
> --
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
