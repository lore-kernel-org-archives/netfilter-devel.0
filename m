Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273A5C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 13:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E7B06101E
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 13:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhJ3NGI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 09:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhJ3NGH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 09:06:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC721C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 06:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dw4BPig0M4MX6lboGLX9XbiQ7H9RCKuW2ps9tR9Wd/8=; b=HUCc5OnUrVgOBq6ihD14LmhAGT
        Dc2+N/mjBsWf77RM8QazX0KDXIiuNRQVBjZ1yCZpC+u6CPsd1bNv7zvi2mazhkpZbtHUQd9a5tQFL
        917hG7Xx1mG3XAkkPw99GClDj6smPR8V4mone9CXOyDuVDzmUAD0W6SMK6vqtr6W9EwGUrszPtqk8
        dLPeIszZMbKhwa6ZJc7IqF8Bx4oQujkqOnblfAqMV46QxuPFNaEqDesoEEzubw/4s9RQjrMw7Id9Z
        TtPn2hnkK+a7mwI7FceK6TPVV1g4dpwLn4VBzXx0T5AViqII1UB8cYH5KOCTLGAJn4eSWQlLbqeN4
        TRQrV4gw==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgo1E-00ABxg-Np; Sat, 30 Oct 2021 14:03:32 +0100
Date:   Sat, 30 Oct 2021 14:03:25 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd 2/2] NFLOG: attach struct nf_conntrack
Message-ID: <YX1CnY+TPBZuYC8R@azazel.net>
References: <20211012111636.81419-1-chamas@h4.dion.ne.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="M248Sa8w1HzUA0YN"
Content-Disposition: inline
In-Reply-To: <20211012111636.81419-1-chamas@h4.dion.ne.jp>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--M248Sa8w1HzUA0YN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-12, at 20:16:37 +0900, Ken-ichirou MATSUZAWA wrote:
> put nf_conntrack in ct output key when 'attach_conntrack' is specified.
>
> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  input/packet/Makefile.am          |  5 ++-
>  input/packet/ulogd_inppkt_NFLOG.c | 68 +++++++++++++++++++++++++++++--
>  2 files changed, 67 insertions(+), 6 deletions(-)
>
> diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
> index 1c3151d..0f9c316 100644
> --- a/input/packet/Makefile.am
> +++ b/input/packet/Makefile.am
> @@ -1,5 +1,5 @@
>
> -AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_LOG_CFLAGS}
> +AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_LOG_CFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS}
>  AM_CFLAGS = ${regular_CFLAGS}
>
>  pkglib_LTLIBRARIES = ulogd_inppkt_UNIXSOCK.la
> @@ -13,7 +13,8 @@ pkglib_LTLIBRARIES += ulogd_inppkt_NFLOG.la
>  endif
>
>  ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
> -ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
> +ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS) \
> +                                 $(LIBNETFILTER_CONNTRACK_LIBS)
>
>  ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
>  ulogd_inppkt_ULOG_la_LDFLAGS = -avoid-version -module
> diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
> index ea6fb0e..c8b1836 100644
> --- a/input/packet/ulogd_inppkt_NFLOG.c
> +++ b/input/packet/ulogd_inppkt_NFLOG.c
> @@ -12,6 +12,11 @@
>  #include <ulogd/ulogd.h>
>  #include <libnfnetlink/libnfnetlink.h>
>  #include <libnetfilter_log/libnetfilter_log.h>
> +#ifdef BUILD_NFCT
> +#include <libmnl/libmnl.h>
> +#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
> +#endif
> +

I would declare `struct nf_conntrack` here if BUILD_NFCT is not defined:

  +#ifdef BUILD_NFCT
  +#include <libmnl/libmnl.h>
  +#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
  +#else
  +struct nf_conntrack;
  +#endif

Then we can declare `build_ct` as always returning
`struct nf_conntrack *`:

  +struct nf_conntrack *build_ct(struct nfgenmsg *nfmsg) {
  +#ifdef BUILD_NFCT
  +        struct nlattr *attr, *ctattr = NULL;
  +        struct nf_conntrack *ct = NULL;
  +        ...
  +        return ct;
  +#else
  +        return NULL;
  +#endif
  +}

and `ct` as `struct nf_conntrack *` instead of `void *` below.

>  #ifndef NFLOG_GROUP_DEFAULT
>  #define NFLOG_GROUP_DEFAULT	0
> @@ -148,6 +153,7 @@ enum nflog_keys {
>  	NFLOG_KEY_RAW_MAC_SADDR,
>  	NFLOG_KEY_RAW_MAC_ADDRLEN,
>  	NFLOG_KEY_RAW,
> +	NFLOG_KEY_RAW_CT,
>  };
>
>  static struct ulogd_key output_keys[] = {
> @@ -319,11 +325,53 @@ static struct ulogd_key output_keys[] = {
>  		.flags = ULOGD_RETF_NONE,
>  		.name = "raw",
>  	},
> +	[NFLOG_KEY_RAW_CT] = {
> +		.type = ULOGD_RET_RAW,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "ct",
> +	},
>  };
>

You have used spaces, not tabs:

> +#ifdef BUILD_NFCT
> +struct nf_conntrack *build_ct(struct nfgenmsg *nfmsg) {
> +        struct nlattr *attr, *ctattr = NULL;
> +        struct nf_conntrack *ct = NULL;
> +        struct nlmsghdr *nlh
> +                = (struct nlmsghdr *)((void *)nfmsg - sizeof(*nlh));
> +
> +        mnl_attr_for_each(attr, nlh, sizeof(struct nfgenmsg)) {
> +                if (mnl_attr_get_type(attr) == NFULA_CT) {
> +                        ctattr = attr;
> +                        break;
> +                }
> +        }
> +        if (ctattr == NULL)
> +                return NULL;
> +
> +        ct = nfct_new();
> +        if (ct == NULL) {
> +                ulogd_log(ULOGD_ERROR, "failed to allocate nfct\n");
> +                return NULL;
> +        }
> +        if (nfct_payload_parse(mnl_attr_get_payload(ctattr),
> +                               mnl_attr_get_payload_len(ctattr),
> +                               nfmsg->nfgen_family, ct) < 0) {
> +                ulogd_log(ULOGD_ERROR, "failed to parse nfct payload\n");
> +                nfct_destroy(ct);
> +                return NULL;
> +        }
> +
> +        return ct;
> +}
> +#else
> +void *build_ct(struct nfgenmsg *nfmsg) {
> +        return NULL;
> +}
> +#endif
>  static inline int
>  interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
> -	      struct nflog_data *ldata)
> +	      struct nflog_data *ldata, void *ct)
>  {
>  	struct ulogd_key *ret = upi->output.keys;
>
> @@ -404,6 +452,9 @@ interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
>
>  	okey_set_ptr(&ret[NFLOG_KEY_RAW], ldata);
>

Spaces, not tabs:

> +        if (ct != NULL)
> +                okey_set_ptr(&ret[NFLOG_KEY_RAW_CT], ct);
> +
>  	ulogd_propagate_results(upi);
>  	return 0;
>  }
> @@ -479,15 +530,24 @@ static int msg_cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
>  	struct ulogd_pluginstance *upi = data;
>  	struct ulogd_pluginstance *npi = NULL;
>  	int ret = 0;

Spaces, not tabs:

> +        void *ct = build_ct(nfmsg);
>
>  	/* since we support the re-use of one instance in several
>  	 * different stacks, we duplicate the message to let them know */
>  	llist_for_each_entry(npi, &upi->plist, plist) {
> -		ret = interp_packet(npi, nfmsg->nfgen_family, nfa);
> +		ret = interp_packet(npi, nfmsg->nfgen_family, nfa, ct);
>  		if (ret != 0)

Spaces, not tabs:

> -			return ret;
> +                        goto release_ct;
>  	}

Spaces, not tabs:

> -	return interp_packet(upi, nfmsg->nfgen_family, nfa);
> +        ret = interp_packet(upi, nfmsg->nfgen_family, nfa, ct);
> +
> +release_ct:
> +#ifdef BUILD_NFCT
> +        if (ct != NULL)
> +                nfct_destroy(ct);
> +#endif
> +
> +        return ret;
>  }
>
>  static int configure(struct ulogd_pluginstance *upi,
> --
> 2.30.2
>
>

--M248Sa8w1HzUA0YN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmF9Qp0ACgkQKYasCr3x
BA3KdQ//Z3mCFpp8d8SovR70L/WsGBPA4c0K4ommDijrSoE1QtsEk1+23rKrZlm1
PWfWlwWen/8r0buz/QWh3OtHwRqLGs0MwfB9pIDtavwlw0t0IWTU0piQ6AoQrSmz
24OCi3vpwAjnzgUp1Ko/5WFboDcf5rIQjO+9VZrV+BEwvSUhPVQXa/ZtkltOpvxc
zm9xiobJ0WVXGjDJDF366xQc+5NhvcRiCdKrIq8WMUfl0jNcHNqHBDgvYF4UmiwE
0ruDvPnM8gJ4o5SVZ8Epb5DVW0lhjgkTqUrMMLEzJsLl8hNNWE2ZhIe/0PaVKvAT
96xEsQ6iKnpisoWa53BzDcqajADQRL6U7XpWZ2whdZvbQsaFuSo2DUvWKc6Wds5I
2BpXvnn3bYcoPZfTCQ48So/wgFMKnnj2o2Y8mWCF9Fnzy1IjCs+/wJyO1gCPgFAd
/HYLcjU4cg3fOJ9x0QTX0c9bm2blyPALf6CMLfdrPwp4ViMZ093QZxNLMnfG7iQg
U2pZL0GDivfu/KyZRi+05CZGG6VBPcH1h4L+aqDsuZjrzdpx7bicd0JhY9vlUhqt
ED5MhhO4uaTTQQjr8Gv8pUwdMWyeqpw4BjSGn2jIcgfjWsqr7MG1a2KLnWrWHlBA
OyaX08rPb20OHjVsiGLj24NEmfow8oBNQNYOwmFY+GeNzgJV9bI=
=VzML
-----END PGP SIGNATURE-----

--M248Sa8w1HzUA0YN--
