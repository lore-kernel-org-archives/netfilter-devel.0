Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC225280A39
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 11:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748431417; cv=none; b=mkjAzc53mtHF7zx12ETiCId8YGv1c1gf/B5Vu/3paiFcleBrrC+7qU4hDia7Urb0oFR0NMJ8oDetzedh2buBWXAH/VO9DEHP1QXxPAZrlCtntkF5KxxwOFvBChOeyM5MAfD02V8GGHg6sF7vXbLr2kWydm8jmbSU3rNaUYyI3CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748431417; c=relaxed/simple;
	bh=UBFk8Odge3x2jFb6stGx4c26X0xGczCF+u7BvSDPfkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bcCe7OCIlTl7dEBHFhev0p2DhbUjbGzKiAJ+mlrLkmUyAeoCNdAYzsxtl7y/RGsnEKzatLrAck17jrUk7O316DSX4RiPA7DgPHzWPFIzFiw4h4KV64L43oeetVfKt5ZYJW25wAI5k0fkrvrAsRCnkt6zTNB7dek2N2W5cifE7Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7B210603EF; Wed, 28 May 2025 13:23:32 +0200 (CEST)
Date: Wed, 28 May 2025 13:22:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
Message-ID: <aDbyDiOBa3_MwsE4@strlen.de>
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>

Yafang Shao <laoar.shao@gmail.com> wrote:
> Our kernel is 6.1.y (also reproduced on 6.14)
> 
> Host Network Configuration:
> --------------------------------------
> 
> We run a DNS proxy on our Kubernetes servers with the following iptables rules:
> 
> -A PREROUTING -d 169.254.1.2/32 -j DNS-DNAT
> -A DNS-DNAT -d 169.254.1.2/32 -i eth0 -j RETURN
> -A DNS-DNAT -d 169.254.1.2/32 -i eth1 -j RETURN
> -A DNS-DNAT -d 169.254.1.2/32 -i bond0 -j RETURN
> -A DNS-DNAT -j DNAT --to-destination 127.0.0.1
> -A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
> -A POSTROUTING -j KUBE-POSTROUTING
> -A KUBE-POSTROUTING -m mark --mark 0x4000/0x4000 -j MASQUERADE
> 
> Container Network Configuration:
> --------------------------------------------
> Containers use 169.254.1.2 as their DNS resolver:
> 
> $ cat /etc/resolve.conf
> nameserver 169.254.1.2
> 
> Issue Description
> ------------------------
> 
> When performing DNS lookups from a container, the query fails with an
> unexpected source port:
> 
> $ dig +short @169.254.1.2 A www.google.com
> ;; reply from unexpected source: 169.254.1.2#123, expected 169.254.1.2#53
> 
> The tcpdump is as follows,
> 
> 16:47:23.441705 veth9cffd2a4 P   IP 10.242.249.78.37562 >
> 169.254.1.2.53: 298+ [1au] A? www.google.com. (55)
> 16:47:23.441705 bridge0 In  IP 10.242.249.78.37562 > 127.0.0.1.53:
> 298+ [1au] A? www.google.com. (55)
> 16:47:23.441856 bridge0 Out IP 169.254.1.2.53 > 10.242.249.78.37562:
> 298 1/0/1 A 142.250.71.228 (59)
> 16:47:23.441863 bond0 Out IP 169.254.1.2.53 > 10.242.249.78.37562: 298
> 1/0/1 A 142.250.71.228 (59)
> 16:47:23.441867 eth1  Out IP 169.254.1.2.53 > 10.242.249.78.37562: 298
> 1/0/1 A 142.250.71.228 (59)
> 16:47:23.441885 eth1  P   IP 169.254.1.2.53 > 10.242.249.78.37562: 298
> 1/0/1 A 142.250.71.228 (59)
> 16:47:23.441885 bond0 P   IP 169.254.1.2.53 > 10.242.249.78.37562: 298
> 1/0/1 A 142.250.71.228 (59)
> 16:47:23.441916 veth9cffd2a4 Out IP 169.254.1.2.124 >
> 10.242.249.78.37562: UDP, length 59
> 
> The DNS response port is unexpectedly changed from 53 to 124, causing
> the application can't receive the response.
> 
> We suspected the issue might be related to commit d8f84a9bc7c4
> ("netfilter: nf_nat: don't try nat source port reallocation for
> reverse dir clash"). After applying this commit, the port remapping no
> longer occurs, but the DNS response is still dropped.

Thats suspicious, I don't see how this is related.  d8f84a9bc7c4
deals with indepdent action, i.e.
 A sends to B and B sends to A, but *at the same time*.

With a request-response protocol like DNS this should obviously never
happen -- B can't reply before A's request has passed through the stack.

> The response is now correctly sent to port 53, but it is dropped in
> __nf_conntrack_confirm().
> 
> We bypassed the issue by modifying __nf_conntrack_confirm()  to skip
> the conflicting conntrack entry check:
> 
> diff --git a/net/netfilter/nf_conntrack_core.c
> b/net/netfilter/nf_conntrack_core.c
> index 7bee5bd22be2..3481e9d333b0 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1245,9 +1245,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
> 
>         chainlen = 0;
>         hlist_nulls_for_each_entry(h, n,
> &nf_conntrack_hash[reply_hash], hnnode) {
> -               if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> -                                   zone, net))
> -                       goto out;
> +               //if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> +               //                  zone, net))
> +               //      goto out;
>                 if (chainlen++ > max_chainlen) {
>  chaintoolong:
>                         NF_CT_STAT_INC(net, chaintoolong);

I don't understand this bit either.  For A/AAAA requests racing in same
direction, nf_ct_resolve_clash() machinery should have handled this
situation.

And I don't see how you can encounter a DNS reply before at least one
request has been committed to the table -- i.e., the conntrack being
confirmed here should not exist -- the packet should have been picked up
as a reply packet.
