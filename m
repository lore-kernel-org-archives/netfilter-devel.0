From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: skip checksum verification for outgoing
 rejected ipv6 packets
Date: Tue, 22 Oct 2013 12:55:40 +0200
Message-ID: <20131022105540.GD12157@breakpoint.cc>
References: <20131022083631.GA28194@stfomichev-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kaber@trash.net, kadlec@blackhole.kfki.hu
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34778 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684Ab3JVKzm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:55:42 -0400
Content-Disposition: inline
In-Reply-To: <20131022083631.GA28194@stfomichev-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stanislav Fomichev <stfomichev@yandex-team.ru> wrote:
>  	/* Check checksum. */
> -	if (csum_ipv6_magic(&oip6h->saddr, &oip6h->daddr, otcplen, IPPROTO_TCP,
> +	if (hook != NF_INET_LOCAL_OUT &&
> +	    csum_ipv6_magic(&oip6h->saddr, &oip6h->daddr, otcplen, IPPROTO_TCP,
>  			    skb_checksum(oldskb, tcphoff, otcplen, 0))) {

Could you try using nf_ip6_checksum() here instead of csum_ipv6_magic()?

It has the advantage that it will also skip checksumming in case inbound
packets have already been validated by hardware, etc.

Also this should do the right thing in any case (e.g. local packet
in POST_ROUTING).
