From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v6 2/3] netfilter: nat_helper: Register one
 nf_ct_nat_helper each proto nat module
Date: Mon, 15 May 2017 19:20:52 +0200
Message-ID: <20170515172052.GA5872@salvia>
References: <1493945713-67263-1-git-send-email-gfree.wind@vip.163.com>
 <1493945713-67263-2-git-send-email-gfree.wind@vip.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org
To: gfree.wind@vip.163.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54966 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932745AbdEORU5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 13:20:57 -0400
Content-Disposition: inline
In-Reply-To: <1493945713-67263-2-git-send-email-gfree.wind@vip.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 05, 2017 at 08:55:12AM +0800, gfree.wind@vip.163.com wrote:
> diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
> index 346e764..ce2095c 100644
> --- a/net/ipv4/netfilter/nf_nat_h323.c
> +++ b/net/ipv4/netfilter/nf_nat_h323.c
> @@ -21,6 +21,26 @@
>  #include <linux/netfilter/nf_conntrack_h323.h>
>  
>  /****************************************************************************/
> +static void ip_nat_q931_expect(struct nf_conn *new,
> +			       struct nf_conntrack_expect *this);
> +static void ip_nat_callforwarding_expect(struct nf_conn *new,
> +					 struct nf_conntrack_expect *this);
> +
> +static struct nf_ct_nat_helper q931_nat = {
> +	.name		= "Q.931",
> +	.expectfn	= ip_nat_q931_expect,
> +};
> +
> +static struct nf_ct_nat_helper callforwarding_nat = {
> +	.name		= "callforwarding",
> +	.expectfn	= ip_nat_callforwarding_expect,
> +};

Almost there...

> +static struct nf_ct_nat_helper follow_master_nat = {
> +	.name		= "h323-nat-follow-master",

This is a new symbol. There was no "h323-nat-follow-master" before
this patch, and this is exposed to userspace.

This should be "nat-follow-master" instead, so you need a way to
register this for several helpers that support this.

Probably you need a type field, eg.

static struct nf_ct_nat_helper h323_follow_master_nat = {
        .type           = NF_CT_HELPER_H323,
        .name           = "nat-follow-master",
        ...
};

So we can keep using "nat-follow-master" from different helpers, as it
happens currently. This should also allow us to validate if someone
wants to attach a expectfn symbol that is not support by the helper.

We need a way to relate the helper itself with this new
nf_ct_nat_helper structure that doesn't exist in the code yet.
