From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/9] Netfilter fixes for net
Date: Wed, 13 Jun 2018 14:05:58 -0700 (PDT)
Message-ID: <20180613.140558.671650650168307184.davem@davemloft.net>
References: <20180613105700.12894-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180613105700.12894-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 13 Jun 2018 12:56:51 +0200

> The following patchset contains Netfilter patches for your net tree:
> 
> 1) Fix NULL pointer dereference from nf_nat_decode_session() if NAT is
>    not loaded, from Prashant Bhole.
> 
> 2) Fix socket extension module autoload.
> 
> 3) Don't bogusly reject sets with the NFT_SET_EVAL flag set on from
>    the dynset extension.
> 
> 4) Fix races with nf_tables module removal and netns exit path,
>    patches from Florian Westphal.
> 
> 5) Don't hit BUG_ON if jumpstack goes too deep, instead hit
>    WARN_ON_ONCE, from Taehee Yoo.
> 
> 6) Another NULL pointer dereference from ctnetlink, again if NAT is
>    not loaded, from Florian Westphal.
> 
> 7) Fix x_tables match list corruption in xt_connmark module removal
>    path, also from Florian.
> 
> 8) nf_conncount doesn't properly deal with conntrack zones, hence
>    garbage collector may get rid of entries in a different zone.
>    From Yi-Hung Wei.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thank you.
