Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D8DC432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 11:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220A42243F
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 11:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbfKTLYw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 06:24:52 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:38482 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbfKTLYw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 06:24:52 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iXO6K-0007TB-TY; Wed, 20 Nov 2019 12:24:48 +0100
Date:   Wed, 20 Nov 2019 12:24:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH libnftnl] set: Add support for NFTA_SET_SUBKEY attributes
Message-ID: <20191120112448.GI8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
References: <20191119010723.39368-1-sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119010723.39368-1-sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Nov 19, 2019 at 02:07:23AM +0100, Stefano Brivio wrote:
[...]
> diff --git a/src/set.c b/src/set.c
> index 78447c6..60a46d8 100644
> --- a/src/set.c
> +++ b/src/set.c
[...]
> @@ -361,6 +366,23 @@ nftnl_set_nlmsg_build_desc_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
>  	mnl_attr_nest_end(nlh, nest);
>  }
>  
> +static void
> +nftnl_set_nlmsg_build_subkey_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
> +{
> +	struct nlattr *nest;
> +	uint32_t v;
> +	uint8_t *l;
> +
> +	nest = mnl_attr_nest_start(nlh, NFTA_SET_SUBKEY);
> +	for (l = s->subkey_len; l - s->subkey_len < NFT_REG32_COUNT; l++) {

While I like pointer arithmetics, too, I don't think it's much use here.
Using good old index variable even allows to integrate the zero value
check:

|	for (i = 0; i < NFT_REG32_COUNT && s->subkey_len[i]; i++)

> +		if (!*l)
> +			break;
> +		v = *l;
> +		mnl_attr_put_u32(nlh, NFTA_SET_SUBKEY_LEN, htonl(v));

I guess you're copying the value here because how htonl() is declared,
but may it change the input value non-temporarily? I mean, libnftnl is
in control over the array so from my point of view it should be OK to
directly pass it to htonl().

Cheers, Phil
