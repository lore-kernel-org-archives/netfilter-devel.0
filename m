Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785C9C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Mar 2023 16:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjCXQHw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 12:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjCXQHt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 12:07:49 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF293222EF
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 09:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZmEh5bCuM4K93VhHSiBZrvxg+Ond6ZshSbKW9Ymwgig=; b=pZPcrgK89FpQAdWqP4sbDDE//s
        MNUzdQ39ypWif/LRooXLJCMO8fM586UhZPwfhOe4yg3Bhdsk5yeN/vab7I84Yky4u7KXJt4OmXjck
        bbeKtxYE6fx/YnGZ09LYo/IWhofLHWo4wAcfJXGD1LIIc350Z0cfPVOQ+9CjkUxRrjJ4gKZdazDCb
        6sT58PQjUDpUjkpOmeB+/dTId4XIbLOmkw7/gnoCPxmWFkKtbzgoXk/KRiExd6E1P5WBBigTHQ6Si
        QJColcXp6ZrYCJndeAdlIEiH4lGQvNdqlWdd7xFZ6fZ8yRydt8M+cj4W33ipil66lxmN1c9sK6/P2
        lMcAJl5g==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pfjxA-003zgH-Ou; Fri, 24 Mar 2023 16:07:44 +0000
Date:   Fri, 24 Mar 2023 16:07:43 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 0/8] Support for shifted port-ranges in NAT
Message-ID: <20230324160743.GF80565@celephais.dreamlands>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230324141856.GA1871@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xbgqTfj/8HbBe0HW"
Content-Disposition: inline
In-Reply-To: <20230324141856.GA1871@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--xbgqTfj/8HbBe0HW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-24, at 15:18:56 +0100, Florian Westphal wrote:
> Jeremy Sowden wrote:
> > Support for shifted port-ranges was added to iptables for DNAT in
> > 2018.  This allows one to redirect packets intended for one port to
> > another in a range in such a way that the new port chosen has the
> > same offset in the range as the original port had from a specified
> > base value.
> >=20
> > For example, by using the base value 2000, one could redirect
> > packets intended for 10.0.0.1:2000-3000 to 10.10.0.1:12000-13000 so
> > that the old and new ports were at the same offset in their
> > respective ranges, i.e.:
> >
> >   10.0.0.1:2345 -> 10.10.0.1:12345
> >=20
> > This patch-set adds support for doing likewise to nftables.  In
> > contrast to iptables, this works for `snat`, `redirect` and
> > `masquerade` statements as well as well as `dnat`.
>=20
> Could you rebase and resend the kernel patches now that the
> refactoring patches have been merged?
>=20
> I'd like to have another look at it now that the fixes and refactoring
> ones are in.

Yup, no problem.

> Background: I wonder if going with NF_NAT_RANGE_PROTO_OFFSET is really
> a good idea or not, because it seems rather iptables-kludgy.
>=20
> But if its not much work it might be simpler to jsut go along with it.
> An alternate approach would be to support addition in nft, so one
> could do:
>=20
> dnat to tcp dport + 2000
>=20
> ... to get such a 'shift effect'.
>=20
> [ yes, the bison parser might not like this syntax, I made it up for
> illustrative purposes. ]
>=20
> Something like this would also allow to emulate TTL/HL target of
> iptables, ATM we can set a fixed value but cannot add or decrement
> them.

J.

--xbgqTfj/8HbBe0HW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQdysgACgkQKYasCr3x
BA2dyRAArN1bRDJz/6PozomINW8rQDSg+XtpMGJ8+c5CnVcudzJhuOeCHeXkDygO
28vhRFvrgFp02OUBe6e/KswJYwWHOfuC+EjZpS7kbEPISuHKOJpIpxLPniHdMzU1
gAQ1E2qv8ffEvbTTztzcBmYTDmyegcmQdqjHQNo2VUoAmv3RBD5IrKGOzSWRW3Rg
tx1JBxRLnb6VGDJCUMAzzcn8+UctO6GbPzyUCAipRi07cqHqx8umqVTOwK2EZac0
cdhb6xr5rY7dwxg7/WUxb6ggNd8szro3oTLlBH0F0RpKbWkn9/Kuf4QDu1KfmCF7
imp3xWOY2cjlPhZum8/KNb10/18VCvLm1+yJE8vElgluZUAAAu8dya4IEtmCxpHS
NyeL1xUH5ZHTJCA1tnFw1ErrVbIUxI02Jo3Q3F8zgOlXIfvDIv+PbMDe6rXh6YqG
/zx9g1HYbcasiR31YehRQNLabZWWGwYteZ7Ssgb+Giug1UO7JeAA+NvhfdtC6rAj
ZkrJmQlIHQu7elGXEAI19Is0g9JdhP6FHK1MDJ44woJFKMB0YQItlXM21XcnKaZp
EtSOAcWQXmVwx3ICh6uaKhyv5EHjqHIjir+wX6BOPVNsm39jVCIQ++pgYD7qetgi
iZtUEQvcmVdLds0DOr7rV/qSin2u/fkQA0AkABP87GRIjTf7ISA=
=W5Q8
-----END PGP SIGNATURE-----

--xbgqTfj/8HbBe0HW--
