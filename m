From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/2] examples: nft-set-parse-add: give batching
 support
Date: Mon, 29 Sep 2014 17:03:23 +0200
Message-ID: <20140929150323.GA4591@salvia>
References: <20140926183442.3333.62136.stgit@nfdev.cica.es>
 <20140926183448.3333.64808.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, alvaroneay@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39877 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbaI2PCM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:02:12 -0400
Content-Disposition: inline
In-Reply-To: <20140926183448.3333.64808.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 26, 2014 at 08:34:48PM +0200, Arturo Borrero Gonzalez wrote:
> @@ -66,6 +67,8 @@ static struct nft_set *set_parse_file(const char *file, uint16_t format)
>  	}
>  
>  	nft_parse_err_free(err);
> +
> +	nft_set_attr_set_u32(s, NFT_SET_ATTR_ID, 1);
>  	return s;
>  
>  }

I guess this works if you parse one single set definition in a file.
With more than one set, this will break.

IIRC, Alvaro started a patch time ago to add a new interface to
libnftnl to handle the set internal id which was incomplete.

Cc'ing him to know its status.
