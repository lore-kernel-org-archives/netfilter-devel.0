Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF47CC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 20:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbiKWUOz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbiKWUOy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 15:14:54 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5610856ED6
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 12:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pLaS1lGDMea/xK1zvgHucvaB2R2aB7Ju2TcYP3uwW8g=; b=Pmtz/K3MfUmM2JARyAbvFaDUre
        pv0Z5v5fYgd35h6yhWE20FsCsNIlhaITvYRiHt+dIyLuQ17Rw6zfKpwDKdpzFqp6qmckHukdb2w4U
        LmZBqq24M2Kkig9cZNWmRQ7f+recXBnJSXDsZJR3SVEkdgA29SIuiWbACjfpjaph/Tx0oehfz0FXp
        6j4OcW9xEBG+/7n3dWl3VPXHbkIcQkSwXA/op1qdTLzYy/onH8DGweQdKWSoqnykXc5lMjl4rHSpp
        iQeP/dPjEo6t3ePMODdyiZ1+6sfst7scPKbnELBCrQzhgDSNQ5zg9qG5SEfbRwg7r5mwgUhpETBDI
        XUnM4ksQ==;
Received: from [2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxw8u-007RtH-Da; Wed, 23 Nov 2022 20:14:48 +0000
Date:   Wed, 23 Nov 2022 20:14:44 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Robert O'Brien <robrien@foxtrot-research.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: PATCH ulogd2 filter BASE ARP packet IP addresses
Message-ID: <Y35/NEI+wqK06zv0@azazel.net>
References: <004301d8f531$bb2c60c0$31852240$@foxtrot-research.com>
 <005601d8f532$49cd7080$dd685180$@foxtrot-research.com>
 <Y24taNAVtz53JPDB@salvia>
 <001c01d8f851$38ac6050$aa0520f0$@foxtrot-research.com>
 <Y3KFKuhzFWbbAKWL@salvia>
 <Y3wBIqCFTAFob4/4@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BAce5xrJx3ROBxfa"
Content-Disposition: inline
In-Reply-To: <Y3wBIqCFTAFob4/4@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--BAce5xrJx3ROBxfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-11-21, at 22:52:18 +0000, Jeremy Sowden wrote:
> On 2022-11-14, at 19:12:58 +0100, Pablo Neira Ayuso wrote:
> > On Mon, Nov 14, 2022 at 12:47:52PM -0500, Robert O'Brien wrote:
> > > I will create a bug report and attach an example ulogd
> > > configuration file that demonstrates the issue.
> >
> > OK.
> >
> > > I will send a patch using git send-email and mention it in my bug
> > > report. What is the email address to where I should send the
> > > patch?
> >
> > Please use netfilter-devel@vger.kernel.org so patchwork catches this
> > patch.
>
> I think there are at least a couple more places where IP addresses are
> not correctly handled:
>
>   https://git.netfilter.org/ulogd2/tree/output/sqlite3/ulogd_output_SQLITE3.c?h=ulogd-2.0.8&id=79aa980f2df9dda0c097e8f883a62f414b9e5138#n176
>   https://git.netfilter.org/ulogd2/tree/filter/raw2packet/ulogd_raw2packet_BASE.c?h=ulogd-2.0.8&id=79aa980f2df9dda0c097e8f883a62f414b9e5138#n647
>
> I'll see if I can find any others.

Didn't find any other endianness bugs, but there are assumptions in some
of the output plug-ins that all `ULOGD_RET_IPADDR` values are IPv4
addresses that can be treated as uint32_t values, which is not valid.
One possibility would be to handle all IP addresses internally as in
IPv6 format (i.e., convert IPv4 addresses to `::ffff:w.x.y.z` -- this is
what the IP2BIN filter does) and then convert the IPv4 addresses back on
output.

J.

--BAce5xrJx3ROBxfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmN+fy0ACgkQKYasCr3x
BA3+dBAA0CVjz70ZfKWS9u6nK71+e9KrMijLApNOvG0m02bDfOoV/C6HaqX+P8vO
H7K/B0Zg3qKWjnYF8RcXklLSTJoM7xmUT/I77ped4NxvCgx+nCx29ZA8c/aoBGpK
h3VM3W0XkcsuSYg+tUQtdve2ezppB+kIr8EckEH6V+CQVkapQXx8TygSi9FOmmO0
h2Za5U5SJFMQA9GHpTWoLnsDQlCGOWB9kdItWwbRfqYQtSlFF9NCzgjSOKuHf3J8
5bK7f56Q9p8G48bEaxqpfoaIxqtBtpwSfbnh5iVBtj/ESSjdRKjHZ1Z8lHss5HzA
enaeXkd4djAwVWe6OI3hu6/O//yxZN9v6GI1+4w0UX8nNy//YYuTWawEJFn7/U0e
1HUR8UZX48a3tdPxHpp/HUgznLnLrwYCqBwxK17OHAM0LyFjHUPYMrIeCpvoaU5l
8sKQvsR/ht5v7tJ+eMyyQger/hBsdKpUFCPxbXLap9E8eNCeoSHQphc188vecGed
o0BtUTzBxcu7TwCcnMBtEWblIgLcANXIWYIqCfKpl2m8rItXj59yeC/IKfb+Dny7
5THx3J0msnJ1O10FqbHkOSIlfa2R4CKUNnmfNL7wqj6Sd1T9y6Cn/WifKGowKDOH
JrSHDEOZwD6YFJE4ERLVrRUZypxIhvAJ0uPit6DRZy4lCrKQNEs=
=S8xp
-----END PGP SIGNATURE-----

--BAce5xrJx3ROBxfa--
