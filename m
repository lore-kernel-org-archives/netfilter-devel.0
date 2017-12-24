From: Adel Belhouane <bugs.a.b@free.fr>
Subject: Re: [PATCH] src: print 'handle' attribute in tables
Date: Sun, 24 Dec 2017 15:37:52 +0100
Message-ID: <50aa4371-2e39-9a95-89db-01d77dca18e4@free.fr>
References: <20171223194525.6058-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:28260 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751029AbdLXOh7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Dec 2017 09:37:59 -0500
In-Reply-To: <20171223194525.6058-1-harshasharmaiitr@gmail.com>
Content-Language: fr
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Le 23/12/2017 à 20:45, Harsha Sharma a écrit :
> Print 'handle' attribute in tables, when listing via '-a' option
> 
> For eg.
> nft list ruleset -a
> 
> table ip test-ip4 {
> 	chain input {
> 		ip saddr 8.8.8.8 counter packets 0 bytes 0 # handle 3
> 	}
>  # handle 1}

[...]

> diff --git a/src/rule.c b/src/rule.c
> index bb9add0..e875816 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -820,6 +820,8 @@ static void table_print(const struct table *table, struct output_ctx *octx)
>  		chain_print(chain, octx);
>  		delim = "\n";
>  	}
> +	if (octx->handle > 0)
> +		nft_print(octx, " # handle %" PRIu64, table->handle.handle.id);
>  	nft_print(octx, "}\n");
>  }
>  
> 

I'm wonderning if it wouldn't be easier (for something parsing "nft list ruleset -a" 's output) to have the " # handle ..." after the closing brace instead of before. It makes sence to consider "#" as a start of comment until end of line, and in such case the last "}" would be in the comment and missing (for something choosing to ignore all such "comments").

So the example would become instead:

nft list ruleset -a

table ip test-ip4 {
	chain input {
		ip saddr 8.8.8.8 counter packets 0 bytes 0 # handle 3
	}
} # handle 1

What do you think?

regards,
Adel Belhouane.
