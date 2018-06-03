From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/9,v2] Netfilter updates for net-next
Date: Sun, 03 Jun 2018 10:31:17 -0400 (EDT)
Message-ID: <20180603.103117.2116609913907435559.davem@davemloft.net>
References: <20180602232539.10574-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602232539.10574-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun,  3 Jun 2018 01:25:39 +0200

> The following patchset contains Netfilter updates for your net-next tree:
> 
> 1) Get rid of nf_sk_is_transparent(), use inet_sk_transparent() instead.
>    From Máté Eckl.
> 
> 2) Move shared tproxy infrastructure to nf_tproxy_ipv4 and nf_tproxy_ipv6.
>    Also from Máté.
> 
> 3) Add hashtable to speed up chain lookups by name, from Florian Westphal.
> 
> 4) Patch series to add connlimit support reusing part of the
>    nf_conncount infrastructure. This includes preparation changes such
>    passing context to the object and expression destroy interface;
>    garbage collection for expressions embedded into set elements, and
>    the introduction of the clone_destroy interface for expressions.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks.
