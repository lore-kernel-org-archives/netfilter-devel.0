From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] pgsql: only disable key if it starts with
 underscore
Date: Fri, 3 Aug 2012 11:29:56 +0200
Message-ID: <20120803092956.GD12107@1984>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
 <1343856436-11129-5-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55432 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab2HCJ37 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:29:59 -0400
Content-Disposition: inline
In-Reply-To: <1343856436-11129-5-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 01, 2012 at 11:27:15PM +0200, Eric Leblond wrote:
> ulogd2 was magically making inactive the first key of description
> table. This patch improves this system by only doing so when
> the key start with an undescore. This way, system like nfacct which
> do not have a primary key can be implemented easily.

Applied with minor glitch, thanks.

> ---
>  output/pgsql/ulogd_output_PGSQL.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
> index 9529b1c..44600b0 100644
> --- a/output/pgsql/ulogd_output_PGSQL.c
> +++ b/output/pgsql/ulogd_output_PGSQL.c
> @@ -195,8 +195,10 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
>  		strncpy(upi->input.keys[i].name, buf, ULOGD_MAX_KEYLEN);
>  	}
>  
> -	/* ID is a sequence */
> -	upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
> +	/* ID (starting by '.') is a sequence */
> +	if (upi->input.keys[0].name[0] == '.') {
> +	    upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
> +	}

No need for brackets here. Also fixed indentation.

>  
>  	PQclear(pi->pgres);
>  	return 0;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
