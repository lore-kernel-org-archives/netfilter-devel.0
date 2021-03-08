Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2494BC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 05:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2A436510B
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 05:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbhCHFgh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 00:36:37 -0500
Received: from zucker.schokokeks.org ([178.63.68.96]:41201 "EHLO
        zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbhCHFgf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 00:36:35 -0500
Received: from localhost (localhost [::1])
  (AUTH: PLAIN simon@ruderich.org, TLS: TLSv1.3,256bits,TLS_AES_256_GCM_SHA384)
  by zucker.schokokeks.org with ESMTPSA
  id 000000000000008C.000000006045B7E1.00000A2C; Mon, 08 Mar 2021 06:36:33 +0100
Date:   Mon, 8 Mar 2021 06:36:33 +0100
From:   Simon Ruderich <simon@ruderich.org>
To:     Frank Myhr <fmyhr@fhmtech.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC PATCH] doc: use symbolic names for chain priorities
Message-ID: <YEW34W5oCspFnSt+@ruderich.org>
References: <b1320180e5617ae9910848b7fc17daf9c3edca04.1615109258.git.simon@ruderich.org>
 <0a7f088c-f813-0425-8bec-d693d95a97a0@fhmtech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512; protocol="application/pgp-signature"; boundary="=_zucker.schokokeks.org-2604-1615181793-0001-2"
Content-Disposition: inline
In-Reply-To: <0a7f088c-f813-0425-8bec-d693d95a97a0@fhmtech.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_zucker.schokokeks.org-2604-1615181793-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 07, 2021 at 10:02:52AM -0500, Frank Myhr wrote:
> Hi Simon,
>
> Priority is only relevant _within a given hook_. So comparing priorities =
of
> base chains hooked to prerouting and postrouting (as in your example abov=
e)
> does not make sense. Please see:
>
> https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains#Base=
_chain_priority
> https://wiki.nftables.org/wiki-nftables/index.php/Netfilter_hooks

Hello Frank,

thank you. This helped, somewhat.

The image https://people.netfilter.org/pablo/nf-hooks.png in the
wiki lists netfilter hooks. Do these correspond to nftables
hooks? So all prerouting hooks (type nat, type filter, etc.) for
IP are applied to the green "Prerouting Hook" in the IP part of
the diagram? And the "Netfilter Internal Priority" applies only
within such a hook to order them?

If this is correct this leads me to three questions:

Why is there a global order of netfilter hooks (via the priority,
-450 to INT_MAX)? Wouldn't it also work to set for example
NF_IP_PRI_NAT_SRC to -400 because it only applies in postrouting
anyway? Or is it designed that way to "hint" at the packet flow
(lower numbers first, independent of the actual hooks)?

For type nat and hook prerouting priorities like -100, 0 and 500
would all work because we have no other hooks in that range.
However, using priority -250 would be problematic because it puts
it before the netfilter connection tracking?

What exactly is the difference between the chain types? Is it
relevant for netfilter or is it only for nftables so it knows
which rules to expect in the given chain?

Regards
Simon
--=20
+ privacy is necessary
+ using gnupg http://gnupg.org
+ public key id: 0x92FEFDB7E44C32F9

--=_zucker.schokokeks.org-2604-1615181793-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEO7rfWMMObpFkF3n0kv79t+RMMvkFAmBFt9wACgkQkv79t+RM
MvnJKw//e5boWg0G6vyQTcWQ2qFz8N7gNCJuZjdvDwPD5dXyZ0K3RRY8D5OThafs
a3Ux35MgyeO4PQZvrtQZ6o7tfvMOUyTuADAGi3bgZKgDwjiDRneZPGRItx1Jpjtz
A0C1SF4e/GSxu3Nh56lI6cTp+gKejjoPyGg19CDnnPeQDP/iYzsfBw2UcBmVSr1e
l+ADQgycL9wKYSMuYV20tcT30NStxzT/mkoOvewaxlrWDGGlwrvNzugNDrOq5HII
1c25ze5orCItK05eNhTbQ3uaWtbxJNBFSHFve6XsVhQyeyPdxRU3V2MPiII3ll7h
pqtuqJXANCIAM2qLf13ofrMhf/1HhuJHpwpCk0vKj41WmSRg16yN/VOsjaiUDZah
frGwMSW94lFRBQZ8PH+681cazDVePezHwTsCQI6Jd1hxkXZ6gowy9gMh/ryYz9Mz
6Zygboq7SUkoP1S2x9WvhYQzdZMjik53olOlbHuFKr+CDv4nCRpmo79xd8mrLKSX
pvDIzYl6OS9YPhNbOjDExXKDVjMn7FG/jKyUwAUGkaKyWQZDzIeOQvURBm+Wdd48
pWkfmod9X+Q9iNwOCPDqbg5INCe8MhGxIhdFLjVNFazs5PKFLYRDpkU7q3Crz1y+
8qfjR8EWskiWuTBePdflgQvBub6wK/DSV2FAWyv6+4Zg902Bqts=
=WfKW
-----END PGP SIGNATURE-----

--=_zucker.schokokeks.org-2604-1615181793-0001-2--
