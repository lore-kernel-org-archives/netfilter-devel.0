From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 10/34] netfilter: ipset: Missing rcu protection in
 mtype_list() fixed
Date: Thu, 7 May 2015 20:19:18 +0200
Message-ID: <20150507181918.GA3654@salvia>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1430587703-3387-11-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42197 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbbEGSOu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 May 2015 14:14:50 -0400
Content-Disposition: inline
In-Reply-To: <1430587703-3387-11-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 02, 2015 at 07:27:59PM +0200, Jozsef Kadlecsik wrote:
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  net/netfilter/ipset/ip_set_hash_gen.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 91e5327..69f2b25 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -1095,10 +1095,12 @@ mtype_list(const struct ip_set *set,
>  
>  	pr_debug("list hash set %s\n", set->name);
>  	t = (const struct htable *) cb->args[IPSET_CB_PRIVATE];
> +	/* Expire may replace a hbucket with another one */
> +	rcu_read_lock();

You should have rebase the previous patches to fix this from the
original patchset.

I don't think it was good idea to keep this large patchset in the
queue, specially with the RCU patches. They are rather critical, and
many follow up not so important patches follow up later on.

I will come back to review the rcu patches, I still have concerns
there.

If you're OK, I'll take as much as I can that is independent your RCU
changes, so you don't need to resend this large patchset, but you will
need to rebase though.

Sorry.
