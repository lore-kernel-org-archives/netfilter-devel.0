From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: nf_ct_expect: fix possible invalid
 dereference while event reporting
Date: Fri, 10 Aug 2012 01:34:08 +0200 (MEST)
Message-ID: <Pine.GSO.4.63.1208100128010.26308@stinky-local.trash.net>
References: <1344553332-8536-1-git-send-email-pablo@netfilter.org>
 <1344553332-8536-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33713 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874Ab2HIXeK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:34:10 -0400
In-Reply-To: <1344553332-8536-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 10 Aug 2012, pablo@netfilter.org wrote:

> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> Bump expectation refcount to make sure it does not vanish while
> reporting the event via ctnetlink. One user reported a crash
> while on nf_ct_expect_related_report triggered by the SIP helper.
>
> Reported-by: Rafal Fitt <rafalf@aplusc.com.pl>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I don't think this can be correct. The nf_ct_expect_related_report()
call is usually done through the nf_ct_expect_related() call chain,
in which case the helper still has one refcount for its one reference,
so the helper can't be destroyed at this point. Even if another CPU
tries to remove it again, it will just release the reference of the
expectation hash and not the one the helper is holding.

Am I missing something here?

> ---
> net/netfilter/nf_conntrack_expect.c |    4 ++++
> 1 file changed, 4 insertions(+)
>
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index ec8bb0d..d5fccd3 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -444,8 +444,12 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
> 	ret = nf_ct_expect_insert(expect);
> 	if (ret < 0)
> 		goto out;
> +
> +	atomic_inc(&expect->use);
> 	spin_unlock_bh(&nf_conntrack_lock);
> 	nf_ct_expect_event_report(IPEXP_NEW, expect, pid, report);
> +	nf_ct_expect_put(expect);
> +
> 	return ret;
> out:
> 	spin_unlock_bh(&nf_conntrack_lock);
> -- 
> 1.7.10.4
>
