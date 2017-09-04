From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/3] netfilter: nft_limit: replace pkt_bytes with
 bytes
Date: Mon, 4 Sep 2017 13:15:44 +0200
Message-ID: <20170904111544.GB29836@salvia>
References: <20170823204125.31427-1-pablombg@gmail.com>
 <20170823204125.31427-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:45787 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753415AbdIDLQM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 07:16:12 -0400
Content-Disposition: inline
In-Reply-To: <20170823204125.31427-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 23, 2017 at 10:41:24PM +0200, Pablo M. Bermudo Garay wrote:
> Just a small refactor patch in order to improve the code readability.

Applied with changes, see below.

> Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 +-
>  net/netfilter/nft_limit.c                | 30 +++++++++++++++---------------
>  2 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index be25cf69295b..dc7661c293b8 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -946,7 +946,7 @@ enum nft_ct_attributes {
>  
>  enum nft_limit_type {
>  	NFT_LIMIT_PKTS,
> -	NFT_LIMIT_PKT_BYTES
> +	NFT_LIMIT_BYTES

Remember that whatever is exposed through uapi files cannot ever be
changed. This exposes the API to userspace, so if change this, we may
break compilation of userspace tool, that use these headers.

So rule of thumb is: Whatever is exposed through uapi, it is set in
stone forever, even if we don't like it.

So I have taken this, but I have undo this change.

Thanks.
