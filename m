Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDA4CDB465
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 19:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbjJPTwZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 15:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjJPTwY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 15:52:24 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0217B8F
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 12:52:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 617E8CC02B7;
        Mon, 16 Oct 2023 21:52:21 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 16 Oct 2023 21:52:19 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id CB9ABCC011F;
        Mon, 16 Oct 2023 21:52:18 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id C41483431A8; Mon, 16 Oct 2023 21:52:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id C2A17340D74;
        Mon, 16 Oct 2023 21:52:18 +0200 (CEST)
Date:   Mon, 16 Oct 2023 21:52:18 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     xiaolinkui <xiaolinkui@gmail.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, justinstitt@google.com,
        kuniyu@amazon.com, netfilter-devel@vger.kernel.org,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: Re: [PATCH 2/2] netfilter: ipset: fix race condition in ipset swap,
 destroy and test
In-Reply-To: <20231016135204.27443-2-xiaolinkui@gmail.com>
Message-ID: <3ad078fa-fa61-95a8-dbd2-33d5faa2a8b@netfilter.org>
References: <20231016135204.27443-1-xiaolinkui@gmail.com> <20231016135204.27443-2-xiaolinkui@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

On Mon, 16 Oct 2023, xiaolinkui wrote:

> From: Linkui Xiao <xiaolinkui@kylinos.cn>
> 
> There is a race condition which can be demonstrated by the following
> script:
> 
> ipset create hash_ip1 hash:net family inet hashsize 1024 maxelem 1048576
> ipset add hash_ip1 172.20.0.0/16
> ipset add hash_ip1 192.168.0.0/16
> iptables -A INPUT -m set --match-set hash_ip1 src -j ACCEPT
> while [ 1 ]
> do
> 	ipset create hash_ip2 hash:net family inet hashsize 1024 maxelem 1048576
> 	ipset add hash_ip2 172.20.0.0/16
> 	ipset swap hash_ip1 hash_ip2
> 	ipset destroy hash_ip2
> 	sleep 0.05
> done

I have been running the script above for more than two hours and nothing 
happened. What else is needed to trigger the bug? (I have been 
continuously sending ping to the tested host.)

> Swap will exchange the values of ref so destroy will see ref = 0 instead of
> ref = 1. So after running this script for a period of time, the following
> race situations may occur:
> 	CPU0:                CPU1:
> 	ipt_do_table
> 	->set_match_v4
> 	->ip_set_test
> 			ipset swap hash_ip1 hash_ip2
> 			ipset destroy hash_ip2
> 	->hash_net4_kadt
> 
> CPU0 found ipset through the index, and at this time, hash_ip2 has been
> destroyed by CPU1 through name search. So CPU0 will crash when accessing
> set->data in the function hash_net4_kadt.
> 
> With this fix in place swap will not succeed because ip_set_test still has
> ref_swapping on the set.
> 
> Both destroy and swap will error out if ref_swapping != 0 on the set.
> 
> Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
> ---
>  net/netfilter/ipset/ip_set_core.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index e5d25df5c64c..d6bd37010bfb 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -741,11 +741,13 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
>  	int ret = 0;
>  
>  	BUG_ON(!set);
> +
> +	__ip_set_get_swapping(set);
>  	pr_debug("set %s, index %u\n", set->name, index);
>  
>  	if (opt->dim < set->type->dimension ||
>  	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
> -		return 0;
> +		goto out;
>  
>  	ret = set->variant->kadt(set, skb, par, IPSET_TEST, opt);
>  
> @@ -764,6 +766,8 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
>  			ret = -ret;
>  	}
>  
> +out:
> +	__ip_set_put_swapping(set);
>  	/* Convert error codes to nomatch */
>  	return (ret < 0 ? 0 : ret);
>  }
> -- 
> 2.17.1

The patch above alas is also not acceptable: it adds locking to a lockless 
area and thus slows down the execution unnecessarily.

If there's a bug, then that must be handled in ip_set_swap() itself, like 
for example adding a quiescent time and waiting for the ongoing users of 
the swapped set to finish their job. You can make it slow there, because 
swapping is not performance critical.

Best regards,
Jozsef
-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
