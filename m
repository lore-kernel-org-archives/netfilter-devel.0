From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] bridge: netfilter: ebt_stp: Use generic functions for
 comparisons
Date: Fri, 30 Mar 2018 11:52:31 +0200
Message-ID: <20180330095231.ph5hqdh2pboblhnk@salvia>
References: <c22b7398816c4533a65ff57aaa44629729fc7254.1521630169.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c22b7398816c4533a65ff57aaa44629729fc7254.1521630169.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Mar 21, 2018 at 04:03:22AM -0700, Joe Perches wrote:
> Instead of unnecessary const declarations, use the generic functions to
> save a little object space.
> 
> $ size net/bridge/netfilter/ebt_stp.o*
>    text	   data	    bss	    dec	    hex	filename
>    1250	    144	      0	   1394	    572	net/bridge/netfilter/ebt_stp.o.new
>    1344	    144	      0	   1488	    5d0	net/bridge/netfilter/ebt_stp.o.old

Applied, thanks Joe.
