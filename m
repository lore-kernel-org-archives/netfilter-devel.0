From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5, V2, nft] Simplify parser rule_spec tree
Date: Mon, 8 Aug 2016 16:54:09 +0200
Message-ID: <20160808145409.GD6264@salvia>
References: <20160808111758.4062-1-carlosfg@riseup.net>
 <20160808124235.11135-1-carlosfg@riseup.net>
 <20160808124235.11135-4-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45726 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbcHHOyS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 10:54:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9F5021F18CC
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:54:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 90BD5FAB5C
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:54:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9635BFAB50
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:54:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160808124235.11135-4-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 02:42:34PM +0200, Carlos Falgueras García wrote:
> @@ -1250,35 +1247,41 @@ set_identifier		:	identifier
>  			}
>  			;
>  
> -handle_spec		:	/* empty */
> +handle_spec		:	HANDLE		NUM
>  			{
> -				memset(&$$, 0, sizeof($$));
> +				$$.handle.location	= @$;
> +				$$.handle.id		= $2;
>  			}
> -			|	HANDLE		NUM
> +			;
> +
> +position_spec		:	POSITION	NUM
>  			{
> -				memset(&$$, 0, sizeof($$));
> -				$$.location	= @$;
> -				$$.id		= $2;
> +				$$.position.location	= @$;
> +				$$.position.id		= $2;
>  			}
>  			;
>  
> -position_spec		:	/* empty */
> +rule_position		:	chain_spec
>  			{
> -				memset(&$$, 0, sizeof($$));
> +				$$ = $1;
>  			}
> -			|	POSITION	NUM
> +			|	chain_spec position_spec
>  			{
> -				memset(&$$, 0, sizeof($$));
> -				$$.location	= @$;
> -				$$.id		= $2;
> +				$$ = $1;
> +				handle_merge(&$$, &$2);
> +			}
> +			|	chain_spec error
> +			{
> +				erec_queue(error(&@2, "Expected `position' or nothing"),

In what case we display this error message after this patch?

Please, include examples in your patch description.

You can also explicitly indicate that tests pass succesfully.

> +					   state->msgs);
> +				$$ = $1;
>  			}
>  			;
>  
> -ruleid_spec		:	chain_spec	handle_spec	position_spec
> +ruleid_spec		:	chain_spec handle_spec
>  			{
> -				$$		= $1;
> -				$$.handle	= $2;
> -				$$.position	= $3;
> +				$$ = $1;
> +				handle_merge(&$$, &$2);
>  			}
>  			;
>  
> -- 
> 2.8.3
> 
