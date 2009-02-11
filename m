From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: Introduce xtables_set_revision() and make
 iptables and ip6tables use it
Date: Wed, 11 Feb 2009 16:26:43 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111624380.20223@fbirervta.pbzchgretzou.qr>
References: <1234301869.20903.82.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38691 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZBKP0p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:26:45 -0500
In-Reply-To: <1234301869.20903.82.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-10 22:37, jamal wrote:
>
>As i mentioned to Jan I would like to unify that into
>a simple call:
>
>-----------
>        xtables_init_all(&tcxt_globals);
>----------
>
>Then I will be more confident that we we will have peace going
>forward. Please let me know if this is acceptable and i will
>prepare a patch.

Ok.


>+extern void xtables_free_opts(int reset_offset);
>+extern void xtables_set_revision(char *name, u_int8_t revision);

You need const char * to avoid warnings.

>diff --git a/xtables.c b/xtables.c
>index 805b940..48b4104 100644
>--- a/xtables.c
>+++ b/xtables.c
>@@ -99,6 +99,8 @@ void xtables_free_opts(int reset_offset)
> 	}
> }
> 
>+void xtables_set_revision_ipv4(char *name, u_int8_t revision);
>+void xtables_set_revision_ipv6(char *name, u_int8_t revision);
> 
> struct option *
> xtables_merge_options(struct option *oldopts, const struct option *newopts,

Why are these prototypes here? (You can make the functions static
and reorder to leave them out.)

>@@ -130,6 +132,22 @@ xtables_merge_options(struct option *oldopts, const struct option *newopts,
> 	return merge;
> }
> 
>+void xtables_set_revision_ipv4(char *name, u_int8_t revision)
>+{
>+	/* Old kernel sources don't have ".revision" field,
>+	*            but we stole a byte from name. */
>+	name[IPT_FUNCTION_MAXNAMELEN - 2] = '\0';
>+	name[IPT_FUNCTION_MAXNAMELEN - 1] = revision;
>+}
>+
>+void xtables_set_revision_ipv6(char *name, u_int8_t revision)
>+{
>+	/* Old kernel sources don't have ".revision" field,
>+	*            but we stole a byte from name. */
>+	name[IP6T_FUNCTION_MAXNAMELEN - 2] = '\0';
>+	name[IP6T_FUNCTION_MAXNAMELEN - 1] = revision;
>+}
>+

Since IPT_FUNCTION_MAXNAMELEN is the same as IP6T_FUNCTION_MAXNAMELEN,
these functions can be consolidated.

>@@ -155,6 +175,7 @@ static const struct xtables_afinfo afinfo_ipv4 = {
> 	.ipproto       = IPPROTO_IP,
> 	.so_rev_match  = IPT_SO_GET_REVISION_MATCH,
> 	.so_rev_target = IPT_SO_GET_REVISION_TARGET,
>+	.set_revision = xtables_set_revision_ipv4,

One off a space ;^)

>@@ -164,6 +185,7 @@ static const struct xtables_afinfo afinfo_ipv6 = {
> 	.ipproto       = IPPROTO_IPV6,
> 	.so_rev_match  = IP6T_SO_GET_REVISION_MATCH,
> 	.so_rev_target = IP6T_SO_GET_REVISION_TARGET,
>+	.set_revision = xtables_set_revision_ipv6,
> };
> 
> static const struct xtables_afinfo *afinfo;
