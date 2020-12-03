Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55F1C64E8A
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 664D425684
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbgLCNZf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 08:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730533AbgLCNZe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 08:25:34 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A211C061A4E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 05:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i4RD6xDKpK469mAHkzz6cSCJKCN8GGowbV8asE+wCXc=; b=QC3bWcSOftkMea8dimzIyLNeul
        mPSP7lgEwkkYhUreiLay8/J9If/17NwNGCPP9wIlRM4K4YL8pT89NoJ9BKFoI3jaZaOzGR+gJJ3q4
        9Hb9SZhfjL9tG+hns2BsTd+uFFMZOicN0WGv6oBRTe9eilLOnjr4Btad+SBZLVuUXJmUkntoWbdYt
        I7p05Ki1f9mnrRMS6hrOfEOXWYBGe5wX6+pzdMZEmNMtWge5saBQ0xMq2G91f7XZzuAZj8vJyCHqx
        awyH98r6ZFUboKjn589+Afus6Vat9PLjBiHVsj3n/C6b8pof6mdYm/UltBROFV/7G18Px4KyqUOc2
        t7TwGRSw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kkobN-00032N-8S; Thu, 03 Dec 2020 13:24:53 +0000
Date:   Thu, 3 Dec 2020 13:24:52 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH 2/2] conntrackd: external_inject: report
 inject issues as warning
Message-ID: <X8jnJDRr+ul6bYvf@azazel.net>
References: <160700103220.39855.6588996986767666395.stgit@endurance>
 <160700103873.39855.3747782410251714155.stgit@endurance>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="T/DE4lACC9WyCTrB"
Content-Disposition: inline
In-Reply-To: <160700103873.39855.3747782410251714155.stgit@endurance>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--T/DE4lACC9WyCTrB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-12-03, at 14:10:38 +0100, Arturo Borrero Gonzalez wrote:
> In busy firewalls that run conntrackd in NOTRACK with both internal
> and external caches disabled, external_inject can get lots of traffic.
> In case of issues injecting or updating conntrack entries a log entry
> will be generated, the infamous inject-addX, inject-updX messages.
>
> But there is nothing end users can do about this error message, is
                                                                  ^^

"which is"

> purely internal. This patch is basically cosmetic, relaxing the
> message from ERROR to WARNING. The information reported is the same,
> but the idea is to leave ERROR messages to issues that would *stop* or
> *prevent* conntrackd from working at all.
>
> Another nice thing to do in the future is to rate-limit this message,
> which is generated in the data path and can easily fill log files. But
> ideally, the actual root cause would be fixed, and there would be no
> WARNING message reported at all, meaning that all conntrack entries
> are smothly synced between the firewalls in the cluster. We can work
      ^^^^^^^

"smoothly"

> on that later.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> ---
>  src/external_inject.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/src/external_inject.c b/src/external_inject.c
> index 0ad3478..e4ef569 100644
> --- a/src/external_inject.c
> +++ b/src/external_inject.c
> @@ -76,12 +76,12 @@ retry:
>  				}
>  			}
>  			external_inject_stat.add_fail++;
> -			dlog(LOG_ERR, "inject-add1: %s", strerror(errno));
> +			dlog(LOG_WARNING, "inject-add1: %s", strerror(errno));
>  			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
>  			return;
>  		}
>  		external_inject_stat.add_fail++;
> -		dlog(LOG_ERR, "inject-add2: %s", strerror(errno));
> +		dlog(LOG_WARNING, "inject-add2: %s", strerror(errno));
>  		dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
>  	} else {
>  		external_inject_stat.add_ok++;
> @@ -102,7 +102,7 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
>  	if (errno == ENOENT) {
>  		if (nl_create_conntrack(inject, ct, 0) == -1) {
>  			external_inject_stat.upd_fail++;
> -			dlog(LOG_ERR, "inject-upd1: %s", strerror(errno));
> +			dlog(LOG_WARNING, "inject-upd1: %s", strerror(errno));
>  			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
>  		} else {
>  			external_inject_stat.upd_ok++;
> @@ -117,7 +117,7 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
>  	if (ret == 0 || (ret == -1 && errno == ENOENT)) {
>  		if (nl_create_conntrack(inject, ct, 0) == -1) {
>  			external_inject_stat.upd_fail++;
> -			dlog(LOG_ERR, "inject-upd2: %s", strerror(errno));
> +			dlog(LOG_WARNING, "inject-upd2: %s", strerror(errno));
>  			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
>  		} else {
>  			external_inject_stat.upd_ok++;
> @@ -125,7 +125,7 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
>  		return;
>  	}
>  	external_inject_stat.upd_fail++;
> -	dlog(LOG_ERR, "inject-upd3: %s", strerror(errno));
> +	dlog(LOG_WARNING, "inject-upd3: %s", strerror(errno));
>  	dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
>  }
>
> @@ -134,7 +134,7 @@ static void external_inject_ct_del(struct nf_conntrack *ct)
>  	if (nl_destroy_conntrack(inject, ct) == -1) {
>  		if (errno != ENOENT) {
>  			external_inject_stat.del_fail++;
> -			dlog(LOG_ERR, "inject-del: %s", strerror(errno));
> +			dlog(LOG_WARNING, "inject-del: %s", strerror(errno));
>  			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
>  		}
>  	} else {
>
>

J.

--T/DE4lACC9WyCTrB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAl/I5yMACgkQKYasCr3x
BA27yBAAzPY8gw0dgoBeO0ioaXYmJXOFoaGJ2rmGxgZQ+tVDsw5gX2cEmaKq53mK
mwP1Brhua75J1HbFU3msbT/KheFB8UisWO6U8Dr9RkLkbBpYmkrOYlITaKQG8+4U
mgJ3Yq9MM9c5KTRQEKvfnZCHnJsCNHDF3/IKmg6pcNE9DQE+9s/lnnpsq7uAs/eI
PS7YXZ17SDYub0Y6nl/bG71OljK7dRRdkYV/RoZMBbzJ06TzlhMyLJRTsaDZbKfh
rVxLk1IGwv25WY2hAt1z+cYByMAskaXCNfqvkI49y3T4dZm/TQalsIUqhs/qeph3
fU837eTw4GDQZwBnGy0sVWnp5jxelISPG9OgVfNiVsPNFuPCOOcS2HO1vtqp3Nz5
SjrORvIQYdJn3Be7Onn1pWhhZETZWRVeVFJVrxk2roTemLL00+cDCZ12qkeLvH22
e/VC6qDPbIJGMDsveWphT3Gn/yNdKuqLqfGTnpPQtsb/wI0oixkfXO9upSAY1gh0
JQr5PO7EMC0O52YlO51PJgDaWksdTPUKSV0Xq9uruJyMkrfJv0UEX9RIy2mK8CPm
Hir+fY+rOtiy9WnirXoi43VliIoyOigOr3a4a7w9QJZCepBsdnsSG/pyrTiqxZW+
pCXwmOqD108ZSgtLTwosq8fwDi9Uy2wtjcJRuFSK2NVbItAfp6Q=
=MZD6
-----END PGP SIGNATURE-----

--T/DE4lACC9WyCTrB--
