Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE44C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02CF161396
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhDFLbW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:31:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34146 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbhDFLbW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 07:31:22 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5449F62C1A;
        Tue,  6 Apr 2021 13:30:54 +0200 (CEST)
Date:   Tue, 6 Apr 2021 13:31:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Lees <sflees@suse.de>
Cc:     Firo Yang <firo.yang@suse.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Simon Lees <SimonF.Lees@suse.com>
Subject: Re: [PATCH 1/2] ebtables: processing '--concurrent' beofore other
 arguments
Message-ID: <20210406113111.GA17543@salvia>
References: <20210401040741.15672-1-firo.yang@suse.com>
 <20210401040741.15672-2-firo.yang@suse.com>
 <20210403181517.GA4624@salvia>
 <20210403182204.GA5182@salvia>
 <6cc20464d5814fe899d7fb1e21d5488c@DB8PR04MB5881.eurprd04.prod.outlook.com>
 <f5efb453-0197-658c-1886-a4d88fc3b193@suse.de>
 <64466cd69b054f5d803722dfbcf8c4be@DB8PR04MB5881.eurprd04.prod.outlook.com>
 <d135ba6e-aa30-9a1d-136c-56a96aa10da6@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <d135ba6e-aa30-9a1d-136c-56a96aa10da6@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 06, 2021 at 08:51:30PM +0930, Simon Lees wrote:
>=20
>=20
> On 4/6/21 7:22 PM, Pablo Neira Ayuso wrote:
> > Hi,
> >=20
> > On Tue, Apr 06, 2021 at 05:29:11PM +0930, Simon Lees wrote:
> >>
> >>
> >> On 4/6/21 12:27 PM, Firo Yang wrote:
> >>> The 04/03/2021 20:22, Pablo Neira Ayuso wrote:
> >>>> On Sat, Apr 03, 2021 at 08:15:17PM +0200, Pablo Neira Ayuso wrote:
> >>>>> Hi,
> >>>>>
> >>>>> On Thu, Apr 01, 2021 at 12:07:40PM +0800, Firo Yang wrote:
> >>>>>> Our customer reported a following issue:
> >>>>>> If '--concurrent' was passed to ebtables command behind other argu=
ments,
> >>>>>> '--concurrent' will not take effect sometimes; for a simple exampl=
e,
> >>>>>> ebtables -L --concurrent. This is becuase the handling of '--concu=
rrent'
> >>>>>> is implemented in a passing-order-dependent way.
> >>>>>>
> >>>>>> So we can fix this problem by processing it before other arguments.
> >>>>>
> >>>>> Would you instead make a patch to spew an error if --concurrent is =
the
> >>>>> first argument?
> >>>>
> >>>> Wrong wording:
> >>>>
> >>>> Would you instead make a patch to spew an error if --concurrent is
> >>>> _not_ the first argument?
> >>>
> >>> Hi Pablo, I think it would make more sense if we don't introduce this
> >>> inconvenice to users. If you insist, I would go create the patch as y=
ou
> >>> intended.
> >>
> >> Agreed, that also wouldn't be seen as a workable solution for us "SUSE"
> >> as our customers who may have scripts or documented processes where
> >> --concurrent is not first and such a change would be considered a
> >> "Change in behavior" as such we can't ship it in a bugfix or minor
> >> version update, only in the next major update and we don't know when
> >> that will be yet.
> >>
> >> Sure this is probably only a issue for enterprise distro's but such a
> >> change would likely inconvenience other users as well.
> >=20
> > --concurrent has never worked away from the early positions ever.
> >=20
> > What's the issue?
>=20
> We had a customer complaining about the change in ordering causing
> different results with one way working and the other not, looking back
> at the report a second time I don't think they were ever using the "non
> working way" in production but just to debug the other issue.

Thanks for explaining, then I think we can go for the "restrict
position" fix which aligns with the -M, -t, ..., correct?

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEFEKqOX9jqZmzwkCc1GSBvS7ZkBkFAmBsRnwACgkQ1GSBvS7Z
kBl8bxAAkMCG5Qt7N2cGKctmQ5y5LO+JAk+uozHGnqOFFrASDIE8nBuE4zlWmc1f
qmAzwDtIVdFriuKNatHXEP3XWQO8J6dV1SbAMA4rcrQS7TatRlgvJ0mw2EZPQS/i
kKHwyLFcoV7Bv236cW/CVnYaXeqb5SI7I4a3ObRp89/UR5HUTtzHz8Y0IiHK2XK0
stEt0UKFiNrwhPND2RqOdVGsLY2pHettrPLxnwa/hAVngm6JdY/G31wzB+oU2CWJ
7Kb2MSDk51C8S+0GlSXTX3eRD5sBb4BDBohBIWiZ+EhGVntpHxAHSlJN37y/lh53
t/fdoy2zICgS+vcz8HA/p1yAKembn4LTjiJNishU6osC0FBtBEHO368SqO3wkrWg
jXxpSyqk48IvzNbOkAv1Z+c+XOQ5z6T+CwyPR5uBh7kCjuaF9Wiu5IhY7M0SYwqm
2ZPCCp7zbI9vS4qgGpOFMDAuLiXr/x5uyZaAM+mHD3xPjIRl0Was3MVvztYLM+ZV
RIC/aRoG5yPtiKqxa6C4YbRWmifsk0BGgBHrYGkcnNbsfhsseNkjtzJjN1OrqZsX
TBZ84Lyn1jz1Mjn9IxF/S/Utzm9qw8FAhQEvGgqyUjUsvE0oW1E4tQuNVRMrqzNs
Vi3Fc9mF5QpamQq4a0yrjTG+9RlSyb441+ZRMmOflpHGOA12CIA=
=dXY4
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
