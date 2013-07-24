From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [xtables-arptables PATCH v2 3/5] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Wed, 24 Jul 2013 11:01:12 +0200
Message-ID: <20130724090112.GE16434@localhost>
References: <20130723161017.10040.6256.stgit@localhost>
 <20130723161244.10040.57825.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57470 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab3GXJBT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:01:19 -0400
Content-Disposition: inline
In-Reply-To: <20130723161244.10040.57825.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 23, 2013 at 06:12:47PM +0200, Giuseppe Longo wrote:
[...]
> @@ -239,6 +231,14 @@ xtables_restore_main(int argc, char *argv[])
>  		}
>  	}
>  
> +        if (nft_init(&h, tables, XTABLES_CONFIG_DEFAULT) < 0) {
> +                fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
> +                                xtables_globals.program_name,
> +                                xtables_globals.program_version,
> +                                strerror(errno));
> +                exit(EXIT_FAILURE);
> +        }
   ^^^^^^^^

BTW, this is indented with spaces, not with tabs.

It happens several times in the patchset. Please, make sure your
patches are correctly indented.

Thanks.
