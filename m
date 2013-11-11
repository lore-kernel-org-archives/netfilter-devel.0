From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 3/3] ipset: Follow manual page behavior for SET target
 on list:set
Date: Mon, 11 Nov 2013 22:38:52 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1311112238240.8236@blackhole.kfki.hu>
References: <2035028.3MjN3UaUgL@tuxracer>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:54599 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab3KKVix (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:38:53 -0500
In-Reply-To: <2035028.3MjN3UaUgL@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 7 Nov 2013, Sergey Popovich wrote:

> ipset(8) for list:set says:
>   The match will try to find a matching entry in the sets and the
>   target will try to add an entry to the first set to which it can
>   be added.
> 
> However real behavior is bit differ from described. Consider example:
> 
>  # ipset create test-1-v4 hash:ip family inet
>  # ipset create test-1-v6 hash:ip family inet6
>  # ipset create test-1 list:set
>  # ipset add test-1 test-1-v4
>  # ipset add test-1 test-1-v6
> 
>  # iptables  -A INPUT -p tcp --destination-port 25 -j SET --add-set test-1 src
>  # ip6tables -A INPUT -p tcp --destination-port 25 -j SET --add-set test-1 src
> 
> And then when iptables/ip6tables rule matches packet IPSET target
> tries to add src from packet to the list:set test-1 where first
> entry is test-1-v4 and the second one is test-1-v6.
> 
> For IPv4, as it first entry in test-1 src added to test-1-v4
> correctly, but for IPv6 src not added!
> 
> Placing test-1-v6 to the first element of list:set makes behavior
> correct for IPv6, but brokes for IPv4.
> 
> This is due to result, returned from ip_set_add() and ip_set_del() from
> net/netfilter/ipset/ip_set_core.c when set in list:set equires more
> parameters than given or address families do not match (which is this
> case).
> 
> It seems wrong returning 0 from ip_set_add() and ip_set_del() in
> this case, as 0 should be returned only when an element successfuly
> added/deleted to/from the set, contrary to ip_set_test() which
> returns 0 when no entry exists and >0 when entry found in set.
> 
> Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>

Patch is applied, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
