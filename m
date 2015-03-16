From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: netfilter: ipset: Properly calculate extensions offsets and
 total length
Date: Mon, 16 Mar 2015 20:30:48 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1503162030080.23975@blackhole.kfki.hu>
References: <cover.1426509747.git.popovich_sergei@mail.ua> <1d1a78681eb40d67d9be6e93a4821b2814d6d21e.1426509747.git.popovich_sergei@mail.ua>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, popovich_sergei@mail.ru
To: Sergey Popovich <popovich_sergei@mail.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:46465 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486AbbCPT24 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 15:28:56 -0400
In-Reply-To: <1d1a78681eb40d67d9be6e93a4821b2814d6d21e.1426509747.git.popovich_sergei@mail.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 16 Mar 2015, Sergey Popovich wrote:

> Offsets and total length returned by the ip_set_elem_len()
> calculated incorrectly as initial set element length (i.e.
> len parameter) is used multiple times in offset calculations,
> also affecting set element total length.
> 
> Use initial set element length as start offset, do not add aligned
> extension offset to the offset. Return offset as total length of
> the set element.
> 
> This reduces memory requirements on per element basic for the
> hash:* type of sets.
> 
> For example output from 'ipset -terse list test-1' on 64-bit PC,
> where test-1 is generated via following script:
> 
>   #!/bin/bash
> 
>   set_name='test-1'
> 
>   ipset create "$set_name" hash:net family inet \
>               timeout 10800 counters comment \
>               hashsize 65536 maxelem 65536
> 
>   declare -i o3 o4
>   fmt="add $set_name 192.168.%u.%u\n"
> 
>   for ((o3 = 0; o3 < 256; o3++)); do
>       for ((o4 = 0; o4 < 256; o4++)); do
>           printf "$fmt" $o3 $o4
>       done
>   done |ipset -exist restore
> 
> BEFORE this patch is applied
> 
>   # ipset -terse list test-1
>   Name: test-1
>   Type: hash:net
>   Revision: 6
>   Header: family inet hashsize 65536 maxelem 65536
> timeout 10800 counters comment
>   Size in memory: 26348440
> 
> and AFTER applying patch
> 
>   # ipset -terse list test-1
>   Name: test-1
>   Type: hash:net
>   Revision: 6
>   Header: family inet hashsize 65536 maxelem 65536
> timeout 10800 counters comment
>   Size in memory: 7706392
>   References: 0
> 
> Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>

Good catch, you are right. Patch is applied.

Best regards,
Jozsef

> ---
>  net/netfilter/ipset/ip_set_core.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index d259da3..fb1f2b4 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -365,7 +365,7 @@ size_t
>  ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len)
>  {
>  	enum ip_set_ext_id id;
> -	size_t offset = 0;
> +	size_t offset = len;
>  	u32 cadt_flags = 0;
>  
>  	if (tb[IPSET_ATTR_CADT_FLAGS])
> @@ -375,12 +375,12 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len)
>  	for (id = 0; id < IPSET_EXT_ID_MAX; id++) {
>  		if (!add_extension(id, cadt_flags, tb))
>  			continue;
> -		offset += ALIGN(len + offset, ip_set_extensions[id].align);
> +		offset = ALIGN(offset, ip_set_extensions[id].align);
>  		set->offset[id] = offset;
>  		set->extensions |= ip_set_extensions[id].type;
>  		offset += ip_set_extensions[id].len;
>  	}
> -	return len + offset;
> +	return offset;
>  }
>  EXPORT_SYMBOL_GPL(ip_set_elem_len);
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
