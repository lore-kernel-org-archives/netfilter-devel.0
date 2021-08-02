Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AB6C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1937260FC2
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhHBLUd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 07:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbhHBLUc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 07:20:32 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECE0C06175F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Aug 2021 04:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O3qDwKLm98+rsOCVYVBrIz+SJoV+4et1nPJMFJZQ/n8=; b=TVX4PHRB/Jr/fe4zh3NteLqcEk
        01/sTWeC0vkYEp9RABo1XRvjKePFRSLvbyY8jJC+uZDcEl8VenhJRUDk6V2QPpUmK9VPCVgb53x6b
        Txx4wvHgQnhZZxSQE1zgW36ozy4QhsGIsG1gr3NUh3E6HeUot0tJtqoSLHi4V7wr6SCMEwZX0uQOg
        Y/UwdiYVc3lndjJ5stj8qZ43faIqzKLfSB548gRj3JvXWss/29niyIbRJBQ1AM5mwxgoF1RKJKo1i
        4d7KArWBuhVIA0YfDbOrMdCYmIf8pj2/gwAchsZy4Z5Ydle1ZypCK5XLvQYM2ffXkZzRVOqQSaQ2+
        i45dmduQ==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1mAVzY-0005nd-1T; Mon, 02 Aug 2021 12:20:20 +0100
Date:   Mon, 2 Aug 2021 12:20:18 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Kyle Bowman <kbowman@cloudflare.com>
Cc:     Phil Sutter <phil@nwl.cc>, Alex Forster <aforster@cloudflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [PATCH] netfilter: xt_NFLOG: allow 128
 character log prefixes
Message-ID: <YQfU8km0t3clPVhl@azazel.net>
References: <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia>
 <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia>
 <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
 <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
 <20210728014347.GM3673@orbyte.nwl.cc>
 <YQREpVNFRUKtBliI@C02XR1NRJGH8>
 <YQasUsvJpML6CAsy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9h6UpL2SPByObqqE"
Content-Disposition: inline
In-Reply-To: <YQasUsvJpML6CAsy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--9h6UpL2SPByObqqE
Content-Type: multipart/mixed; boundary="7lcPbW/L8LniHgjn"
Content-Disposition: inline


--7lcPbW/L8LniHgjn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[CC trimmed since this is all about Netfilter userspace.]

On 2021-08-01, at 15:14:42 +0100, Jeremy Sowden wrote:
> On 2021-07-30, at 13:27:49 -0500, Kyle Bowman wrote:
> > On Wed, Jul 28, 2021 at 03:43:47AM +0200, Phil Sutter wrote:
> > > You might want to check iptables commit ccf154d7420c0 ("xtables:
> > > Don't use native nftables comments") for reference, it does the
> > > opposite of what you want to do.
> >
> > I went ahead and looked through this commit and also found found the
> > code that initially added this functionality; commit d64ef34a9961
> > ("iptables-compat: use nft built-in comments support ").
> >
> > Additionally I found some other commits that moved code to nft
> > native implementations of the xtables counterpart so that proved
> > helpful.
> >
> > After a couple days of research I did end up figuring out what to do
> > and have added a (mostly complete) native nft log support in
> > iptables-nft. It all seems to work without any kernel changes
> > required. The only problem I'm now faced with is that since we want
> > to take the string passed into the iptables-nft command and add it
> > to the nftnl expression (`NFTNL_EXPR_LOG_PREFIX`) I'm not entirely
> > sure where to get the original sized string from aside from `argv`
> > in the `struct iptables_command_state`. I would get it from the
> > `struct xt_nflog_info`, but that's going to store the truncated
> > version and we would like to be able to store 128 characters of the
> > string as opposed to 64.
> >
> > Any recommendations about how I might do this safely?
>
> The xtables_target struct has a `udata` member which I think would be
> suitable.  libxt_RATEEST does something similar.

Actually, if we embed struct xf_nflog_info in another structure along
with the longer prefix, we can get iptables-nft to print it untruncated.
I've attached a patch.

J.

> > From 0000000000000000000000000000000000000000 Mon Sep 17 00:00:00 2001
> > From: Kbowman <kbowman@cloudflare.com>
> > Date: Thu, 29 Jul 2021 15:12:28 -0500
> > Subject: [PATCH] iptables-nft: use nft built-in logging instead of xt_NFLOG
> >
> > Replaces the use of xt_NFLOG with the nft built-in log statement.
> >
> > This additionally adds support for using longer log prefixes of 128
> > characters in size. A caveat to this is that the string will be
> > truncated when the rule is printed via iptables-nft but will remain
> > untruncated in nftables.
> >
> > Some changes have also been made to nft_is_expr_compatible() since
> > xt_NFLOG does not support log level or log flags. With the new
> > changes this means that when a log is used and sets either
> > NFTNL_EXPR_LOG_LEVEL or NFTNL_LOG_FLAGS to a value aside from their
> > default (log level defaults to 4, log flags will not be set) this
> > will produce a compatibility error.
> > ---
> >  iptables/nft-shared.c | 45 +++++++++++++++++++++++++++++++++++++++++++
> >  iptables/nft.c        | 38 ++++++++++++++++++++++++++++++++++++
> >  iptables/nft.h        |  1 +
> >  3 files changed, 84 insertions(+)
>
> One note about formatting: you've used four spaces for indentation,
> but Netfilter uses tabs.
>
> > diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> > index 4253b081..b5259db0 100644
> > --- a/iptables/nft-shared.c
> > +++ b/iptables/nft-shared.c
> > @@ -22,6 +22,7 @@
> >
> >  #include <linux/netfilter/xt_comment.h>
> >  #include <linux/netfilter/xt_limit.h>
> > +#include <linux/netfilter/xt_NFLOG.h>
> >
> >  #include <libmnl/libmnl.h>
> >  #include <libnftnl/rule.h>
> > @@ -595,6 +596,48 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
> >  		ctx->h->ops->parse_match(match, ctx->cs);
> >  }
> >
> > +static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
> > +{
> > +    __u16 group =  nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_GROUP);
> > +    __u16 qthreshold = nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD);
> > +    __u32 snaplen = nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN);
> > +    const char *prefix = nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX);
> > +    struct xtables_target *target;
> > +    struct xt_entry_target *t;
> > +    size_t target_size;
> > +
> > +    void *data = ctx->cs;
> > +
> > +    target = xtables_find_target("NFLOG", XTF_TRY_LOAD);
> > +    if (target == NULL)
> > +        return;
> > +
> > +    target_size = XT_ALIGN(sizeof(struct xt_entry_target)) + target->size;
> > +
> > +    t = xtables_calloc(1, target_size);
> > +    t->u.target_size = target_size;
> > +    strcpy(t->u.user.name, target->name);
> > +    t->u.user.revision = target->revision;
> > +
> > +    target->t = t;
> > +
> > +    struct xt_nflog_info *info = xtables_malloc(sizeof(struct xt_nflog_info));
> > +    info->group = group;
> > +    info->len = snaplen;
> > +    info->threshold = qthreshold;
> > +
> > +    /* Here, because we allow 128 characters in nftables but only 64
> > +     * characters in xtables (in xt_nflog_info specifically), we may
> > +     * end up truncating the string when parsing it.
> > +     */
> > +    strncpy(info->prefix, prefix, sizeof(info->prefix));
> > +    info->prefix[sizeof(info->prefix) - 1] = '\0';
> > +
> > +    memcpy(&target->t->data, info, target->size);
> > +
> > +    ctx->h->ops->parse_target(target, data);
> > +}
> > +
> >  static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
> >  			     struct nftnl_expr *e)
> >  {
> > @@ -644,6 +687,8 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
> >  			nft_parse_limit(&ctx, expr);
> >  		else if (strcmp(name, "lookup") == 0)
> >  			nft_parse_lookup(&ctx, h, expr);
> > +		else if (strcmp(name, "log") == 0)
> > +		    nft_parse_log(&ctx, expr);
> >
> >  		expr = nftnl_expr_iter_next(iter);
> >  	}
> > diff --git a/iptables/nft.c b/iptables/nft.c
> > index f1deb82f..dce8fe0b 100644
> > --- a/iptables/nft.c
> > +++ b/iptables/nft.c
> > @@ -39,6 +39,7 @@
> >  #include <linux/netfilter/nf_tables_compat.h>
> >
> >  #include <linux/netfilter/xt_limit.h>
> > +#include <linux/netfilter/xt_NFLOG.h>
> >
> >  #include <libmnl/libmnl.h>
> >  #include <libnftnl/gen.h>
> > @@ -1340,6 +1341,8 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
> >  		       ret = add_verdict(r, NF_DROP);
> >  	       else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
> >  		       ret = add_verdict(r, NFT_RETURN);
> > +	       else if (strcmp(cs->jumpto, "NFLOG") == 0)
> > +	           ret = add_log(r, cs);
> >  	       else
> >  		       ret = add_target(r, cs->target->t);
> >         } else if (strlen(cs->jumpto) > 0) {
> > @@ -1352,6 +1355,36 @@ int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
> >         return ret;
> >  }
> >
> > +int add_log(struct nftnl_rule *r, struct iptables_command_state *cs)
> > +{
> > +    struct nftnl_expr *expr;
> > +    struct xt_nflog_info *info = (struct xt_nflog_info *)cs->target->t->data;
> > +
> > +    expr = nftnl_expr_alloc("log");
> > +    if (!expr)
> > +        return -ENOMEM;
> > +
> > +    if (info->prefix != NULL) {
> > +        //char prefix[NF_LOG_PREFIXLEN] = {};
> > +
> > +        // get prefix here from somewhere...
> > +        // maybe in cs->argv?
> > +        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, "iff the value at the end is 12 then this string is truncated 123");
> > +    }
> > +    if (info->group) {
> > +        nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
> > +        if (info->flags & XT_NFLOG_F_COPY_LEN)
> > +            nftnl_expr_set_u32(expr, NFTNL_EXPR_LOG_SNAPLEN,
> > +                               info->len);
> > +        if (info->threshold)
> > +            nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_QTHRESHOLD,
> > +                               info->threshold);
> > +    }
> > +
> > +    nftnl_rule_add_expr(r, expr);
> > +    return 0;
> > +}
> > +
> >  static void nft_rule_print_debug(struct nftnl_rule *r, struct nlmsghdr *nlh)
> >  {
> >  #ifdef NLDEBUG
> > @@ -3487,6 +3520,11 @@ static int nft_is_expr_compatible(struct nftnl_expr *expr, void *data)
> >  	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LIMIT_FLAGS) == 0)
> >  		return 0;
> >
> > +	if (!strcmp(name, "log") &&
> > +	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LOG_LEVEL) == 4 &&
> > +	    !nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_FLAGS))
> > +	    return 0;
> > +
> >  	return -1;
> >  }
> >
> > diff --git a/iptables/nft.h b/iptables/nft.h
> > index 4ac7e009..28dc81b7 100644
> > --- a/iptables/nft.h
> > +++ b/iptables/nft.h
> > @@ -193,6 +193,7 @@ int add_match(struct nft_handle *h, struct nftnl_rule *r, struct xt_entry_match
> >  int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
> >  int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
> >  int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
> > +int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
> >  char *get_comment(const void *data, uint32_t data_len);
> >
> >  enum nft_rule_print {
> > --
> > 2.32.0

--7lcPbW/L8LniHgjn
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="0001-extensions-libxt_NFLOG-embed-struct-xt_nflog_info-in.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 3c18555c6356e03731812688d7e6956a04ce820e Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Sun, 1 Aug 2021 14:47:52 +0100
Subject: [PATCH] extensions: libxt_NFLOG: embed struct xt_nflog_info in
 another structure to store longer prefixes suitable for the nft log
 statement.

NFLOG truncates the log-prefix to 64 characters which is the limit
supported by iptables-legacy.  We now store the longer 128-character
prefix in a new structure, struct xt_nflog_state, alongside the struct
xt_nflog_info for use by iptables-nft.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.c | 38 ++++++++++++++++++++++++++++----------
 extensions/libxt_NFLOG.h | 12 ++++++++++++
 iptables/nft-shared.c    | 17 +++++++++++------
 iptables/nft.c           | 10 ++++------
 4 files changed, 55 insertions(+), 22 deletions(-)
 create mode 100644 extensions/libxt_NFLOG.h

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 02a1b4aa35a3..6e1482122f11 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -8,6 +8,8 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFLOG.h>
=20
+#include "libxt_NFLOG.h"
+
 enum {
 	O_GROUP =3D 0,
 	O_PREFIX,
@@ -53,12 +55,17 @@ static void NFLOG_init(struct xt_entry_target *t)
=20
 static void NFLOG_parse(struct xt_option_call *cb)
 {
+	struct xt_nflog_state *state =3D (struct xt_nflog_state *)cb->data;
+
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_PREFIX:
 		if (strchr(cb->arg, '\n') !=3D NULL)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines not allowed in --log-prefix");
+
+		snprintf(state->nf_log_prefix, sizeof(state->nf_log_prefix),
+			 "%s", cb->arg);
 		break;
 	}
 }
@@ -75,11 +82,26 @@ static void NFLOG_check(struct xt_fcheck_call *cb)
 		info->flags |=3D XT_NFLOG_F_COPY_LEN;
 }
=20
-static void nflog_print(const struct xt_nflog_info *info, char *prefix)
+static void nflog_print(const void *data, size_t target_size,
+			const char *prefix)
 {
+	size_t data_size =3D target_size - offsetof(struct xt_entry_target, data);
+	const struct xt_nflog_info *info;
+	const char *nf_log_prefix;
+
+	if (data_size =3D=3D XT_ALIGN(sizeof(struct xt_nflog_state))) {
+		const struct xt_nflog_state *state =3D data;
+
+		info =3D &state->info;
+		nf_log_prefix =3D state->nf_log_prefix;
+	} else {
+		info =3D data;
+		nf_log_prefix =3D NULL;
+	}
+
 	if (info->prefix[0] !=3D '\0') {
 		printf(" %snflog-prefix ", prefix);
-		xtables_save_string(info->prefix);
+		xtables_save_string(nf_log_prefix ? : info->prefix);
 	}
 	if (info->group)
 		printf(" %snflog-group %u", prefix, info->group);
@@ -94,16 +116,12 @@ static void nflog_print(const struct xt_nflog_info *in=
fo, char *prefix)
 static void NFLOG_print(const void *ip, const struct xt_entry_target *targ=
et,
 			int numeric)
 {
-	const struct xt_nflog_info *info =3D (struct xt_nflog_info *)target->data;
-
-	nflog_print(info, "");
+	nflog_print(target->data, target->u.target_size, "");
 }
=20
 static void NFLOG_save(const void *ip, const struct xt_entry_target *targe=
t)
 {
-	const struct xt_nflog_info *info =3D (struct xt_nflog_info *)target->data;
-
-	nflog_print(info, "--");
+	nflog_print(target->data, target->u.target_size, "--");
 }
=20
 static void nflog_print_xlate(const struct xt_nflog_info *info,
@@ -139,8 +157,8 @@ static struct xtables_target nflog_target =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.name		=3D "NFLOG",
 	.version	=3D XTABLES_VERSION,
-	.size		=3D XT_ALIGN(sizeof(struct xt_nflog_info)),
-	.userspacesize	=3D XT_ALIGN(sizeof(struct xt_nflog_info)),
+	.size		=3D XT_ALIGN(sizeof(struct xt_nflog_state)),
+	.userspacesize	=3D XT_ALIGN(sizeof(struct xt_nflog_state)),
 	.help		=3D NFLOG_help,
 	.init		=3D NFLOG_init,
 	.x6_fcheck	=3D NFLOG_check,
diff --git a/extensions/libxt_NFLOG.h b/extensions/libxt_NFLOG.h
new file mode 100644
index 000000000000..f3599a77ef2e
--- /dev/null
+++ b/extensions/libxt_NFLOG.h
@@ -0,0 +1,12 @@
+#ifndef LIBXT_NFLOG_H_INCLUDED
+#define LIBXT_NFLOG_H_INCLUDED
+
+#include <linux/netfilter/nf_log.h>
+#include <linux/netfilter/xt_NFLOG.h>
+
+struct xt_nflog_state {
+	struct xt_nflog_info info;
+	char nf_log_prefix[NF_LOG_PREFIXLEN];
+};
+
+#endif /* !defined(LIBXT_NFLOG_H_INCLUDED) */
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index b5259db07723..0a9c4de034be 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -32,6 +32,7 @@
 #include "nft-bridge.h"
 #include "xshared.h"
 #include "nft.h"
+#include "extensions/libxt_NFLOG.h"
=20
 extern struct nft_family_ops nft_family_ops_ipv4;
 extern struct nft_family_ops nft_family_ops_ipv6;
@@ -621,19 +622,23 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, str=
uct nftnl_expr *e)
=20
     target->t =3D t;
=20
-    struct xt_nflog_info *info =3D xtables_malloc(sizeof(struct xt_nflog_i=
nfo));
+    struct xt_nflog_state state =3D { 0 };
+
+    struct xt_nflog_info *info =3D &state.info;
     info->group =3D group;
     info->len =3D snaplen;
     info->threshold =3D qthreshold;
=20
     /* Here, because we allow 128 characters in nftables but only 64
-     * characters in xtables (in xt_nflog_info specifically), we may
-     * end up truncating the string when parsing it.
+     * characters in xtables (in xt_nflog_info specifically), we may end up
+     * truncating the string when parsing it.  The longer prefix will be
+     * available in state.nf_log_prefix.
      */
-    strncpy(info->prefix, prefix, sizeof(info->prefix));
-    info->prefix[sizeof(info->prefix) - 1] =3D '\0';
+    snprintf(info->prefix, sizeof(info->prefix), "%s", prefix);
+
+    snprintf(state.nf_log_prefix, sizeof(state.nf_log_prefix), "%s", prefi=
x);
=20
-    memcpy(&target->t->data, info, target->size);
+    memcpy(&target->t->data, &state, sizeof(state));
=20
     ctx->h->ops->parse_target(target, data);
 }
diff --git a/iptables/nft.c b/iptables/nft.c
index dce8fe0b4a18..addcfffdd0cc 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -59,6 +59,7 @@
 #include "nft-cache.h"
 #include "nft-shared.h"
 #include "nft-bridge.h" /* EBT_NOPROTO */
+#include "extensions/libxt_NFLOG.h"
=20
 static void *nft_fn;
=20
@@ -1358,18 +1359,15 @@ int add_action(struct nftnl_rule *r, struct iptable=
s_command_state *cs,
 int add_log(struct nftnl_rule *r, struct iptables_command_state *cs)
 {
     struct nftnl_expr *expr;
-    struct xt_nflog_info *info =3D (struct xt_nflog_info *)cs->target->t->=
data;
+    struct xt_nflog_state *state =3D (struct xt_nflog_state *)cs->target->=
t->data;
+    struct xt_nflog_info *info =3D &state->info;
=20
     expr =3D nftnl_expr_alloc("log");
     if (!expr)
         return -ENOMEM;
=20
     if (info->prefix !=3D NULL) {
-        //char prefix[NF_LOG_PREFIXLEN] =3D {};
-
-        // get prefix here from somewhere...
-        // maybe in cs->argv?
-        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, "iff the value at =
the end is 12 then this string is truncated 123");
+        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, state->nf_log_pref=
ix);
     }
     if (info->group) {
         nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
--=20
2.30.2


--7lcPbW/L8LniHgjn--

--9h6UpL2SPByObqqE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEH1OsACgkQKYasCr3x
BA11Tg//Ww6haCyW6dcYN5mMyGrsjsAzt5YSuRK9K1rblDDR4xhIH/ZRWRHms6n6
PBBuOxdoH6tnwL/ql+Lu5urbyjXJpzCl3QR/w2KRmzcGRNQS6p/QwBsVcS7aSQ4p
8Zu1xPiZOHTQBmrddM1CMMQD3QxA/gjZUPILv8TRaz2OllZJrd0E3PO+sKGwHE1S
o11JCuyn37ja7C4KxWcdx81FLyaiS4tCUbE6gthR0rtYnTMVV0Njv/0ddcrLMWUl
0KKxTMK0x3/W7NzG9orraJZf4lwgURukNa4ykfC2Wnkcsg7FdkPSU39YmS5dK37p
swij9hrKFRBhpyc+ABqO9ibmN/oRSU6+zGCFophKYyXyYD2zOZ/Fvhq6bXzpsMfs
Asb7SPjvcTny0+hIpPSMQpMm8/3oYMtgXn9RI1yutvnbsTisylTt4OKTasEL5wjk
/X4YNoHSuKeH2vFGt66Z+cWJTVpznK+sobiRvl72KtUl8otmrYvjxl74r7kUbACA
OKqdmkMGDQ9TwC2biEflEU8ouhGaRZNy9l9FvZgXbaFDxZ30mXfGAZ/enTQLZp9n
lwCzd6zmOPLivdaavx7Eb0rBujiCKMXF42lL1q9adh6+33iUNioSWa3LLaOf19Ng
K/2XsXkw/Sox5EE+WEzdXc9Wh6NCE5Cd5h1/y/vJjUt2tLzR/K0=
=NROm
-----END PGP SIGNATURE-----

--9h6UpL2SPByObqqE--
