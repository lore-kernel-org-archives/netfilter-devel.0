From: Edward Cree <ecree@solarflare.com>
Subject: Re: [bug report] net: ipv4: listified version of ip_rcv
Date: Fri, 6 Jul 2018 13:09:18 +0100
Message-ID: <515445c3-c6ee-fd32-456e-5b282e09643d@solarflare.com>
References: <20180706083422.5ddtaxjxhnogcvgn@kili.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: <netfilter-devel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180706083422.5ddtaxjxhnogcvgn@kili.mountain>
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 06/07/18 09:34, Dan Carpenter wrote:
> Hello Edward Cree,
>
> The patch 7da517a3bc52: "net: core: Another step of skb receive list
> processing" from Jul 2, 2018, leads to the following static checker
> warning:
>
> 	net/core/dev.c:5001 netif_receive_skb_list_internal()
> 	warn: 'skb' was already freed.
>
> The patch 17266ee93984: "net: ipv4: listified version of ip_rcv" from
> Jul 2, 2018, leads to the following static checker warning:
>
> 	./include/linux/netfilter.h:301 NF_HOOK_LIST()
> 	warn: 'skb' was already freed.
>
> [...]
>
> do_xdp_generic() frees skb.
>
> [...]
>
> For this one Smatch thinks that nf_hook() sometimes frees skb, but the
> code is less clear to me than for the previous warning so I don't know.
Yep, I think both warnings are correct.  Looks like changing from a dequeue-
 enqueue model to in-place list mangling just broke a bunch of assumptions
 I'd made in earlier versions of the patches.
Fixes coming soon.

Thanks,
-Ed
