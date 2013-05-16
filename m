From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: add and use nf_afinfo in xt_addrtype
Date: Thu, 16 May 2013 18:15:30 +0200
Message-ID: <20130516161530.GA7533@localhost>
References: <1368445651-6822-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arpad@andrews.hu
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58026 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839Ab3EPQPf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 May 2013 12:15:35 -0400
Content-Disposition: inline
In-Reply-To: <1368445651-6822-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Mon, May 13, 2013 at 01:47:31PM +0200, Florian Westphal wrote:
[...]
> AFAIU there are two possible solutions:
> 
> a), extend struct nf_afinfo to also register ipv6_chk_addr(), OR
> b), revert the commit that moved ipt_addrtype to xt_addrtype,
>     and keep the ipv6 code in ip6t_addrtype.
> 
> IMO, the latter seems to be preferable, but would be more intrusive.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  As explained earlier, I don't like this approach; IMO the proper solution
>  is to split xt_addrinfo into ipt_addrinfo and ip6t_addrinfo.
>  The only downside is that it will create a bit of code duplication due
>  to checkentry() functions, but it avoids adding is_local_addr hook
>  for the sole purpose of fixing ipv6 xt_addrinfo.

ipv6_find_hdr was also moved from ip6tables to ipv6 core code
recently. Now we got a hard dependency on ipv6 if Hans' HMARK is used
as well. So we need another hook for it. Again, that function is
pretty specific of IPv6. So I think that we can add a new struct
nf_afinfo_ipv6 to keep IPv6-only hooks like this and the one for
ipv6_find. Cong Wang also reported some similar problems when IPv6
dependencies that we could also fix by populating that structure with
more hooks.

I don't like putting this into nf_afinfo either, since it's specific
of IPv6, but I want a small fix that fulfill the -stable rules. It
will take some time until people get the fix for xt_addrtype IPv6 if
we make it the nice way.

Seems like merge ipt and ip6t module is bringing us more problems that
expected.

[...]
>  I can pass a patch for this to davem one net-next is open if
>  you agree with this patch.

I'd like to get this into net asap, it is fixing xt_addrtype for the
IPv6 case, then pass it to -stable.

Thanks.
