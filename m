From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 03/22] netfilter: ipset: Improve skbinfo get/init helpers
Date: Tue, 1 Nov 2016 20:15:30 +0100
Message-ID: <20161101191529.GC18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51496 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754118AbcKATPg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:15:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31682168385
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:15:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F272BAC37
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:15:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2EF1BAC30
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:15:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:36PM +0200, Jozsef Kadlecsik wrote:
> Use struct ip_set_skbinfo in struct ip_set_ext instead of open
> coded fields and assign structure members in get/init helpers
> instead of copying members one by one.
> 
> Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.
> 
> Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/linux/netfilter/ipset/ip_set.h | 30 +++++++++++-------------------
>  net/netfilter/ipset/ip_set_core.c      | 12 ++++++------
>  net/netfilter/xt_set.c                 | 12 +++++++-----
>  3 files changed, 24 insertions(+), 30 deletions(-)
> 
> diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> index 1ea28e3..7802621 100644
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -92,17 +92,6 @@ struct ip_set_ext_type {
>  
>  extern const struct ip_set_ext_type ip_set_extensions[];
>  
> -struct ip_set_ext {
> -	u64 packets;
> -	u64 bytes;
> -	u32 timeout;
> -	u32 skbmark;
> -	u32 skbmarkmask;
> -	u32 skbprio;
> -	u16 skbqueue;
> -	char *comment;
> -};
> -
>  struct ip_set_counter {
>  	atomic64_t bytes;
>  	atomic64_t packets;
> @@ -122,6 +111,15 @@ struct ip_set_skbinfo {
>  	u32 skbmarkmask;
>  	u32 skbprio;
>  	u16 skbqueue;
> +	u16 __pad;

Description doesn't say why this new __pad field is required. Did this
slip through accidentally? Otherwise, include a reason for this in the
patch description. Thanks.
