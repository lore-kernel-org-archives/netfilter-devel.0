From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Optimise nfq_queue_cb
Date: Mon, 1 Jun 2015 13:03:59 +0200
Message-ID: <20150601110359.GB4002@salvia>
References: <md5:KJl5IfCAjtPWb+o93HAjWA==>
 <556C2438.3060203@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Paul Aitken <paitken@brocade.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51939 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbbFAK66 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2015 06:58:58 -0400
Content-Disposition: inline
In-Reply-To: <556C2438.3060203@brocade.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 01, 2015 at 10:22:00AM +0100, Paul Aitken wrote:
> ct and myct have both already been checked for non-NULL,
> so there's no need to check either of them again later.
> 
> Signed-off-by: Paul Aitken <paitken@brocade.com>
> ---
>  src/cthelper.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/src/cthelper.c b/src/cthelper.c
> index 15d5126..6537515 100644
> --- a/src/cthelper.c
> +++ b/src/cthelper.c
> @@ -325,14 +325,12 @@ static int nfq_queue_cb(const struct nlmsghdr *nlh, void *data)
>  	if (pkt_verdict_issue(helper, myct, queue_num, id, verdict, pktb) < 0)
>  		goto err_pktb;
> -	if (ct != NULL)
> -		nfct_destroy(ct);
> +	nfct_destroy(ct);

void nfct_destroy(struct nf_conntrack *ct)
{
        assert(ct != NULL);
        ...

the library doesn't allow NULL pointers.

>  	if (myct->exp != NULL)
>  		nfexp_destroy(myct->exp);
> -	if (myct && myct->priv_data != NULL)
> +	if (myct->priv_data != NULL)
>  		free(myct->priv_data);
> -	if (myct != NULL)
> -		free(myct);
> +	free(myct);
>  	return MNL_CB_OK;
>  err_pktb:
> -- 
> 1.9.1
> 
