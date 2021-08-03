Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3010CC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 09:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 173DB60C3F
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 09:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhHCJHB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 05:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbhHCJG7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 05:06:59 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B4EC061764
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Aug 2021 02:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7pqo9m/rL1Qu11B084KnzhWQnOC2g0uVQ2AEEzZ5w00=; b=j7+GbtgXfamE5Dz+Aa+oSqMU2k
        ++d/sTJBDDG/9hOT/WzUV/sH3ftdZPb+Of2P/c3fMIMxrNA0typ6kQPSGybRH4ibm0yHwCSlf3pXH
        EEYq1jJb2sfPVE1R3536zkcArYaFBe8caQJNGIk7pvmAuCfFVkgWaqJ2IHp0PgpeZlPM1KZK40Gue
        z9/0/U80+1g+nx606WvvRxIAFUcbTHnY8As1ciU7egHklmfPgT3ZCgOJsQs0waFexP8MQMLVe5EHP
        Sk9MY596RZ8ue4zESQooQU978i/Z9cUhTfwmt1mIswxAfC/ev59bg0PgkI6wAmoXgZTRq+PfatlZ5
        jslg3AIA==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1mAqNn-00039l-1L; Tue, 03 Aug 2021 10:06:43 +0100
Date:   Tue, 3 Aug 2021 10:06:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Kyle Bowman <kbowman@cloudflare.com>
Cc:     Phil Sutter <phil@nwl.cc>, Alex Forster <aforster@cloudflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [PATCH] netfilter: xt_NFLOG: allow 128
 character log prefixes
Message-ID: <YQkHIamDpqBzmNrO@azazel.net>
References: <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia>
 <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
 <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
 <20210728014347.GM3673@orbyte.nwl.cc>
 <YQREpVNFRUKtBliI@C02XR1NRJGH8>
 <YQasUsvJpML6CAsy@azazel.net>
 <YQfU8km0t3clPVhl@azazel.net>
 <YQggBDBruNxkscoi@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="k5Scy5fcAa2R8Q8x"
Content-Disposition: inline
In-Reply-To: <YQggBDBruNxkscoi@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--k5Scy5fcAa2R8Q8x
Content-Type: multipart/mixed; boundary="ODWB8P+5zo3kGLF9"
Content-Disposition: inline


--ODWB8P+5zo3kGLF9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-02, at 17:40:36 +0100, Jeremy Sowden wrote:
> On 2021-08-02, at 12:20:18 +0100, Jeremy Sowden wrote:
> > On 2021-08-01, at 15:14:42 +0100, Jeremy Sowden wrote:
> > > On 2021-07-30, at 13:27:49 -0500, Kyle Bowman wrote:
> > > > On Wed, Jul 28, 2021 at 03:43:47AM +0200, Phil Sutter wrote:
> > > > > You might want to check iptables commit ccf154d7420c0
> > > > > ("xtables: Don't use native nftables comments") for reference,
> > > > > it does the opposite of what you want to do.
> > > >
> > > > I went ahead and looked through this commit and also found found
> > > > the code that initially added this functionality; commit
> > > > d64ef34a9961 ("iptables-compat: use nft built-in comments
> > > > support ").
> > > >
> > > > Additionally I found some other commits that moved code to nft
> > > > native implementations of the xtables counterpart so that proved
> > > > helpful.
> > > >
> > > > After a couple days of research I did end up figuring out what
> > > > to do and have added a (mostly complete) native nft log support
> > > > in iptables-nft. It all seems to work without any kernel changes
> > > > required. The only problem I'm now faced with is that since we
> > > > want to take the string passed into the iptables-nft command and
> > > > add it to the nftnl expression (`NFTNL_EXPR_LOG_PREFIX`) I'm not
> > > > entirely sure where to get the original sized string from aside
> > > > from `argv` in the `struct iptables_command_state`. I would get
> > > > it from the `struct xt_nflog_info`, but that's going to store
> > > > the truncated version and we would like to be able to store 128
> > > > characters of the string as opposed to 64.
> > > >
> > > > Any recommendations about how I might do this safely?
> > >
> > > The xtables_target struct has a `udata` member which I think would
> > > be suitable.  libxt_RATEEST does something similar.
> >
> > Actually, if we embed struct xf_nflog_info in another structure
> > along with the longer prefix, we can get iptables-nft to print it
> > untruncated.
>
> > From 3c18555c6356e03731812688d7e6956a04ce820e Mon Sep 17 00:00:00 2001
> > From: Jeremy Sowden <jeremy@azazel.net>
> > Date: Sun, 1 Aug 2021 14:47:52 +0100
> > Subject: [PATCH] extensions: libxt_NFLOG: embed struct xt_nflog_info
> >  in another structure to store longer prefixes suitable for the nft
> >  log statement.
> >
> > NFLOG truncates the log-prefix to 64 characters which is the limit
> > supported by iptables-legacy.  We now store the longer 128-character
> > prefix in a new structure, struct xt_nflog_state, alongside the
> > struct xt_nflog_info for use by iptables-nft.
> >
> > [...]
> >
> > @@ -139,8 +157,8 @@ static struct xtables_target nflog_target = {
> >  	.family		= NFPROTO_UNSPEC,
> >  	.name		= "NFLOG",
> >  	.version	= XTABLES_VERSION,
> > -	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
> > -	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_info)),
> > +	.size		= XT_ALIGN(sizeof(struct xt_nflog_state)),
> > +	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_state)),
>
> Unfortuantely the change in size breaks iptables-legacy.  Whoops.
> More thought required.

Right, take three.  Firstly, use udata as I previously suggested, and
then use a new struct with a layout compatible with struct xt_nflog_info
just for printing and saving iptables-nft targets.

Seems to work.  Doesn't break iptables-legacy.

Patches attached.

J.

--ODWB8P+5zo3kGLF9
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v3-0001-extensions-libxt_NFLOG-use-udata-to-store-longer-.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 5fcf518401d71b8821cd1c0a00a958138ad9dca1 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Sun, 1 Aug 2021 14:47:52 +0100
Subject: [PATCH v3 1/2] extensions: libxt_NFLOG: use udata to store longer
 prefixes suitable for the nft log statement.

Hitherto NFLOG has truncated the log-prefix to the 64-character limit
supported by iptables-legacy.  We now use the struct xtables_target's
udata member to store the longer 128-character prefix supported by
iptables-nft.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.c | 6 ++++++
 iptables/nft.c           | 6 +-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 02a1b4aa35a3..9057230d7ee7 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -5,6 +5,7 @@
 #include <getopt.h>
 #include <xtables.h>
=20
+#include <linux/netfilter/nf_log.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFLOG.h>
=20
@@ -53,12 +54,16 @@ static void NFLOG_init(struct xt_entry_target *t)
=20
 static void NFLOG_parse(struct xt_option_call *cb)
 {
+	char *nf_log_prefix =3D cb->udata;
+
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_PREFIX:
 		if (strchr(cb->arg, '\n') !=3D NULL)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines not allowed in --log-prefix");
+
+		snprintf(nf_log_prefix, NF_LOG_PREFIXLEN, "%s", cb->arg);
 		break;
 	}
 }
@@ -149,6 +154,7 @@ static struct xtables_target nflog_target =3D {
 	.save		=3D NFLOG_save,
 	.x6_options	=3D NFLOG_opts,
 	.xlate		=3D NFLOG_xlate,
+	.udata_size     =3D NF_LOG_PREFIXLEN
 };
=20
 void _init(void)
diff --git a/iptables/nft.c b/iptables/nft.c
index dce8fe0b4a18..13cbf0a8b87b 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1365,11 +1365,7 @@ int add_log(struct nftnl_rule *r, struct iptables_co=
mmand_state *cs)
         return -ENOMEM;
=20
     if (info->prefix !=3D NULL) {
-        //char prefix[NF_LOG_PREFIXLEN] =3D {};
-
-        // get prefix here from somewhere...
-        // maybe in cs->argv?
-        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, "iff the value at =
the end is 12 then this string is truncated 123");
+        nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, cs->target->udata);
     }
     if (info->group) {
         nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
--=20
2.30.2


--ODWB8P+5zo3kGLF9
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v3-0002-extensions-libxt_NFLOG-don-t-truncate-log-prefix-.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 06a9108c7a4b9a8b603d2020214b5cf5c5d86880 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Mon, 2 Aug 2021 22:54:27 +0100
Subject: [PATCH v3 2/2] extensions: libxt_NFLOG: don't truncate log-prefix
 when printing and saving iptables-nft nflog targets.

When parsing the rule, use a struct with a layout compatible to that of
struct xt_nflog_info, but with a buffer large enough to contain the
whole 128-character nft prefix.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft-shared.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index b5259db07723..842318f95db4 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -20,6 +20,7 @@
=20
 #include <xtables.h>
=20
+#include <linux/netfilter/nf_log.h>
 #include <linux/netfilter/xt_comment.h>
 #include <linux/netfilter/xt_limit.h>
 #include <linux/netfilter/xt_NFLOG.h>
@@ -606,13 +607,26 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, str=
uct nftnl_expr *e)
     struct xt_entry_target *t;
     size_t target_size;
=20
-    void *data =3D ctx->cs;
+    /*
+     * In order to handle the longer log-prefix supported by nft, instead =
of
+     * using struct xt_nflog_info, we use a struct with a compatible layou=
t, but
+     * a larger buffer for the prefix.
+     */
+    struct xt_nflog_info_nft {
+        __u32 len;
+        __u16 group;
+        __u16 threshold;
+        __u16 flags;
+        __u16 pad;
+        char  prefix[NF_LOG_PREFIXLEN];
+    } info =3D { 0 };
=20
     target =3D xtables_find_target("NFLOG", XTF_TRY_LOAD);
     if (target =3D=3D NULL)
         return;
=20
-    target_size =3D XT_ALIGN(sizeof(struct xt_entry_target)) + target->siz=
e;
+    target_size =3D XT_ALIGN(sizeof(struct xt_entry_target)) +
+                  XT_ALIGN(sizeof(struct xt_nflog_info_nft));
=20
     t =3D xtables_calloc(1, target_size);
     t->u.target_size =3D target_size;
@@ -621,21 +635,15 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, str=
uct nftnl_expr *e)
=20
     target->t =3D t;
=20
-    struct xt_nflog_info *info =3D xtables_malloc(sizeof(struct xt_nflog_i=
nfo));
-    info->group =3D group;
-    info->len =3D snaplen;
-    info->threshold =3D qthreshold;
+    info.group =3D group;
+    info.len =3D snaplen;
+    info.threshold =3D qthreshold;
=20
-    /* Here, because we allow 128 characters in nftables but only 64
-     * characters in xtables (in xt_nflog_info specifically), we may
-     * end up truncating the string when parsing it.
-     */
-    strncpy(info->prefix, prefix, sizeof(info->prefix));
-    info->prefix[sizeof(info->prefix) - 1] =3D '\0';
+    snprintf(info.prefix, sizeof(info.prefix), "%s", prefix);
=20
-    memcpy(&target->t->data, info, target->size);
+    memcpy(&target->t->data, &info, sizeof(info));
=20
-    ctx->h->ops->parse_target(target, data);
+    ctx->h->ops->parse_target(target, ctx->cs);
 }
=20
 static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
--=20
2.30.2


--ODWB8P+5zo3kGLF9--

--k5Scy5fcAa2R8Q8x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEJBxoACgkQKYasCr3x
BA2XwBAAmOnZDcroHnpsDrQhtkLMPkIcsOJprkeO0QcoMCHWBeFZGYja3vXVlxsA
8Rf+g3Iigkdz0AyoognPWccK76VKhP498+KzwHUN9mICBvVvDpUtlMWYTi3TMwqs
+SWzQ55Qzl4e/qVDWYIaIZy/srJHdIjTwye4iJ1UVvyUE0YzNWH584AIcQTa7ltp
SHWY/JMAMOEDS1Pt77KyyE22RYaQZto2mHU2yXLCwenC76VtONJZZXymbVxap2Qt
7Bmt/o9IoH4S4mwVYo9MNSaSZBKGYezQx6oUpy5wUsccQjLfR5RLTEewrtsrjt5B
sYvtn7+rk+onFryWz4vDVVoYXuI8l0fnD56Fun4NuUTsee1Bfy2v7TZXviaRdenb
fj5CRd8tPMe+los+CmsmAJcYViXx5bK41TOMH582EhqTileUL5/3IAaNC3NUxjSy
eyIKkVDoFF0iYlcqGhf+zZeI1p96fGSt2kZIp26tJNrGpSnoahU8DnKwvY69Q5oG
lFZzgcXM+fip6Ig1JT/b42pWmneplCw/piABuJJ3UMcKzNOkENJXPjtUNNzuX2r3
AXUBAfojMSg42GbvSikq5/nKjkqsUFpFdH2SdGRZx02EbvJqMYRtilYY705Cc5c7
QwJCq+JepYtnz5x/hBdx6VeXhIXQsswbkL2VhzfTn/toT7AFm5k=
=A1U1
-----END PGP SIGNATURE-----

--k5Scy5fcAa2R8Q8x--
