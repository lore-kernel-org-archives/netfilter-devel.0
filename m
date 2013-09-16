From: Florian Westphal <fw@strlen.de>
Subject: Re: [nftables PATCH 3/4] Update chain creation format.
Date: Mon, 16 Sep 2013 22:21:44 +0200
Message-ID: <20130916202144.GE9713@breakpoint.cc>
References: <1379348858-29187-1-git-send-email-eric@regit.org>
 <1379348858-29187-4-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37935 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab3IPUVq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:21:46 -0400
Content-Disposition: inline
In-Reply-To: <1379348858-29187-4-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond <eric@regit.org> wrote:
> type keyword is now mandatory when creating a new chain. This
> patc halso implement the change required following the usage of human
> notation in hook.

> diff --git a/files/nftables/bridge-filter b/files/nftables/bridge-filter
> index ca306d4..6ed303e 100644
> --- a/files/nftables/bridge-filter
> +++ b/files/nftables/bridge-filter
> @@ -1,7 +1,7 @@
>  #! nft -f
>  
>  table bridge filter {
> -	chain input		{ hook NF_INET_LOCAL_IN		-200; }
> -	chain forward		{ hook NF_INET_FORWARD		-200; }
> -	chain output		{ hook NF_INET_LOCAL_OUT	200; }
> +	chain input		{ table filter hook input priority -200; }
> +	chain forward		{ table filter hook forward priority -200; }
> +	chain output		{ table filter hook output priority 200; }
>  }

Did you mean 'type filter' instead of 'table' here?
