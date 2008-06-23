From: Patrick McHardy <kaber@trash.net>
Subject: Re: Support NAT-ed expect entries from user space
Date: Mon, 23 Jun 2008 17:56:16 +0200
Message-ID: <485FC7A0.6080506@trash.net>
References: <20080616092148.GB2860@phoenix.home> <4856C8C6.3070309@netfilter.org> <4856D28C.3030302@trash.net> <20080616221759.GM2860@phoenix.home> <4856EC99.6070903@trash.net> <20080623153153.GE3261@phoenix.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: BORBELY Zoltan <bozo@andrews.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54718 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbYFWQBu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:01:50 -0400
In-Reply-To: <20080623153153.GE3261@phoenix.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

BORBELY Zoltan wrote:
> On Tue, Jun 17, 2008 at 12:43:37AM +0200, Patrick McHardy wrote:
>   
>> I understand that, the expectation part looks like a subset of what
>> a helper module does though, with the only differences that a helper
>> might want to queue the packet. And since expectfn setup also doesn't
>> belong in nf_conntrack_netlink.c (especially not NAT related expectfns),
>> this is how I think it should be done.
>>     
>
> I attached a new version of the expect setup patch. I think it's general
> enough to include into the kernel. What's your opinion? The saved_ip
> field is only used by the nf_nat_sip and nf_nat_h323 helpers, we only
> need it if we want to set expectfn of our choice.
>
>   
> +++ linux/net/netfilter/nf_conntrack_netlink.c	2008-06-23 17:00:26.000000000 +0200
> +#ifdef CONFIG_NF_NAT_NEEDED
> +	if (cda[CTA_EXPECT_NAT]) {
> +		exp->expectfn = nf_nat_follow_master;
> +		err = nla_parse_nested(tb, CTA_EXPNAT_MAX,
> +				       cda[CTA_EXPECT_NAT], NULL);
> +		if (err < 0)
> +			goto out;
> +
> +		if (tb[CTA_EXPNAT_SAVED_PROTO])
> +			exp->saved_proto.all = nla_get_be16(tb[CTA_EXPNAT_SAVED_PROTO]);
> +		if (tb[CTA_EXPNAT_DIRECTION]) {
> +			exp->dir = nla_get_u8(tb[CTA_EXPNAT_DIRECTION]);
> +			if (exp->dir != IP_CT_DIR_ORIGINAL &&
> +			    exp->dir != IP_CT_DIR_REPLY) {
> +				err = -EINVAL;
> +				goto out;
> +			}
> +		} else
> +			exp->dir = IP_CT_DIR_ORIGINAL;
> +	}
> +#endif
>   

As I said previously, NAT related things don't belong in
nf_conntrack_netlink.c. The existing ones should be moved
out since they add module dependencies that are simply wrong
(conntrack should *never* depend on NAT).

This patch also adds an interface that is too specialized
for your use case instead of doing it in a way that is
generically useful, which would mean at least providing
helper private expectfn selection. The expectfn selection
should probably use the expectation classes, although I'm
open to be convinced otherwise.


