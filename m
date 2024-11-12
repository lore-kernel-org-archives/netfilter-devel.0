Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D5920B218;
	Tue, 12 Nov 2024 19:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731441578; cv=none; b=vEbUWnCwc0lmHWFWGOGdNdx697YNUiYTq7RFaUAYsNAc9OVeESo1oQ1MS+lww+RuJlYqZ7In8fgdHQTXIrl13fiUacnuDk5YVtiHUi2AbGxYEcOzdshIIwO9+MPqI65P38RYF56tzihSb3SjBR/VfSCHvcxbLyT90SLHVQx6ZIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731441578; c=relaxed/simple;
	bh=rC+0ugHNvw01z7Q9STlYyR40J3xB/OsK/Djp3RNVyos=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gba/tHTmyP82ppiqIDekJA3hML+b7cXYTfJtZPzRf7kFBWTKUUBgeZ9SleC2EbnEZh0bWXrf5QNiCDq8B/PfISQDrq2V8VDxcwXL5ciqXliXv7rzqF9WwCWiIDvWywt7HYgaQPQqYwtLqoABT1powfmVhX7DMF45NYaJ9A0zcrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id B5C8432E01CF;
	Tue, 12 Nov 2024 20:50:23 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id ytOsMQz8XMno; Tue, 12 Nov 2024 20:50:21 +0100 (CET)
Received: from mentat.rmki.kfki.hu (94-21-33-116.pool.digikabel.hu [94.21.33.116])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 5FB7E32E01CD;
	Tue, 12 Nov 2024 20:50:21 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id F05421428C3; Tue, 12 Nov 2024 20:50:20 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id ECDFC1401AE;
	Tue, 12 Nov 2024 20:50:20 +0100 (CET)
Date: Tue, 12 Nov 2024 20:50:20 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Jeongjun Park <aha310510@gmail.com>
cc: pablo@netfilter.org, davem@davemloft.net, edumazet@google.com, 
    kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, kaber@trash.net, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
    stable@vger.kernel.org, 
    syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
Subject: Re: [PATCH net] netfilter: ipset: add missing range check in
 bitmap_ip_uadt
In-Reply-To: <20241112113434.58975-1-aha310510@gmail.com>
Message-ID: <85b3a08c-f148-ef3c-6489-e34aadc4e735@netfilter.org>
References: <20241112113434.58975-1-aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 1%

Hello Jeongjun,

On Tue, 12 Nov 2024, Jeongjun Park wrote:

> In the bitmap_ip_uadt function, if ip is greater than ip_to, they are swapped.
> However, there is no check to see if ip is smaller than map->first, which
> causes an out-of-bounds vulnerability. Therefore, you need to add a missing
> bounds check to prevent out-of-bounds.

It's a good catch, thanks! However, with the patch below the 

                        if (ip < map->first_ip)
                                return -IPSET_ERR_BITMAP_RANGE;

lines in the branch just after swapping the from/to addresses becomes 
unnecessary. Could you send a second version of the patch with the lines
above removed?

Best regards,
Jozsef

> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
> Fixes: 72205fc68bd1 ("netfilter: ipset: bitmap:ip set type support")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> ---
>  net/netfilter/ipset/ip_set_bitmap_ip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
> index e4fa00abde6a..705c316b001a 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ip.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
> @@ -178,7 +178,7 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
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
