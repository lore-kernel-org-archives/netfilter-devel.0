Return-Path: <SRS0=EiUA=4V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC5AC3F2CD
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 08:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFA3D20870
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 08:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="kl9/wkuz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387723AbgCDI5j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 03:57:39 -0500
Received: from kadath.azazel.net ([81.187.231.250]:40104 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387640AbgCDI5j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 03:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3rjeCGU/+cFcJwYdm59Ed6fjGenLQ3umPvcAmGE7GNY=; b=kl9/wkuzDUcCxbs0Pjoj88WAqF
        5teplq82f7qeD6PtkcZ3q7y+Gg/UvBBFcPJY1t8bX60E8409II4Xi0/EDou5Lcq/CudPfeVDcklHV
        UAKMnXFwtCVa8o/67KAScNxdGrfElrgH4QWkINpUNsPiyKn0x4Rv+xyukP2Eeo8Nrc+qTjKK6TO7L
        izvgsuJnIFleXAzSaBWdYMLQuQH0gHhk5nM8z+UYET+0ycFozLC6Qw75YcGLV0dLYo0AlPFjhV1G5
        WHvC21dZE8qjWM1Kj79oYV3JAyeqD0IZRywuqWLjyeNHvhzheyIDXT3U7tK2KTUcir/ATfvn/fKHJ
        D297Bh5A==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j9PqS-0007jZ-Df; Wed, 04 Mar 2020 08:57:36 +0000
Date:   Wed, 4 Mar 2020 08:57:35 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] main: add more information to `nft -V`.
Message-ID: <20200304085735.GA19243@azazel.net>
References: <20200303232341.25786-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20200303232341.25786-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-03-04, at 00:23:41 +0100, Pablo Neira Ayuso wrote:
> From: Jeremy Sowden <jeremy@azazel.net>
>
> In addition to the package-version and release-name, output the CLI
> implementation (if any) and whether mini-gmp was used, e.g.:
>
>     $ ./src/nft -V
>     nftables v0.9.3 (Topsy)
>       cli:          linenoise
>       minigmp:      no
>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Hi Jeremy et al.
>
> I'm revisiting this one, it's basically your patch with a few
> mangling.
>
> I wonder if it's probably a good idea to introduce a long version
> mode.  I have seen other tools providing more verbose information
> about all build information.
>
> The idea would be to leave -v/--version as it is, and introduce -V
> which would be more verbose.
>
> Thanks.

Fine by me.  Btw, I notice that OPTSTRING contains a couple of
duplicates.  I've attached a patch to remove them.  It applies on top of
this one.

>  src/Makefile.am |  3 +++
>  src/main.c      | 32 +++++++++++++++++++++++++++++++-
>  2 files changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/src/Makefile.am b/src/Makefile.am
> index 9142ab4484f2..b4b9142bf6b0 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -13,6 +13,9 @@ endif
>  if BUILD_XTABLES
>  AM_CPPFLAGS += ${XTABLES_CFLAGS}
>  endif
> +if BUILD_MINIGMP
> +AM_CPPFLAGS += -DHAVE_MINIGMP
> +endif
>
>  AM_CFLAGS = -Wall								\
>  	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
> diff --git a/src/main.c b/src/main.c
> index 6ab1b89f4dd5..6a88e777cc1f 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -27,6 +27,7 @@ static struct nft_ctx *nft;
>  enum opt_vals {
>  	OPT_HELP		= 'h',
>  	OPT_VERSION		= 'v',
> +	OPT_VERSION_LONG	= 'V',
>  	OPT_CHECK		= 'c',
>  	OPT_FILE		= 'f',
>  	OPT_INTERACTIVE		= 'i',
> @@ -46,7 +47,7 @@ enum opt_vals {
>  	OPT_TERSE		= 't',
>  	OPT_INVALID		= '?',
>  };
> -#define OPTSTRING	"+hvd:cf:iI:jvnsNaeSupypTt"
> +#define OPTSTRING	"+hvVd:cf:iI:jvnsNaeSupypTt"
>
>  static const struct option options[] = {
>  	{
> @@ -141,6 +142,7 @@ static void show_help(const char *name)
>  "Options:\n"
>  "  -h, --help			Show this help\n"
>  "  -v, --version			Show version information\n"
> +"  -V				Show extended version information\n"
>  "\n"
>  "  -c, --check			Check commands validity without actually applying the changes.\n"
>  "  -f, --file <filename>		Read input from <filename>\n"
> @@ -164,6 +166,31 @@ static void show_help(const char *name)
>  	name, DEFAULT_INCLUDE_PATH);
>  }
>
> +static void show_version(void)
> +{
> +	const char *cli, *minigmp;
> +
> +#if defined(HAVE_LIBREADLINE)
> +	cli = "readline";
> +#elif defined(HAVE_LIBLINENOISE)
> +	cli = "linenoise";
> +#else
> +	cli = "no";
> +#endif
> +
> +#if defined(HAVE_MINIGMP)
> +	minigmp = "yes";
> +#else
> +	minigmp = "no";
> +#endif
> +
> +	printf("%s v%s (%s)\n"
> +	       "  cli:		%s\n"
> +	       "  minigmp:	%s\n",
> +	       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME,
> +	       cli, minigmp);
> +}
> +
>  static const struct {
>  	const char		*name;
>  	enum nft_debug_level	level;
> @@ -272,6 +299,9 @@ int main(int argc, char * const *argv)
>  			printf("%s v%s (%s)\n",
>  			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
>  			exit(EXIT_SUCCESS);
> +		case OPT_VERSION_LONG:
> +			show_version();
> +			exit(EXIT_SUCCESS);
>  		case OPT_CHECK:
>  			nft_ctx_set_dry_run(nft, true);
>  			break;
> --
> 2.11.0

J.

--dDRMvlgZJXvWKvBx
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="0001-main-remove-duplicates-from-option-string.patch"
Content-Transfer-Encoding: quoted-printable

=46rom a0ddf69b9ef82ccc3f3c3174f960da3d58201e31 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Wed, 4 Mar 2020 08:40:15 +0000
Subject: [PATCH] main: remove duplicates from option string.

The string of options passed to getopt_long(3) contains duplicates.
Update it to match the opt_vals enum which immediately precedes it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/main.c b/src/main.c
index 6a88e777cc1f..90208691557f 100644
--- a/src/main.c
+++ b/src/main.c
@@ -47,7 +47,7 @@ enum opt_vals {
 	OPT_TERSE		=3D 't',
 	OPT_INVALID		=3D '?',
 };
-#define OPTSTRING	"+hvVd:cf:iI:jvnsNaeSupypTt"
+#define OPTSTRING	"+hvVcf:iI:jnsNSd:aeuypTt"
=20
 static const struct option options[] =3D {
 	{
--=20
2.25.1


--dDRMvlgZJXvWKvBx--

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl5fbU8ACgkQonv1GCHZ
79fSxgv/R8qWLKO9pEdQJzYdhwT6dMXRoXXnRgAxaBq0IWTWeceZ8Aa6MF2cmTE3
a7OPg4BaX+PFeU7ZECTHreEweHvMDGxT0KENO1nvZ/EdB+98HCITkCYCWyR2DXso
/jnsDZTQL6B5LYSrl3MRfWQgnRAfkercBbV60cmFC3+k0mCza9AuTlOWkaVMVYpc
TmJidFo4mE1kUfl9n4kWOxvceNwwyY5S8dUwiBcDfj3ajE+kM/C7rVFdYAEknXiF
Ib1aQcxgAM4zMn7fmOmGpSsdyvoxzWZBnkTZNInqK6rIExMqQvT8H/EWe9l5bHaB
4geH0LcwIgxI4blvP3yqJia8QD2EA8UpeErWBElew48oyqOAL4Ft6lqSAvs6AqRJ
91hA9ff4nhKDztIdEn4MhnDC6EvEftJ21aWVC1KhEPH6otIxpHTIYW5WDTI25eiF
ND8svSYA6j3RHDrKoCffZu696MwporOBPnKQYFSGKlg0wuSqmEZl62dUhEiVt05T
eX5DhdCq
=bJ2a
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
