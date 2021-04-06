Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD081C43461
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 09:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F9B613C3
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 09:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbhDFJwu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 05:52:50 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33810 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239844AbhDFJwt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 05:52:49 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3382F63E3F;
        Tue,  6 Apr 2021 11:52:22 +0200 (CEST)
Date:   Tue, 6 Apr 2021 11:52:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Lees <sflees@suse.de>
Cc:     Firo Yang <firo.yang@suse.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Simon Lees <SimonF.Lees@suse.com>
Subject: Re: [PATCH 1/2] ebtables: processing '--concurrent' beofore other
 arguments
Message-ID: <20210406095238.GA15556@salvia>
References: <20210401040741.15672-1-firo.yang@suse.com>
 <20210401040741.15672-2-firo.yang@suse.com>
 <20210403181517.GA4624@salvia>
 <20210403182204.GA5182@salvia>
 <6cc20464d5814fe899d7fb1e21d5488c@DB8PR04MB5881.eurprd04.prod.outlook.com>
 <f5efb453-0197-658c-1886-a4d88fc3b193@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <f5efb453-0197-658c-1886-a4d88fc3b193@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 06, 2021 at 05:29:11PM +0930, Simon Lees wrote:
>=20
>=20
> On 4/6/21 12:27 PM, Firo Yang wrote:
> > The 04/03/2021 20:22, Pablo Neira Ayuso wrote:
> >> On Sat, Apr 03, 2021 at 08:15:17PM +0200, Pablo Neira Ayuso wrote:
> >>> Hi,
> >>>
> >>> On Thu, Apr 01, 2021 at 12:07:40PM +0800, Firo Yang wrote:
> >>>> Our customer reported a following issue:
> >>>> If '--concurrent' was passed to ebtables command behind other argume=
nts,
> >>>> '--concurrent' will not take effect sometimes; for a simple example,
> >>>> ebtables -L --concurrent. This is becuase the handling of '--concurr=
ent'
> >>>> is implemented in a passing-order-dependent way.
> >>>>
> >>>> So we can fix this problem by processing it before other arguments.
> >>>
> >>> Would you instead make a patch to spew an error if --concurrent is the
> >>> first argument?
> >>
> >> Wrong wording:
> >>
> >> Would you instead make a patch to spew an error if --concurrent is
> >> _not_ the first argument?
> >=20
> > Hi Pablo, I think it would make more sense if we don't introduce this
> > inconvenice to users. If you insist, I would go create the patch as you
> > intended.
>=20
> Agreed, that also wouldn't be seen as a workable solution for us "SUSE"
> as our customers who may have scripts or documented processes where
> --concurrent is not first and such a change would be considered a
> "Change in behavior" as such we can't ship it in a bugfix or minor
> version update, only in the next major update and we don't know when
> that will be yet.
>
> Sure this is probably only a issue for enterprise distro's but such a
> change would likely inconvenience other users as well.

--concurrent has never worked away from the early positions ever.

What's the issue?

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEFEKqOX9jqZmzwkCc1GSBvS7ZkBkFAmBsL2QACgkQ1GSBvS7Z
kBkryw/+PWhKEnm2T2Ts8PV9FIWsuRRXhJojkiSzi+IzuGov3Pt0a1XgN47Hu9kE
hZPgcCxBLZenkrtA4V5ilFnBXulqpEUSKa4Z9QE5IGXt2b2OmeTFi0SnHwWgWuPt
Oxxc7m9iBh/3s67rsRpuoecYhvdd5N9ZN/vMn8YypHLt3basgiYe9hdLtDV8Yd6X
0fYVqDcYm7fGZT+ic2aE7SG7lCqSNdk+wo1jiC0uok2mSOXIaxBqd0KO4iT92SIM
+2co9SRv+sHI+nObQfrLwq3kxSdtiV9H38Aqy1Pxdw0guFYih0PELBmcEeA8oexE
N7iSTjpVAussEQ+Mc6sktx7SqptW6ZQ3dFi0bV9T94eW4SiaJmS0Bs2QECrAuruM
3VeB4E9L41OAUGVyI0CIokOLxHpnC6HlNW1gJCY1UHZl6jxh6DUv5mv01I4s/Q+f
BnQMm6lcxT0LfE8dW9BUPik0PoptQT/gyru1vPDcvZeVZHHVbyDPLUNAI4jYmCbL
kW6mjhI5LpEl7pAOl6f7QeUiy+9XXDDum/vc1DJKaTkJ7SpRs2ffPhBf+ZChwQsw
MEe1W6AhGie4rOnedJYDFuwLaCqZ/ZOHXQDuN0/S64Nrqi65vnKowKYsy74pHw2m
+LEHtVpMFBy+Lzt1+F1EM/Dxh7qpOdqrRGpWiU1tNMmC4SaUcUk=
=Y73S
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
