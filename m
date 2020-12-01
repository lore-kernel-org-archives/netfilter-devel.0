Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73951C64E7A
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Dec 2020 13:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6F3D20770
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Dec 2020 13:42:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="aGxmWmhX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387854AbgLANmE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 08:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387752AbgLANmE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 08:42:04 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C305BC0613CF
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2020 05:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CU/hOtTFkq4xaLwJulO29k234ebXYD8VBplTEx93FII=; b=aGxmWmhXQgdpomhB/iBB6Ntm78
        jRjf3clXs883bottR88TzWodFLLLbPDpTSzRMTGUzv7qpZbypsUGa6t95oGqX+1Mh/OPGrpKgAGqR
        igyo92Q/I81DCNWR9Ocee35UTMlQgRGgnLP/DQsD2rai1ZUekZAfHNQ4fD7pH5nudeMPB4u6leEM+
        DfsvRNk9HbClaI8vC4d32fUkHLO7drMvfTdYT89dcAri99hiTbfw1exT8s3MbeSGdylvREmS2rbIb
        uedj0YJGDyxk2SeWC38TLDqbUjwAR/bBNyb7PnppMCBMuc77qx9W8NSCtosvmNZfjZo6wZOga9lnD
        pZbjLFDw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kk5uB-0003XG-1o; Tue, 01 Dec 2020 13:41:19 +0000
Date:   Tue, 1 Dec 2020 13:41:17 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: use actual socket sk for REJECT action
Message-ID: <X8ZH/RpbqO5ggew3@azazel.net>
References: <20201121111151.15960-1-jengelh@inai.de>
 <20201201084955.GC26468@salvia>
 <3s5q4s74-7q3n-69po-1q26-5qr718np489@vanv.qr>
 <20201201133639.GA1323@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zC91NHAQna70lSXm"
Content-Disposition: inline
In-Reply-To: <20201201133639.GA1323@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--zC91NHAQna70lSXm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-12-01, at 14:36:39 +0100, Pablo Neira Ayuso wrote:
> On Tue, Dec 01, 2020 at 01:49:21PM +0100, Jan Engelhardt wrote:
> > On Tuesday 2020-12-01 09:49, Pablo Neira Ayuso wrote:
> > >On Sat, Nov 21, 2020 at 12:11:51PM +0100, Jan Engelhardt wrote:
> > >> True to the message of commit v5.10-rc1-105-g46d6c5ae953c, _do_
> > >> actually make use of state->sk when possible, such as in the REJECT
> > >> modules.
> > >
> > >Could you rebase and resend a v2? I think this patch is clashing with
> > >recent updates to add REJECT support for ingress.
> >
> > I observed no conflict when attempting the rebase command, either onto
> >  cb7fb043e69a (/pub/scm/linux/kernel/git/netdev/net-next.git #master) or
> >  f7583f02a538 (/pub/scm/linux/kernel/git/pablo/nf-next #master)
>
> I see, it does not apply via:
>
>         git am netfilter-use-actual-socket-sk-for-REJECT-action.patch
>
> because patch shows:
>
> diff --git include/net/netfilter/ipv4/nf_reject.h include/net/netfilter/ipv4/nf_reject.h
> index 40e0e0623f46..d8207a82d761 100644
> --- include/net/netfilter/ipv4/nf_reject.h
> +++ include/net/netfilter/ipv4/nf_reject.h
>
> instead of:
>
> diff --git a/include/net/netfilter/ipv4/nf_reject.h b/include/net/netfilter/ipv4/nf_reject.h
> index 40e0e0623f46..d8207a82d761 100644
> --- a/include/net/netfilter/ipv4/nf_reject.h
> +++ b/include/net/netfilter/ipv4/nf_reject.h
>
> I just manually updated the patch so now it works.
>
> Is there a similar way to make patch -p0 for git-am BTW?

git am -p0.

J.

--zC91NHAQna70lSXm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAl/GR/UACgkQKYasCr3x
BA35ew//UPgkxNmSGilnfihm5dzV3XL/LgTpTmmI/CpW0O93j3BLXyFTtNkCN4Gz
8luxPPMvteO6c6e9EkxhJbOZmvqjG8J9N2RNMtQrMa5MC3CnDxIqiw1TTUH8Bc5C
Mf1U6jptwKVaOJ8UFqnnVmPL3X9EyhgFfnahD77wuMw+2lN/fn8UaAuIZNzJ7Hih
qd3pNLQHvBKeCA0EKuczF9cgS5YawZu/PfL+DkweWBrHBgyLEksChH6qcODgfZxG
VELqr93caPGSZ8/gkMxh9ko0R5y3sgSO0dKGmxy5xKoVLMwfuSHzBeilhL7pPwLX
Z28Py7K1ezIL7xPfxUFE0se0LeKEWg3r3MvHy6X/wDbQ4+c9/RmQNHoV2TrqBUJd
o6Tgkgfomihz/YJJLCw3BunPuKRhfwhJJ1amEYgBK4ICioAFhefl3iJXgVHqVvbz
eqaQBM+TqodybzEPJaSDy2acAl3Lok4sEZstvZNBbQ7S93HGFLPraqMCidTyekHu
1JqlfKsAvnU2qxS8MAUnZKX65T0TYLhhpefqEne9RZaQvBZRUddDzRJvl9DeeTOR
1N+8diqR7jTA1Df9wJjBfm2DXvJUx44Lwc6YfIG6PiaYtaCyHc+kEhzCz9RqpGZP
Gtmwu/nhi17IZTkwGkx0M7JKSMDAZiMfi/FEFw/WfM24xb4bzxs=
=WgPC
-----END PGP SIGNATURE-----

--zC91NHAQna70lSXm--
