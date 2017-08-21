From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 02/18] erec: add function to free list
Date: Mon, 21 Aug 2017 10:12:51 +0200
Message-ID: <20170821081251.GB2982@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-3-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53053 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbdHUINT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 04:13:19 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-3-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 19, 2017 at 05:24:04PM +0200, Eric Leblond wrote:
> Signed-off-by: Eric Leblond <eric@regit.org>

Please, add description, even if it's just a oneliner.

[...]
> diff --git a/src/erec.c b/src/erec.c
> index 439add9..f454d34 100644
> --- a/src/erec.c
> +++ b/src/erec.c
> @@ -213,6 +213,16 @@ void erec_print_list(FILE *f, struct list_head *list)
>  	}
>  }
>  
> +void erec_free_list(struct list_head *list)
> +{
> +	struct error_record *erec, *next;
> +
> +	list_for_each_entry_safe(erec, next, list, list) {
> +		list_del(&erec->list);
> +		erec_destroy(erec);
> +	}
> +}

There is no first user of this function in the codebase yet?
