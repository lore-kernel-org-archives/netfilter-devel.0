Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4090D7260D;
	Thu, 25 Jun 2026 07:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782372659; cv=none; b=S1utWJLCrbvkKm951O7FRmRJhwWObttraQsa9GVu0hx4XBo3pY7M5ojIPk3lUN45jc7LTOiROWtbs1kC0sjvnuSIWOUbixhraULrbgaPky1CHaC/4LegSXBX1AqBHRY3MvKrs/olvDjByKwQZuiiVzmnb+AnXdNJLKqyyHfImU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782372659; c=relaxed/simple;
	bh=L0353zEMEtdSh7bVVdcWIzM0c9UguQfgQW33erWXeSE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=L8+3GHN7aitSvspQJY5SvhATIGgl5c64IxTx9yqIPRNrdQChxCrFatHxkIpRpxjfy+atyuChaM92Wc0n5qnmOCfBLlSixmh6i1SZpdfFWxYLkVqub4t7PLS8SNwPY0XkmTP5cGp48qAGHsF1no4itDPNqIVueCmAhWnoACCukVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=mlMi4KQj; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="mlMi4KQj"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gm9GM3khDz7s7wk;
	Thu, 25 Jun 2026 09:21:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1782372089; x=1784186490; bh=bRSr6OoZ9J
	JPnp3T3cmji4ZfZNrVf7E0txBMBISE3Zg=; b=mlMi4KQjQavRrlko1sMJG1eojF
	B6JiNHsN2TdnkDMTgAWJz8f/cDu7t+qoN33eiXQrD5Q6HSalEuq8kerBs1nRxKRm
	o5SOT9jspEPVlEc4/i8FJVT3J7kw2BslH+UTVF7AkfOdOZmVDnT2feRz5sw7GkPR
	1K3Pf0H91vKaL6iG0=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id fABJDYI3Poh3; Thu, 25 Jun 2026 09:21:29 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gm9GJ6tlSz7s7wR;
	Thu, 25 Jun 2026 09:21:28 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id D161F34317F; Thu, 25 Jun 2026 09:21:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id CF0EA34317E;
	Thu, 25 Jun 2026 09:21:28 +0200 (CEST)
Date: Thu, 25 Jun 2026 09:21:28 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Xiang Mei <xmei5@asu.edu>
cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>, 
    Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>, 
    netfilter-devel@vger.kernel.org, kees@kernel.org, horms@kernel.org, 
    Weiming Shi <bestswngs@gmail.com>, coreteam@netfilter.org, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: fix race between dump and ip_set_list
 resize
In-Reply-To: <20260625010006.1448558-1-xmei5@asu.edu>
Message-ID: <0cc0f340-3b68-13ab-cbb7-a6904fdae396@blackhole.kfki.hu>
References: <20260625010006.1448558-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi,

On Wed, 24 Jun 2026, Xiang Mei wrote:

> The release path of ip_set_dump_do() and ip_set_dump_done() read
> inst->ip_set_list via ip_set_ref_netlink(), a plain rcu_dereference_raw()
> of the array pointer. These run from netlink_recvmsg() without the nfnl
> mutex and without an RCU read-side critical section.
>
> A concurrent ip_set_create() can grow the array: it publishes the new
> array, calls synchronize_net() and then kvfree()s the old one. Since the
> dump paths read the array outside any RCU reader, synchronize_net() does
> not wait for them and the old array can be freed while they still index
> into it, causing a use-after-free.
>
> The dumped set itself stays pinned via set->ref_netlink, so only the
> array load needs protecting. Take rcu_read_lock() around it, matching
> ip_set_get_byname() and __ip_set_put_byindex().
>
>  BUG: KASAN: slab-use-after-free in ip_set_dump_do (net/netfilter/ipset/ip_set_core.c:1697)
>  Read of size 8 at addr ffff88800b5c4018 by task exploit/150
>  Call Trace:
>   ...
>   kasan_report (mm/kasan/report.c:595)
>   ip_set_dump_do (net/netfilter/ipset/ip_set_core.c:1697)
>   netlink_dump (net/netlink/af_netlink.c:2325)
>   netlink_recvmsg (net/netlink/af_netlink.c:1976)
>   sock_recvmsg (net/socket.c:1159)
>   __sys_recvfrom (net/socket.c:2315)
>   ...
>  Oops: general protection fault, probably for non-canonical address ... KASAN NOPTI
>  KASAN: maybe wild-memory-access in range [0x02d6...d0-0x02d6...d7]
>  RIP: 0010:ip_set_dump_do (net/netfilter/ipset/ip_set_core.c:1698)
>  Kernel panic - not syncing: Fatal exception
>
> Fixes: 8a02bdd50b2e ("netfilter: ipset: Fix calling ip_set() macro at dumping")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>

Thank you for the nice report and fix, good catch.

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
> ---
> net/netfilter/ipset/ip_set_core.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index a531b654b8d9..6cfad152d7d1 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1480,7 +1480,11 @@ ip_set_dump_done(struct netlink_callback *cb)
> 		struct ip_set_net *inst =
> 			(struct ip_set_net *)cb->args[IPSET_CB_NET];
> 		ip_set_id_t index = (ip_set_id_t)cb->args[IPSET_CB_INDEX];
> -		struct ip_set *set = ip_set_ref_netlink(inst, index);
> +		struct ip_set *set;
> +
> +		rcu_read_lock();
> +		set = ip_set_ref_netlink(inst, index);
> +		rcu_read_unlock();
>
> 		if (set->variant->uref)
> 			set->variant->uref(set, cb, false);
> @@ -1686,7 +1690,9 @@ ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
> release_refcount:
> 	/* If there was an error or set is done, release set */
> 	if (ret || !cb->args[IPSET_CB_ARG0]) {
> +		rcu_read_lock();
> 		set = ip_set_ref_netlink(inst, index);
> +		rcu_read_unlock();
> 		if (set->variant->uref)
> 			set->variant->uref(set, cb, false);
> 		pr_debug("release set %s\n", set->name);
> -- 
> 2.43.0
>
>
>
