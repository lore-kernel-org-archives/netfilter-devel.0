From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_hashlimit: fix 64-bit printf formats
Date: Tue, 23 May 2017 23:11:48 +0200
Message-ID: <20170523211148.GA8779@salvia>
References: <1495116985-27115-1-git-send-email-alin.nastac@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alin Nastac <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38990 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162002AbdEWVLx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2017 17:11:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A0780E122C
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:11:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91A12FF2F1
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:11:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EE0DFF2F1
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:11:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1495116985-27115-1-git-send-email-alin.nastac@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 18, 2017 at 04:16:25PM +0200, Alin Nastac wrote:
> Furthermore, this extension use a mix of PRIu64 and %llu formats for
> uint64_t values. IMO it should use only one, for the sake of consistency.
> 
> Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
> ---
>  extensions/libxt_hashlimit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
> index 9e63e1e..970bad9 100644
> --- a/extensions/libxt_hashlimit.c
> +++ b/extensions/libxt_hashlimit.c
> @@ -942,7 +942,7 @@ static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
>  		    _rates[i].mult / avg < _rates[i].mult % avg)
>  			break;
>  
> -	xt_xlate_add(xl, " %llu/%s burst %lu packets",
> +	xt_xlate_add(xl, " %"PRIu64"/%s burst %"PRIu64" packets",
>  		     _rates[i-1].mult / avg, _rates[i-1].name, burst);

Are there more spots that can be converted in this
extensions/libxt_hashlimit.c file?

I see more %llu in spots for burst. If so, it would be great to fix
them all.
