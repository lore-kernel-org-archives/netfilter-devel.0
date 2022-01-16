Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F54C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jan 2022 15:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiAPPFQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Jan 2022 10:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiAPPFP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Jan 2022 10:05:15 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9514EC061574
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Jan 2022 07:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Aby03tI9dacpmZOlBkuTuWh75xXoQbKBdjNWLK6g4Xg=; b=pcPKl7Xh8/9rxC++27NIyIKdti
        7O74FaazeK4neKPsQqac1EMKwOqoaoEiGLTZ8WXUHG8L8b11GIZwvbBD5kkyfLIWsB19ThbAKYobl
        v99FBzEfqDVYpiJQZoEIi+zqQxFKvDLorT0Tt2kNDFlryeoCQuEg7jpWEThF1fR34bnghIAmDPs34
        aN1gs5gC1+Yz1jTtjfUkmL7HER13JbjCWGSd5yDq4VwDzlE6D5706VYFZiRZF6bWKOhu4pPljr5AV
        iQCzFsaruLKgONixX8iTkz3tgNpVy+tc38noIjlyC9IRnlkjGuqszacPPh+z43xTNlHHJYtPR/3EB
        abPfJj7g==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n975i-009K75-SB
        for netfilter-devel@vger.kernel.org; Sun, 16 Jan 2022 15:05:10 +0000
Date:   Sun, 16 Jan 2022 15:05:09 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables v2 0/8] extensions: libxt_NFLOG: use nft
 back-end for iptables-nft
Message-ID: <YeQ0JeUznhEopHxI@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ool4cyAfALeRLGk9"
Content-Disposition: inline
In-Reply-To: <20211001174142.1267726-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--ool4cyAfALeRLGk9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-01, at 18:41:34 +0100, Jeremy Sowden wrote:
> nftables supports 128-character prefixes for nflog whereas legacy
> iptables only supports 64 characters.  This patch series converts
> iptables-nft to use the nft back-end in order to take advantage of the
> longer prefixes.
>
>   * Patches 1-5 implement the conversion and update some related Python
>     unit-tests.
>   * Patch 6 fixes an minor bug in the output of nflog prefixes.
>   * Patch 7 contains a couple of libtool updates.
>   * Patch 8 fixes some typo's.

I note that Florian merged the first patch in this series recently.
Feedback on the rest of it would be much appreciated.

J.

> Changes since v1:
>
>   * Patches 1 and 5-8 are new.
>   * White-space fixes in patches 2 and 3.
>   * Fixes for typo's in commit-messages of patches 2 and 4.
>   * Removal of stray `struct xt_nflog_info` allocation from
>     `nft_parse_log` in patch 3.
>   * Leave commented-out `--nflog-range` test-cases in libxt_NFLOG.t
>     with an explanatory comment in patch 4.
>
> Jeremy Sowden (5):
>   nft: fix indentation error.
>   extensions: libxt_NFLOG: fix `--nflog-prefix` Python test-cases
>   extensions: libxt_NFLOG: remove extra space when saving targets with
>     prefixes
>   build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with
>     `LT_INIT`
>   tests: iptables-test: correct misspelt variable
>
> Kyle Bowman (3):
>   extensions: libxt_NFLOG: use nft built-in logging instead of xt_NFLOG
>   extensions: libxt_NFLOG: don't truncate log prefix on print/save
>   extensions: libxt_NFLOG: disable `--nflog-range` Python test-cases
>
>  configure.ac             |  3 +-
>  extensions/libxt_NFLOG.c |  8 ++++-
>  extensions/libxt_NFLOG.t | 16 ++++-----
>  iptables-test.py         | 18 +++++-----
>  iptables/nft-shared.c    | 52 ++++++++++++++++++++++++++++
>  iptables/nft.c           | 74 ++++++++++++++++++++++++++++------------
>  iptables/nft.h           |  1 +
>  7 files changed, 131 insertions(+), 41 deletions(-)
>
> --
> 2.33.0
>
>

--ool4cyAfALeRLGk9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHkNCUACgkQKYasCr3x
BA3yiBAAqAMxFI6DOCCFOJgyTZ0k5TESv4SFR2AtHem33Zy9YNGw1/ZP83cwcWMG
5/LWwG6MGjKDkRlIOtwaE4tLihZawM7cEDeWaBxh9igh7Q9eIEtypHWQo1m/U6gT
/B0+ql7vS1DuuXQUyEfhoXhb+jRwKewMiVDVpAezscyEOQpbh1nY7rhJd7/mT/8z
Vp1kvMhZVy6N4i851yfU955+km5GMSjgN7a+OaCcmidjr+6biUZwf2PS4ZwaIC1v
ytuOwWq/bdlp2zPr7gTMr5JiXT4seHLghpRItdEOtqbLzMmIHxVKAL3HwZZ3KgyS
ED254qDq+8mjaFiepI8GM5Y/UoM4nwjmgIS88K0LRMHngyAxuQYEfKNN+J1Eg2eT
yH1QEedNu47tPNcOTdFb2vCf2b8WybmtxlwiXIVg79qhNH0sNVpht5Kwwzf4ivHQ
PieD1+Vy+OSHUFXHirf/7Wot9rDb4hgL0pJr+lZJpEC9WijFRWYfOxEyOK52S71k
tCObMH5tG1vdNTo8nKtDwrn7joiyqozp/NbzdUD/nRBo/0DVrCbR7QuoSjmpldqE
IlpZe9RtIjIyqagMw+lgRt0wJwgeMXdXcuAv4ZX2FAmiHtrj9HWoTivqNcF+2yzj
GmPLPjvOUxB/tm99cGnvWRJqkVFzr41SdbDatNidFRitsI1uh2I=
=EGjI
-----END PGP SIGNATURE-----

--ool4cyAfALeRLGk9--
