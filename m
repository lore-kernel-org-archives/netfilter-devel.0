From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 06/22] netfilter: ipset: Separate memsize calculation
 code into dedicated function
Date: Tue, 1 Nov 2016 20:23:17 +0100
Message-ID: <20161101192317.GG18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-7-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53434 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752964AbcKATXh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:23:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 01D11168386
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:23:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5E2EBAC2D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:23:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78F16BAC2D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:23:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-7-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:39PM +0200, Jozsef Kadlecsik wrote:
> Hash types already has it's memsize calculation code in separate
> functions. Do the same for *bitmap* and *list* sets.

This is just a cleanup, right?

More comments below.

> Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.
> 
> Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  net/netfilter/ipset/ip_set_bitmap_gen.h | 13 ++++++++++++-
>  net/netfilter/ipset/ip_set_list_set.c   | 23 +++++++++++++++++------
>  2 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
> index 2e8e7e5..c22cdde 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_gen.h
> +++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
> @@ -22,6 +22,7 @@
>  #define mtype_kadt		IPSET_TOKEN(MTYPE, _kadt)
>  #define mtype_uadt		IPSET_TOKEN(MTYPE, _uadt)
>  #define mtype_destroy		IPSET_TOKEN(MTYPE, _destroy)
> +#define mtype_memsize		IPSET_TOKEN(MTYPE, _memsize)
>  #define mtype_flush		IPSET_TOKEN(MTYPE, _flush)
>  #define mtype_head		IPSET_TOKEN(MTYPE, _head)
>  #define mtype_same_set		IPSET_TOKEN(MTYPE, _same_set)
> @@ -84,12 +85,22 @@
>  	memset(map->members, 0, map->memsize);
>  }
>  
> +/* Calculate the actual memory size of the set data */
> +static size_t
> +mtype_memsize(const struct mtype *map, size_t dsize)
> +{
> +	size_t memsize = sizeof(*map) +
> +			 map->memsize +
> +			 map->elements * dsize;
> +	return memsize;
> +}

This fits into one line, so I don't see why we need to split it, look:

        return sizeof(*map) + map->memsize + map->elements * dsize;
