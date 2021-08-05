Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA200C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 21:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8D661104
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 21:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbhHEVIA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 17:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241555AbhHEVH7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 17:07:59 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50234C0613D5
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Aug 2021 14:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KsakE7ZrUdJouHC8S/Ekny+MBPvG6P6BuohdUzG1GDI=; b=pS+1JV82sIDJy2GLiQcZIMTMw4
        4+tVdTdwBzY/WH70DQcndHb8++CRWaUk4jd5vVaXUTiLyToTwNCyyriE9gKDpLvWtFkpvtbDshSoO
        xJE5doL8aWvhScE0Fhs4feesHoJe5phjsq4+HYAs6iD03KZ4YCf6qmpr7puLBup1Z4kG3SahBqIqa
        g27rAdjGBfU4eRAftlR1UsPEyJn5HV1lUnQ00Tj+R0aA5e/stSZJckYkaWh3rJeUXjp8s1oBw8+3E
        PxS55SF/l/DdTJnxnPGoRSaLNjZa9p9GaKI/R+5+vxB1xtGHVEjv9JqncRZTJUpwDqYl1okmPVYGl
        0DhxEpgg==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1mBkaZ-0007SA-50; Thu, 05 Aug 2021 22:07:39 +0100
Date:   Thu, 5 Aug 2021 22:07:37 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Kyle Bowman <kbowman@cloudflare.com>
Cc:     Phil Sutter <phil@nwl.cc>, Alex Forster <aforster@cloudflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [PATCH] netfilter: xt_NFLOG: allow 128
 character log prefixes
Message-ID: <YQxTGZ1h3X8gem75@azazel.net>
References: <20210727215240.GA25043@salvia>
 <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
 <20210728014347.GM3673@orbyte.nwl.cc>
 <YQREpVNFRUKtBliI@C02XR1NRJGH8>
 <YQasUsvJpML6CAsy@azazel.net>
 <YQfU8km0t3clPVhl@azazel.net>
 <YQggBDBruNxkscoi@azazel.net>
 <YQkHIamDpqBzmNrO@azazel.net>
 <YQmMlAheX6Tmg2qJ@C02XR1NRJGH8>
 <YQvAsgl/ylNAZVVP@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="U043QJ84qux3EEys"
Content-Disposition: inline
In-Reply-To: <YQvAsgl/ylNAZVVP@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--U043QJ84qux3EEys
Content-Type: multipart/mixed; boundary="kHAIb+Io671dfj1c"
Content-Disposition: inline


--kHAIb+Io671dfj1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-05, at 11:42:58 +0100, Jeremy Sowden wrote:
> On 2021-08-03, at 13:36:04 -0500, Kyle Bowman wrote:
> > On Tue, Aug 03, 2021 at 10:06:41AM +0100, Jeremy Sowden wrote:
> > > Right, take three.  Firstly, use udata as I previously suggested,
> > > and then use a new struct with a layout compatible with struct
> > > xt_nflog_info just for printing and saving iptables-nft targets.
> > >
> > > Seems to work.  Doesn't break iptables-legacy.
> > >
> > > Patches attached.
> >
> > Thanks for writing in and helping with this, I appreciate it. I
> > actually was trying to make this work last night in a similar way to
> > how you've solved it but I gave up after a few hours. I'll go ahead
> > and organize this together and send the patches in a separate
> > thread.
>
> One thing before you do.  Some of iptables' unit-tests related to
> NFLOG are now failing.  For example:
>
>   $ sudo python3 ./iptables-test.py -n extensions/libxt_NFLOG.t
>   Cannot run in own namespace, connectivity might break
>   extensions/libxt_NFLOG.t: ERROR: line 2 (cannot find: iptables -I INPUT -j NFLOG --nflog-group 1)
>   extensions/libxt_NFLOG.t: ERROR: line 3 (cannot find: iptables -I INPUT -j NFLOG --nflog-group 65535)
>   extensions/libxt_NFLOG.t: ERROR: line 6 (cannot find: iptables -I INPUT -j NFLOG --nflog-range 1)
>   extensions/libxt_NFLOG.t: ERROR: line 7 (cannot find: iptables -I INPUT -j NFLOG --nflog-range 4294967295)
>   extensions/libxt_NFLOG.t: ERROR: line 10 (cannot find: iptables -I INPUT -j NFLOG --nflog-size 0)
>   extensions/libxt_NFLOG.t: ERROR: line 11 (cannot find: iptables -I INPUT -j NFLOG --nflog-size 1)
>   extensions/libxt_NFLOG.t: ERROR: line 12 (cannot find: iptables -I INPUT -j NFLOG --nflog-size 4294967295)
>   extensions/libxt_NFLOG.t: ERROR: line 19 (cannot find: iptables -I INPUT -j NFLOG --nflog-threshold 1)
>   extensions/libxt_NFLOG.t: ERROR: line 22 (cannot find: iptables -I INPUT -j NFLOG --nflog-threshold 65535)
>   1 test files, 17 unit tests, 8 passed
>
> I'm working my way through them.  I've got fixes for most.  I'll send
> patches when I've sorted out the remaining ones.

Patches attached.  The first is the same as before.  The second is
slightly different: I've moved around the initialization of the info
struct, but there are no functional differences.  Of the remaining
patches, 3-8 fix bugs that were flagged up by the failing unit-tests, 9
adds a comment explaining that we don't support `--nflog-range`, and 10
drops unit-tests for this.

J.

--kHAIb+Io671dfj1c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v4-0001-extensions-libxt_NFLOG-use-udata-to-store-longer-.patch"
Content-Transfer-Encoding: quoted-printable

=46rom a50a604d2dfdb8951433a7c5adce02c589a07dae Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Sun, 1 Aug 2021 14:47:52 +0100
Subject: [PATCH v4 01/10] extensions: libxt_NFLOG: use udata to store longer
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


--kHAIb+Io671dfj1c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v4-0002-extensions-libxt_NFLOG-don-t-truncate-log-prefix-.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 05f656f9ac89cb348f82d522a5fc1c19e367504a Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Mon, 2 Aug 2021 22:54:27 +0100
Subject: [PATCH v4 02/10] extensions: libxt_NFLOG: don't truncate log-prefix
 when printing and saving iptables-nft nflog targets.

When parsing the rule, use a struct with a layout compatible to that of
struct xt_nflog_info, but with a buffer large enough to contain the
whole 128-character nft prefix.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft-shared.c | 45 +++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index b5259db07723..22a1a08ed862 100644
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
@@ -598,21 +599,35 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, s=
truct nftnl_expr *e)
=20
 static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
-    __u16 group =3D  nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_GROUP);
-    __u16 qthreshold =3D nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD);
-    __u32 snaplen =3D nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN);
-    const char *prefix =3D nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX);
     struct xtables_target *target;
     struct xt_entry_target *t;
     size_t target_size;
-
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
+    } info =3D {
+        .group     =3D nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_GROUP),
+        .threshold =3D nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD),
+        .len       =3D nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN),
+    };
+    snprintf(info.prefix, sizeof(info.prefix), "%s",
+             nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX));
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
@@ -621,21 +636,9 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, stru=
ct nftnl_expr *e)
=20
     target->t =3D t;
=20
-    struct xt_nflog_info *info =3D xtables_malloc(sizeof(struct xt_nflog_i=
nfo));
-    info->group =3D group;
-    info->len =3D snaplen;
-    info->threshold =3D qthreshold;
-
-    /* Here, because we allow 128 characters in nftables but only 64
-     * characters in xtables (in xt_nflog_info specifically), we may
-     * end up truncating the string when parsing it.
-     */
-    strncpy(info->prefix, prefix, sizeof(info->prefix));
-    info->prefix[sizeof(info->prefix) - 1] =3D '\0';
-
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


--kHAIb+Io671dfj1c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v4-0003-extensions-libxt_NFLOG-only-send-the-prefix-if-it.patch"
Content-Transfer-Encoding: quoted-printable

=46rom c75e6f19307ffdecf1f99205f31c3aa61cde7350 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Thu, 5 Aug 2021 15:38:40 +0100
Subject: [PATCH v4 03/10] extensions: libxt_NFLOG: only send the prefix if =
it
 is not empty.

`info->prefix` is an array, not a pointer, and so is never `NULL`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 13cbf0a8b87b..e5e5b8e1046b 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1364,7 +1364,7 @@ int add_log(struct nftnl_rule *r, struct iptables_com=
mand_state *cs)
     if (!expr)
         return -ENOMEM;
=20
-    if (info->prefix !=3D NULL) {
+    if (info->prefix[0] !=3D '\0') {
         nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, cs->target->udata);
     }
     if (info->group) {
--=20
2.30.2


--kHAIb+Io671dfj1c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v4-0004-extensions-libxt_NFLOG-check-that-the-prefix-is-s.patch"
Content-Transfer-Encoding: quoted-printable

=46rom cb11ef308b8624fff2f8611648daee2545902184 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Thu, 5 Aug 2021 16:01:07 +0100
Subject: [PATCH v4 04/10] extensions: libxt_NFLOG: check that the prefix is
 set.

Since we don't send the prefix if it empty, we may not get one back from
the kernel.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft-shared.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 22a1a08ed862..ecce64cd166f 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -619,8 +619,10 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, stru=
ct nftnl_expr *e)
         .threshold =3D nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD),
         .len       =3D nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN),
     };
-    snprintf(info.prefix, sizeof(info.prefix), "%s",
-             nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX));
+    if (nftnl_expr_is_set(e, NFTNL_EXPR_LOG_PREFIX)) {
+        snprintf(info.prefix, sizeof(info.prefix), "%s",
+                 nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX));
+    }
=20
     target =3D xtables_find_target("NFLOG", XTF_TRY_LOAD);
     if (target =3D=3D NULL)
--=20
2.30.2


--kHAIb+Io671dfj1c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v4-0005-extensions-libxt_NFLOG-always-send-the-nflog-grou.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 0db1b2666240effef0b75b31cd07233146b36c45 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Thu, 5 Aug 2021 15:52:58 +0100
Subject: [PATCH v4 05/10] extensions: libxt_NFLOG: always send the
 nflog-group.

For nft, log and nflog targets are handled by the same kernel module,
and are distinguished by whether they define a nflog-group.  Therefore,
we must send the group even if it is zero, or the kernel will configure
the target as a log, not an nflog.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index e5e5b8e1046b..4bfc85a7d0bc 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1367,15 +1367,14 @@ int add_log(struct nftnl_rule *r, struct iptables_c=
ommand_state *cs)
     if (info->prefix[0] !=3D '\0') {
         nftnl_expr_set_str(expr, NFTNL_EXPR_LOG_PREFIX, cs->target->udata);
     }
-    if (info->group) {
-        nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
-        if (info->flags & XT_NFLOG_F_COPY_LEN)
+
+    nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
+    if (info->flags & XT_NFLOG_F_COPY_LEN)
             nftnl_expr_set_u32(expr, NFTNL_EXPR_LOG_SNAPLEN,
                                info->len);
-        if (info->threshold)
+    if (info->threshold)
             nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_QTHRESHOLD,
                                info->threshold);
-    }
=20
     nftnl_rule_add_expr(r, expr);
     return 0;
--=20
2.30.2


--kHAIb+Io671dfj1c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v4-0006-extensions-libxt_NFLOG-only-targets-which-have-a-.patch"
Content-Transfer-Encoding: quoted-printable

=46rom d32fda241b2a60eda0709e62602f6b703d4c3347 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Thu, 5 Aug 2021 15:55:28 +0100
Subject: [PATCH v4 06/10] extensions: libxt_NFLOG: only targets which have a
 nflog-group are compatible.

Since nflog targets are distinguished by having a nflog-group, we ignore
targets without one.  Since nflog targets don't support levels or flags,
we can ignore these attributes.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4bfc85a7d0bc..5778496e9ef2 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3516,9 +3516,8 @@ static int nft_is_expr_compatible(struct nftnl_expr *=
expr, void *data)
 		return 0;
=20
 	if (!strcmp(name, "log") &&
-	    nftnl_expr_get_u32(expr, NFTNL_EXPR_LOG_LEVEL) =3D=3D 4 &&
-	    !nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_FLAGS))
-	    return 0;
+	    nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_GROUP))
+		return 0;
=20
 	return -1;
 }
--=20
2.30.2


--kHAIb+Io671dfj1c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v4-0007-extensions-libxt_NFLOG-check-whether-the-snap-len.patch"
Content-Transfer-Encoding: quoted-printable

=46rom a9c88a338218a4eabc89b357d8d9f21939e20898 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Thu, 5 Aug 2021 16:04:25 +0100
Subject: [PATCH v4 07/10] extensions: libxt_NFLOG: check whether the
 snap-length is set.

We don't always send the length to the kernel, so we need to check
whether we have received it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft-shared.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index ecce64cd166f..8227c4308f84 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -617,8 +617,10 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, stru=
ct nftnl_expr *e)
     } info =3D {
         .group     =3D nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_GROUP),
         .threshold =3D nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD),
-        .len       =3D nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN),
     };
+    if (nftnl_expr_is_set(e, NFTNL_EXPR_LOG_SNAPLEN)) {
+        info.len =3D nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN);
+    }
     if (nftnl_expr_is_set(e, NFTNL_EXPR_LOG_PREFIX)) {
         snprintf(info.prefix, sizeof(info.prefix), "%s",
                  nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX));
--=20
2.30.2


--kHAIb+Io671dfj1c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v4-0008-extensions-libxt_NFLOG-set-copy-len-flag-if-the-s.patch"
Content-Transfer-Encoding: quoted-printable

=46rom e88fb277d5d406034c9099af1c25cceac02db1a7 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Thu, 5 Aug 2021 16:06:25 +0100
Subject: [PATCH v4 08/10] extensions: libxt_NFLOG: set copy-len flag if the
 snap-length is set.

Without this, iptables mistakes `nflog-size` for `nflog-range`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft-shared.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 8227c4308f84..70d1e20f80f1 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -620,6 +620,7 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, struc=
t nftnl_expr *e)
     };
     if (nftnl_expr_is_set(e, NFTNL_EXPR_LOG_SNAPLEN)) {
         info.len =3D nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN);
+        info.flags =3D XT_NFLOG_F_COPY_LEN;
     }
     if (nftnl_expr_is_set(e, NFTNL_EXPR_LOG_PREFIX)) {
         snprintf(info.prefix, sizeof(info.prefix), "%s",
--=20
2.30.2


--kHAIb+Io671dfj1c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v4-0009-extensions-libxt_NFLOG-add-a-comment-to-the-code-.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 0da888807aa82a6ab327bc252f447df1ded81ddc Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Thu, 5 Aug 2021 21:15:58 +0100
Subject: [PATCH v4 09/10] extensions: libxt_NFLOG: add a comment to the code
 explaining that we ignore `--nflog-range`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 5778496e9ef2..3a3e70d5824f 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1369,6 +1369,21 @@ int add_log(struct nftnl_rule *r, struct iptables_co=
mmand_state *cs)
     }
=20
     nftnl_expr_set_u16(expr, NFTNL_EXPR_LOG_GROUP, info->group);
+    /*
+     * In iptables-legacy, `--nflog-range` sets the length, and `--nflog-s=
ize`
+     * set the length _and_ the `XT_NFLOG_COPY_LEN` flag.  For iptables-nf=
t, we
+     * cannot set a flag: setting the length always implies (the equivalent
+     * of) `--nflog-size` (`snaplen` in nft parlance).  This means we cann=
ot
+     * emulate `--nflog-range`.  However, `--nflog-range` is broken and do=
esn't
+     * do anything.  If given `--nflog-range`, we have two choices: we can=
 send
+     * the given length anyway, effectively converting it to `--nflog-size=
`, or
+     * we can ignore it.  `--nflog-size` was added explicitly to avoid cha=
nging
+     * the broken behaviour of `--nflog-range`:
+     *
+     *   https://lore.kernel.org/netfilter-devel/20160624204231.GA3062@aka=
mai.com/
+     *
+     * so we ignore it.
+     */
     if (info->flags & XT_NFLOG_F_COPY_LEN)
             nftnl_expr_set_u32(expr, NFTNL_EXPR_LOG_SNAPLEN,
                                info->len);
--=20
2.30.2


--kHAIb+Io671dfj1c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v4-0010-extensions-libxf_NFLOG-remove-nflog-range-Python-.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 311eaed59c399966bf352712be6a753296ebe568 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Thu, 5 Aug 2021 20:37:15 +0100
Subject: [PATCH v4 10/10] extensions: libxf_NFLOG: remove `--nflog-range`
 Python unit-tests.

nft has no equivalent to `--nflog-range`, so we cannot emulate it and
the Python unit-tests for it fail.  However, since `--nflog-range` is
broken and doesn't do anything, the tests are not testing anything
useful.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.t | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/extensions/libxt_NFLOG.t b/extensions/libxt_NFLOG.t
index 933fa22160e5..33a15c061ed7 100644
--- a/extensions/libxt_NFLOG.t
+++ b/extensions/libxt_NFLOG.t
@@ -3,10 +3,6 @@
 -j NFLOG --nflog-group 65535;=3D;OK
 -j NFLOG --nflog-group 65536;;FAIL
 -j NFLOG --nflog-group 0;-j NFLOG;OK
--j NFLOG --nflog-range 1;=3D;OK
--j NFLOG --nflog-range 4294967295;=3D;OK
--j NFLOG --nflog-range 4294967296;;FAIL
--j NFLOG --nflog-range -1;;FAIL
 -j NFLOG --nflog-size 0;=3D;OK
 -j NFLOG --nflog-size 1;=3D;OK
 -j NFLOG --nflog-size 4294967295;=3D;OK
--=20
2.30.2


--kHAIb+Io671dfj1c--

--U043QJ84qux3EEys
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEMUxIACgkQKYasCr3x
BA1xORAAkEaV5rNGAK7r1w9nKzdfogEOG2w/ymjptpVp5I0zGMH85LKtLLnXrQ21
LXW5rM0POH8/coczl53BMZpohKAOUYpbOlYoygyQxwph064RSMiWb3ttDAPvCQbm
vrNyyzhnkcFtoSyj7xcfrnk94dEHPdwaeh6Es7ZQwxJnTXiYY/yVo3XRXPCox6KF
6i3gGebyy1WENXV1aArHb3YbBpefiYJsjJAuAOuNQ66mnbn3UXQy9TszWsxmv1YC
/GnMatVVM1x2er6028X9jmIKtuGvUNlT+ZWS04RZRY5jJh0AG10I2YOCHW5W954N
F3WqE32mE3sfphGMxa+tnQkjNbPQVsaNSK9O4oaMFdTpHwW+ctIz/1TNBhdu0Hl1
BKrsOzu5wX4nMJIfK3acF+8s4iN3qRaAiAeaJOOZlMwlzMPylzMJppNkpJsq3khg
vidO1vSkuPlzUyppdhoF+nChtY4MrZmYZceoOXa27LnytO3apZY8/IKlsSCB6B47
OAyQjDtATh+r/f2agxjXueMmWcwPwzdM0/J4+gd2ExtRba8WdbyQZBLUUOsgZO+n
YPYpcqznbKFZVedVnuYjlSBWYNXFEOA60jI6N9V1JronewHRbNAJoIGEmsXiiZRU
6xbPTc3gQk1C4EJOSdLTlTcLjndSj+KcjzI6GHnn0zxfyQ7PW5E=
=mLEW
-----END PGP SIGNATURE-----

--U043QJ84qux3EEys--
