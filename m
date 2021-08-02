Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17682C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 16:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E85B2610FF
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 16:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhHBQkx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 12:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhHBQkx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 12:40:53 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81D5C06175F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Aug 2021 09:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=boyVOmG9JeWJnfYRkukFKe/ESrURz/mM65h+1rMtPvg=; b=CfuR3wZ/v5AFdaEZgOkX7e3rw2
        89RZc2uAaYEZREZ7P4aa0V3iAbs7WzbObddC5eXwf7UF/i3oNX17R0oB4dobgiarFfV8J4vfyaFxb
        /KiUygu0N93O72SKzU5K+Y5a3pOiZ4nvhXkSbtM2eHfcnHcDXsspx5dS2elooSoGm3z7iS6u6N+7v
        RYye1smj9UCFxy2bypDMhKr2wPY2o5ow9NmAjAZV+L3fqMwOSe7Cm4y7XH0P3ur2a7AewACqZYggY
        obgg9n9zca5XHsMxBkk5SIEoccDBfKry41CONCAKF6wBNy2NvzG+RVg7ckTcklrYfB2/7D0UEMER4
        TL2BiDNQ==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1mAazW-00055J-BD; Mon, 02 Aug 2021 17:40:38 +0100
Date:   Mon, 2 Aug 2021 17:40:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Kyle Bowman <kbowman@cloudflare.com>
Cc:     Phil Sutter <phil@nwl.cc>, Alex Forster <aforster@cloudflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [PATCH] netfilter: xt_NFLOG: allow 128
 character log prefixes
Message-ID: <YQggBDBruNxkscoi@azazel.net>
References: <20210727211029.GA17432@salvia>
 <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia>
 <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
 <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
 <20210728014347.GM3673@orbyte.nwl.cc>
 <YQREpVNFRUKtBliI@C02XR1NRJGH8>
 <YQasUsvJpML6CAsy@azazel.net>
 <YQfU8km0t3clPVhl@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="F5SacCheO8kQTkxT"
Content-Disposition: inline
In-Reply-To: <YQfU8km0t3clPVhl@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--F5SacCheO8kQTkxT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-02, at 12:20:18 +0100, Jeremy Sowden wrote:
> On 2021-08-01, at 15:14:42 +0100, Jeremy Sowden wrote:
> > On 2021-07-30, at 13:27:49 -0500, Kyle Bowman wrote:
> > > On Wed, Jul 28, 2021 at 03:43:47AM +0200, Phil Sutter wrote:
> > > > You might want to check iptables commit ccf154d7420c0 ("xtables:
> > > > Don't use native nftables comments") for reference, it does the
> > > > opposite of what you want to do.
> > >
> > > I went ahead and looked through this commit and also found found the
> > > code that initially added this functionality; commit d64ef34a9961
> > > ("iptables-compat: use nft built-in comments support ").
> > >
> > > Additionally I found some other commits that moved code to nft
> > > native implementations of the xtables counterpart so that proved
> > > helpful.
> > >
> > > After a couple days of research I did end up figuring out what to do
> > > and have added a (mostly complete) native nft log support in
> > > iptables-nft. It all seems to work without any kernel changes
> > > required. The only problem I'm now faced with is that since we want
> > > to take the string passed into the iptables-nft command and add it
> > > to the nftnl expression (`NFTNL_EXPR_LOG_PREFIX`) I'm not entirely
> > > sure where to get the original sized string from aside from `argv`
> > > in the `struct iptables_command_state`. I would get it from the
> > > `struct xt_nflog_info`, but that's going to store the truncated
> > > version and we would like to be able to store 128 characters of the
> > > string as opposed to 64.
> > >
> > > Any recommendations about how I might do this safely?
> >
> > The xtables_target struct has a `udata` member which I think would be
> > suitable.  libxt_RATEEST does something similar.
>
> Actually, if we embed struct xf_nflog_info in another structure along
> with the longer prefix, we can get iptables-nft to print it untruncated.

> From 3c18555c6356e03731812688d7e6956a04ce820e Mon Sep 17 00:00:00 2001
> From: Jeremy Sowden <jeremy@azazel.net>
> Date: Sun, 1 Aug 2021 14:47:52 +0100
> Subject: [PATCH] extensions: libxt_NFLOG: embed struct xt_nflog_info in
>  another structure to store longer prefixes suitable for the nft log
>  statement.
>
> NFLOG truncates the log-prefix to 64 characters which is the limit
> supported by iptables-legacy.  We now store the longer 128-character
> prefix in a new structure, struct xt_nflog_state, alongside the struct
> xt_nflog_info for use by iptables-nft.
>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  extensions/libxt_NFLOG.c | 38 ++++++++++++++++++++++++++++----------
>  extensions/libxt_NFLOG.h | 12 ++++++++++++
>  iptables/nft-shared.c    | 17 +++++++++++------
>  iptables/nft.c           | 10 ++++------
>  4 files changed, 55 insertions(+), 22 deletions(-)
>  create mode 100644 extensions/libxt_NFLOG.h
>
> diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
> index 02a1b4aa35a3..6e1482122f11 100644
> --- a/extensions/libxt_NFLOG.c
> +++ b/extensions/libxt_NFLOG.c
> @@ -8,6 +8,8 @@
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter/xt_NFLOG.h>
>
> +#include "libxt_NFLOG.h"
> +
>  enum {
>  	O_GROUP = 0,
>  	O_PREFIX,
> @@ -53,12 +55,17 @@ static void NFLOG_init(struct xt_entry_target *t)
>
>  static void NFLOG_parse(struct xt_option_call *cb)
>  {
> +	struct xt_nflog_state *state = (struct xt_nflog_state *)cb->data;
> +
>  	xtables_option_parse(cb);
>  	switch (cb->entry->id) {
>  	case O_PREFIX:
>  		if (strchr(cb->arg, '\n') != NULL)
>  			xtables_error(PARAMETER_PROBLEM,
>  				   "Newlines not allowed in --log-prefix");
> +
> +		snprintf(state->nf_log_prefix, sizeof(state->nf_log_prefix),
> +			 "%s", cb->arg);
>  		break;
>  	}
>  }
> @@ -75,11 +82,26 @@ static void NFLOG_check(struct xt_fcheck_call *cb)
>  		info->flags |= XT_NFLOG_F_COPY_LEN;
>  }
>
> -static void nflog_print(const struct xt_nflog_info *info, char *prefix)
> +static void nflog_print(const void *data, size_t target_size,
> +			const char *prefix)
>  {
> +	size_t data_size = target_size - offsetof(struct xt_entry_target, data);
> +	const struct xt_nflog_info *info;
> +	const char *nf_log_prefix;
> +
> +	if (data_size == XT_ALIGN(sizeof(struct xt_nflog_state))) {
> +		const struct xt_nflog_state *state = data;
> +
> +		info = &state->info;
> +		nf_log_prefix = state->nf_log_prefix;
> +	} else {
> +		info = data;
> +		nf_log_prefix = NULL;
> +	}
> +
>  	if (info->prefix[0] != '\0') {
>  		printf(" %snflog-prefix ", prefix);
> -		xtables_save_string(info->prefix);
> +		xtables_save_string(nf_log_prefix ? : info->prefix);
>  	}
>  	if (info->group)
>  		printf(" %snflog-group %u", prefix, info->group);
> @@ -94,16 +116,12 @@ static void nflog_print(const struct xt_nflog_info *info, char *prefix)
>  static void NFLOG_print(const void *ip, const struct xt_entry_target *target,
>  			int numeric)
>  {
> -	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
> -
> -	nflog_print(info, "");
> +	nflog_print(target->data, target->u.target_size, "");
>  }
>
>  static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
>  {
> -	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
> -
> -	nflog_print(info, "--");
> +	nflog_print(target->data, target->u.target_size, "--");
>  }
>
>  static void nflog_print_xlate(const struct xt_nflog_info *info,
> @@ -139,8 +157,8 @@ static struct xtables_target nflog_target = {
>  	.family		= NFPROTO_UNSPEC,
>  	.name		= "NFLOG",
>  	.version	= XTABLES_VERSION,
> -	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
> -	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_info)),
> +	.size		= XT_ALIGN(sizeof(struct xt_nflog_state)),
> +	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_state)),

Unfortuantely the change in size breaks iptables-legacy.  Whoops.  More
thought required.

>  	.help		= NFLOG_help,
>  	.init		= NFLOG_init,
>  	.x6_fcheck	= NFLOG_check,
> diff --git a/extensions/libxt_NFLOG.h b/extensions/libxt_NFLOG.h
> new file mode 100644
> index 000000000000..f3599a77ef2e
> --- /dev/null
> +++ b/extensions/libxt_NFLOG.h
> @@ -0,0 +1,12 @@
> +#ifndef LIBXT_NFLOG_H_INCLUDED
> +#define LIBXT_NFLOG_H_INCLUDED
> +
> +#include <linux/netfilter/nf_log.h>
> +#include <linux/netfilter/xt_NFLOG.h>
> +
> +struct xt_nflog_state {
> +	struct xt_nflog_info info;
> +	char nf_log_prefix[NF_LOG_PREFIXLEN];
> +};
> +
> +#endif /* !defined(LIBXT_NFLOG_H_INCLUDED) */
> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index b5259db07723..0a9c4de034be 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -32,6 +32,7 @@
>  #include "nft-bridge.h"
>  #include "xshared.h"
>  #include "nft.h"
> +#include "extensions/libxt_NFLOG.h"
>
>  extern struct nft_family_ops nft_family_ops_ipv4;
>  extern struct nft_family_ops nft_family_ops_ipv6;
> @@ -621,19 +622,23 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
>
>      target->t = t;
>
> -    struct xt_nflog_info *info = xtables_malloc(sizeof(struct xt_nflog_info));
> +    struct xt_nflog_state state = { 0 };
> +
> +    struct xt_nflog_info *info = &state.info;
>      info->group = group;
>      info->len = snaplen;
>      info->threshold = qthreshold;
>
>      /* Here, because we allow 128 characters in nftables but only 64
> -     * characters in xtables (in xt_nflog_info specifically), we may
> -     * end up truncating the string when parsing it.
> +     * characters in xtables (in xt_nflog_info specifically), we may end up
> +     * truncating the string when parsing it.  The longer prefix will be
> +     * available in state.nf_log_prefix.
>       */
> -    strncpy(info->prefix, prefix, sizeof(info->prefix));
> -    info->prefix[sizeof(info->prefix) - 1] = '\0';
> +    snprintf(info->prefix, sizeof(info->prefix), "%s", prefix);
> +
> +    snprintf(state.nf_log_prefix, sizeof(state.nf_log_prefix), "%s", prefix);
>
> -    memcpy(&target->t->data, info, target->size);
> +    memcpy(&target->t->data, &state, sizeof(state));
>
>      ctx->h->ops->parse_target(target, data);
>  }
> diff --git a/iptables/nft.c b/iptables/nft.c
> index dce8fe0b4a18..addcfffdd0cc 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -59,6 +59,7 @@
>  #include "nft-cache.h"
>  #include "nft-shared.h"
>  #include "nft-bridge.h" /* EBT_NOPROTO */
> +#include "extensions/libxt_NFLOG.h"
>
>  static void *nft_fn;
>
> @@ -1358,18 +1359,15 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
>  int add_log(struct nftnl_rule *r, struct iptables_command_state *cs)
>  {
>      struct nftnl_expr *expr;
> -    struct xt_nflog_info *info = (struct xt_nflog_info *)cs->target->t->data;
> +    struct xt_nflog_state *state = (struct xt_nflog_state *)cs->target->t->data;
> +    struct xt_nflog_info *info = &state->info;
>
>      expr = nftnl_expr_alloc("log");
>      if (!expr)
>          return -ENOMEM;
>
>      if (info->prefix != NULL) {
> -        //char prefix[NF_LOG_PREFIXLEN] = {};
> -
> -        // get prefix here from somewhere...
> -        // maybe in cs->argv?
> -        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, "iff the value at the end is 12 then this string is truncated 123");
> +        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, state->nf_log_prefix);
>      }
>      if (info->group) {
>          nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
> --
> 2.30.2

--F5SacCheO8kQTkxT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEIIAQACgkQKYasCr3x
BA2lMhAArUyRcTA1LqD9pLA5lq0lCyIU7LUeQrF5PP7adeIpImKtKr3thD1S09UE
iLYDGxMif1LiQ7aJn+q3cQ+T1N3nyNpfLirPuVXnYrcPEdnYudjud+0aRTHJhcsc
L81YQ8jSYb9Mif2Qxhyc0rfFTM8ggFASjMlT6PMuLvGK8kxUxyRRgxsUxNZKZVMo
U2otwexVUDSKupXnnOKCx+OFlujlNkf2mUOvP8p7lbOCWfasFxyfa9gxlRKjlSz6
Yv2ncE+fJ04RkoUug9j69x5gPV3OPw84wC5TWZJG5NOlLrbY32uRXVpUBY3fe28M
XdVZNBN41za0BQfyLv0q68vz/1UnGJKnSarS8WE5t9Yek7DL6mRSEZ1/dYaIvvvS
DoF2bLZCkwR7cSgU/zlBVOb8so5Y1pwd7w+b3dsajq0lGwPuqFtnQcNXfpc4CtA0
5vN4Jjcl3DiqoALVufn1Ozd1GpEQ40KVMc3fOhrqVwhg0+2jY/3ZKHa7R86P9Ukl
lgRY4wxOhfswHP7Oc4EjfiiJVcXWRR3KVyn+1D1j7vTqwhlpvPtCVhsE0c+sSAxe
fHsJb1UzEcipLHsBM1RHU5+vod6tJArw0OANQnaWMVkcpolojtnYCJGc6V4RNkBT
vAGm+CV47pRH+/53x3L/SLOqDJf52orPZMpv12QmE5lq6j4Ku24=
=rGTX
-----END PGP SIGNATURE-----

--F5SacCheO8kQTkxT--
