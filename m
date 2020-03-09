Return-Path: <SRS0=jBJt=42=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C17C10F27
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Mar 2020 09:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 973CB20727
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Mar 2020 09:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgCIJZ5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 05:25:57 -0400
Received: from correo.us.es ([193.147.175.20]:48074 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgCIJZ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 05:25:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B19CB3066A4
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Mar 2020 10:25:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3120DA3AA
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Mar 2020 10:25:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 98DB9DA39F; Mon,  9 Mar 2020 10:25:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3ECBDA3AC;
        Mon,  9 Mar 2020 10:25:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Mar 2020 10:25:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A591C42EF9E1;
        Mon,  9 Mar 2020 10:25:31 +0100 (CET)
Date:   Mon, 9 Mar 2020 10:25:50 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: shift_stmt_expr grammar question
Message-ID: <20200309092550.5xcghwtzso7x7cfi@salvia>
References: <20200308104003.GC121279@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6qrzvvwyjg3f24qh"
Content-Disposition: inline
In-Reply-To: <20200308104003.GC121279@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--6qrzvvwyjg3f24qh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

On Sun, Mar 08, 2020 at 10:40:03AM +0000, Jeremy Sowden wrote:
> Just noticed that the production for right shifts differs from the
> production for left shifts (src/parser_bison.y, ll. 3020ff.):
>=20
>   shift_stmt_expr    :       primary_stmt_expr
>                      |       shift_stmt_expr         LSHIFT          prim=
ary_stmt_expr
>                      {
>                              $$ =3D binop_expr_alloc(&@$, OP_LSHIFT, $1, =
$3);
>                      }
>                      |       shift_stmt_expr         RSHIFT          prim=
ary_rhs_expr
>                      {
>                              $$ =3D binop_expr_alloc(&@$, OP_RSHIFT, $1, =
$3);
>                      }
>                      ;
>=20
> Is there a reason why the RHS of LSHIFT is primary_stmt_expr, but the
> RHS of RSHIFT is primary_rhs_expr?

It's likely a leftover. The rhs rule was introduced to reduce chances
of hitting shift/reduce conflicts, and to restrict syntax on the rhs.

--6qrzvvwyjg3f24qh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEFEKqOX9jqZmzwkCc1GSBvS7ZkBkFAl5mC5oACgkQ1GSBvS7Z
kBm0fBAAo34hWsRQAWA8R0FmEtWIjDlpMUIgjLnWj8CzQHwAun6KKwW9GZ6H+DTv
F2sEo9Se1IrPtts7OS8zn31qjU/n4p1Dt9lUljIXve1F26y3KIpUp3VXEkzJ/NjM
8E80S9T5ba5TmgLCXeF5eN9lpD+NRrgOY1oGp8TOMuo6CJOKdiAeN+ztpphTZ5Lg
ZepJHt0QSLAy+di2qhrnXHPObSTJQ5qG36dZR4a/YLel0z4V5aHXSXDe6FHK1otW
OKNCEruHn7z4M2u07QPU7qdEb4q9B10KzirZT/h1eZHMWVefa1WPpJrgs/2hwV7m
ciqacSrAbnEwduQn3Uzx2BizYLTzIQaZWtj5YN4S62cTwzAkV56m13F8Skxsfgxa
i4dMKEOUY8RBWpkf5oflMFg23nSfJmMPa52CVYIo+8IPh7WPSHcnNy7/EHqa9nXq
IvjhPNWt9q17VUw6ttZORaxxxWlne1t0aetx/8dDRl48+unlYY/nsucM/86dorGw
ABM5n0u9MmxFf81B22JUAnpWcEtyWipcf1O6f1BvNvl9TDd3lUCSSx8OOvScOYow
v9ZQfV4ZTQoKlkTWl9eeUkUjjnnsChK1XxC7aUsPoL1XhrErFVJCqWf/BkkSMzXc
7GzBNsTDr1ICZ5Akseryh5A7xCYW/NU4cC6sT3XgycKbCj1Y7hI=
=IR3q
-----END PGP SIGNATURE-----

--6qrzvvwyjg3f24qh--
