Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D8BC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Nov 2022 19:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiKPTW1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 14:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbiKPTW0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 14:22:26 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD8AB25
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2022 11:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NLr75oAN4hOMjcmIivcXYDhyNeS3u5kipCbMw6xQQbE=; b=IhB8WgR+MbbpMgg0zPfuaZhTCe
        xbEH5nB6BCRjJRC5d27oYIxNDe0woMJL4PWCbBO/0m37yXI997sM4xLKExaLSSmC18L0WYA0PYE58
        Hr/GnFb51MWx0xWMWDO6VDHmWU8+ipPK5H+Vy/dc08RuF/MOoVxemclH+uUmiDA5GgMdbF6iSS7Ix
        cFKlbtkxrdUQXkvT21fouiJfPD83kz3+PFUnCtQqy31N3g42i7nRE7L0tI1vvUtGMyMdSBYDZ+2bm
        6TPP4F5bFvJ98Pd3aNseo4dRslPAkpAdf5e7UMDnxsc3EPfzEDimOGBihY6FOO61xZn9zeGu+si7e
        I0OEMxZA==;
Received: from [2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ovNzJ-00GvHS-Ad; Wed, 16 Nov 2022 19:22:21 +0000
Date:   Wed, 16 Nov 2022 19:22:17 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     shockedder shockedder <shockedder@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Missing definition of struct "pkt_buff" for libnetfilter_queue
Message-ID: <Y3U4aSAA/PzaO+WJ@azazel.net>
References: <15e85292-dfce-edf4-794e-410d8cffaf33@gmail.com>
 <Y3UpD+6HQxYbkF2x@azazel.net>
 <CAC8-Yrfhz4KU29MP7COyshgQnAa13u1xe6FxzgBkxu+Dxh-mzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BuT7WjngLd0zz4Kp"
Content-Disposition: inline
In-Reply-To: <CAC8-Yrfhz4KU29MP7COyshgQnAa13u1xe6FxzgBkxu+Dxh-mzg@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--BuT7WjngLd0zz4Kp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-11-16, at 21:05:27 +0200, shockedder shockedder wrote:
> On Wed, Nov 16, 2022 at 8:16 PM Jeremy Sowden wrote:
> > On 2022-11-16, at 19:42:01 +0200, Shockedder wrote:
> > > I'm running with a slightly older version of "libnetfilter_queue"
> > > (1.0.2).
> > >
> > > I have installed both the standard and devel packages, along with
> > > the same for "libnfnetlink" I can't for the life of me find the
> > > definition of "struct pkt_buff" in any of the source or headers.
> >
> >   https://git.netfilter.org/libnetfilter_queue/tree/src/internal.h?h=libnetfilter_queue-1.0.2
> >
> > The public API for `struct [pkt_buff]` is:
> >
> >   https://git.netfilter.org/libnetfilter_queue/tree/include/libnetfilter_queue/pktbuff.h?h=libnetfilter_queue-1.0.2
> >
> > > Due to that I'm getting errors when trying to compile accessing
> > > structure members:
> > >
> > >   "etf_nq.c:78:93: error: dereferencing pointer to incomplete type 'struct pkt_buff'
> > >        fprintf(stdout,"[PACKET] UDP pB->th pointer val=%p pktb_tail pointer val=%p\n",pktBuff->transport_header,pktb_tail(pktBuff));"
> >
> > Try:
> >
> >   fprintf(stdout,"[PACKET] UDP pB->th pointer val=%p pktb_tail pointer val=%p\n",
> >           (void *) pktb_transport_header(pktBuff), pktb_tail(pktBuff));"
>
> Thank you very much, you've saved me a lot of hair-pulling.  Looking
> once more, I've been able to find that header file in the source
> download for "libnetfilter_queue".
>
> However it is not present in the standard lib and devel packages hence
> the initial issue. Is there a reason for this ?

Encapsulation:

  https://en.wikipedia.org/wiki/Encapsulation_(computer_programming)#Information_hiding

> Is it a bug ?

Since the internal structure of `struct pkt_buff` is intended to be
private, and the header file is only necessary to build the library
itself, there is no need to include it in the binary packages.  For
those developing against the library, the public API in
libnetfilter_queue/pktbuff.h will be present in the devel package.

J.

--BuT7WjngLd0zz4Kp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmN1OGkACgkQKYasCr3x
BA1DUA/9HrOIx9I828gmuKh4HhCJLwugzuxRhnYKyO0lbzgVmkTGPmf5PEBtmZ5o
6fH1PNBNxRWtIMQMk8DTCr2MHgifCrQvdvZh9h4Fi+bCoW4Xpeup2A4f8Gx0DCtt
1uemliqbkAoXp12PcfzHuXN1UrXsyy4tO8XcNTvmA8TfHYK2q2HkJCSZpMosi9IT
kzCY8nZSsBhegXgXXtr2lIL5MKglxNVEEjJ+hsBpnw9Y5YGYsMFcHKHL5Z3m8gEP
KCHMMGfXqDODOv1d8B9VK1lCzJ6OPEv4TPNlkePhY6MD6WUfWpvajlqx9LJBiDp/
718fbivV+HBf1K8uCabuaaJmc+6e19Dwa1Sz2y01md7gRSJNWMRufat6T/92Klxp
FiyjgRBzlNFEWkzOvgT2cAO4uQBUr6s+C9xqEdtwswy/4FKaILURG+8yegQy6J5w
3lh/+uXh2pbVTylJTQ9WUSxJjwdwcmpgpc3p/8L/9qPABzxtPhZGQjO/SMopmZRo
to1yEaGjWbIgcYbpXZevMFSSitYB+ktjgs2Po8GGKVGYsJXZmYGG9vTUelrTqMJv
H0tZZHJw3OccaeEfuyqexRUEqs9BIKcKs6raMPIZ7F6kAPnMi7pMcHWG1NQWcDlT
KEjnybXDOuf8P8iSQD7iVv5K96ZgiHxQu1KtICaXVX5G/Z8r2aw=
=aZJg
-----END PGP SIGNATURE-----

--BuT7WjngLd0zz4Kp--
