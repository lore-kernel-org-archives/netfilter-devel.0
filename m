From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_log PATCH 2/3] Convert kernel to stdint types
Date: Wed, 27 May 2015 14:22:49 +0200
Message-ID: <20150527122249.GB17945@salvia>
References: <20150516113828.GR14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Felix Janda <felix.janda@posteo.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37914 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbbE0MRs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 08:17:48 -0400
Content-Disposition: inline
In-Reply-To: <20150516113828.GR14201@euler>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 16, 2015 at 01:41:49PM +0200, Felix Janda wrote:
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
>  include/libnetfilter_log/linux_nfnetlink_log.h | 42 +++++++++++++-------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/include/libnetfilter_log/linux_nfnetlink_log.h b/include/libnetfilter_log/linux_nfnetlink_log.h
> index 9f38277..c647581 100644
> --- a/include/libnetfilter_log/linux_nfnetlink_log.h
> +++ b/include/libnetfilter_log/linux_nfnetlink_log.h
> @@ -20,31 +20,31 @@ enum nfulnl_msg_types {
>  };
>  
>  struct nfulnl_msg_packet_hdr {
> -	__be16		hw_protocol;	/* hw protocol (network order) */
> -	__u8	hook;		/* netfilter hook */
> -	__u8	_pad;
> +	uint16_t		hw_protocol;	/* hw protocol (network order) */
> +	uint8_t	hook;		/* netfilter hook */
> +	uint8_t	_pad;
>  };

I have skipped this patch in this series. It is mangling a cached
header from the kernel, I guess there must be a way to make musl happy
without this change given that we follow the same approach in other
libraries.

Thanks.
