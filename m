From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 04/22] netfilter: ipset: Improve comment extension helpers
Date: Tue, 1 Nov 2016 20:16:11 +0100
Message-ID: <20161101191611.GD18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-5-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51684 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753264AbcKATQQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:16:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 96BE7168383
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:16:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7CB8BBAC24
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:16:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2F895BAC29
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:16:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-5-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:37PM +0200, Jozsef Kadlecsik wrote:
> Allocate memory with kmalloc() rather than kzalloc().
> 
> Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.
> 
> Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/linux/netfilter/ipset/ip_set_comment.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/netfilter/ipset/ip_set_comment.h b/include/linux/netfilter/ipset/ip_set_comment.h
> index bae5c76..5444b1b 100644
> --- a/include/linux/netfilter/ipset/ip_set_comment.h
> +++ b/include/linux/netfilter/ipset/ip_set_comment.h
> @@ -34,7 +34,7 @@
>  		return;
>  	if (unlikely(len > IPSET_MAX_COMMENT_SIZE))
>  		len = IPSET_MAX_COMMENT_SIZE;
> -	c = kzalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
> +	c = kmalloc(sizeof(*c) + len + 1, GFP_ATOMIC);

It would be better to indicate in the description why kzalloc is
useless.
