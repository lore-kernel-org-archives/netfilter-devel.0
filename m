From: Andreas Schultz <aschultz@warp10.net>
Subject: Re: nft rules processed in wrong network namespace
Date: Thu, 11 Jun 2015 13:26:17 +0200
Message-ID: <CAASN2uOOe===XGZ+shFH9r=3wKmnv1CWn-JW2pDC5QD_PxK02w@mail.gmail.com>
References: <CAASN2uOcjOKkXamC=FkYJKCJDTcA9nQUa5=OSn6YyUJ8SGvRfg@mail.gmail.com>
	<20150610140143.GA31977@salvia>
	<CAASN2uOP76OfF9QfaRFRMyuch2o5w02spf1=u+UkEoMs3znyHw@mail.gmail.com>
	<20150610152855.GA3406@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34464 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbbFKL0S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2015 07:26:18 -0400
Received: by igbhj9 with SMTP id hj9so53044962igb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jun 2015 04:26:18 -0700 (PDT)
In-Reply-To: <20150610152855.GA3406@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 10, 2015 at 5:28 PM, Patrick McHardy <kaber@trash.net> wrote:

[...]

> If my understanding of the problem is correct, this (totally untested)
> patch should prevent the problem until we have a proper fix.

Yes is does prevent the execution of the chains from the wrong
netns. Some targets are still broken when used in a netns, for
example queue rules instantiated in a netns will not work at
all.

Andreas

>
> diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> index f153b07..62e371a 100644
> --- a/net/netfilter/nf_tables_core.c
> +++ b/net/netfilter/nf_tables_core.c
> @@ -124,6 +124,12 @@ nft_do_chain(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
>         int rulenum;
>         unsigned int gencursor = nft_genmask_cur(net);
>
> +       /* Workaround for processing in incorrect namespace until we have
> +        * per net hooks.
> +        */
> +       if (read_pnet(&(pkt->in ? : pkt->out)->nd_net) != net)
> +               return NF_ACCEPT;
> +
>  do_chain:
>         rulenum = 0;
>         rule = list_entry(&chain->rules, struct nft_rule, list);
