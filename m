From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH] libip6t_frag: match any frag id by default
Date: Wed, 8 Aug 2012 20:17:12 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208082011370.4912@frira.zrqbmnf.qr>
References: <20120807133739.AB7F8C6417@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Michal Kubecek <mkubecek@suse.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:53020 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337Ab2HHSRN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:17:13 -0400
In-Reply-To: <20120807133739.AB7F8C6417@unicorn.suse.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-08-07 15:10, Michal Kubecek wrote:

>If no --fragid option is given, frag extension matches only
>fragments with zero Identification field. This is unexpected and
>it breaks ip6tables-save/ip6tables-restore functionality. Match
>any frag id instead.

I've picked this one up, adding documentation about some more pitfalls.
This now reads


parent 8bbad67df4a7fb69ed73d4bf90dcb3cf77fd2a03 (v1.4.15-11-g8bbad67)
commit 3cfec6fcf5da5263ba6df5ceab5e100440907879
Author: Michal Kube=C4=8Dek <mkubecek@suse.cz>
Date:   Tue Aug 7 15:10:05 2012 +0200

libip6t_frag: match any frag id by default

If no --fragid option is given, the frag extension only matches
fragments with a zero-valued "Identification" field. This behavior
deviates from what other extensions do (they match all values in this
case) and is unexpected, and therefore changed by this patch.

Additionally, --fragid 0:4294967295 leads to no output on `iptables
-S` because part of the code thinks that this would be the default,
when it is not.

So, default to match all frag values, such that iptables -S not
outputting anything also becomes correct.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libip6t_frag.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index d8bcaee..023df62 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -41,6 +41,13 @@ static const struct xt_option_entry frag_opts[] =3D =
{
 };
 #undef s
=20
+static void frag_init(struct xt_entry_match *m)
+{
+	struct ip6t_frag *fraginfo =3D (void *)m->data;
+
+	fraginfo->ids[1] =3D ~0U;
+}
+
 static void frag_parse(struct xt_option_call *cb)
 {
 	struct ip6t_frag *fraginfo =3D cb->data;
@@ -173,6 +180,7 @@ static struct xtables_match frag_mt6_reg =3D {
 	.size          =3D XT_ALIGN(sizeof(struct ip6t_frag)),
 	.userspacesize =3D XT_ALIGN(sizeof(struct ip6t_frag)),
 	.help          =3D frag_help,
+	.init          =3D frag_init,
 	.print         =3D frag_print,
 	.save          =3D frag_save,
 	.x6_parse      =3D frag_parse,
--=20
# Created with git-export-patch
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
