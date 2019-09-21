Return-Path: <SRS0=2UWv=XQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DD0C49ED7
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 11:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 915D4208C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 11:07:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="eRz82JAR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407529AbfIULHr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 07:07:47 -0400
Received: from kadath.azazel.net ([81.187.231.250]:59704 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407437AbfIULHq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 07:07:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pq/QfX0agodfAMGopBws3fD6+U/aAX6MJ8Fwx/z5RcY=; b=eRz82JAR5518f+a7eJyQYat2dT
        s8OpJ0tvgGXGEPX4/VzBZ638118TcOIZhE1F11Wd85EQ1aZvRUQBcB1bYxYze/YrTh0EW+Pp5DUIX
        j2FTJsbzjf3CUgnvTgOKydsPS6mGdv9L5cdO1py/7pOn+AbmUiXPq6Qp1+ohHKKiun+uSS7gyFk4K
        r9taxbaKbY3t69cTJNuQ3MtkQHjAnyl2rOz8DhJxdmr6aj48+hAiUV6qhYOjU34ybWDzq49E/HITD
        fdOkvR5esKqMXZb311gs87DmQZJXVQX3G8ObbqnSOb6hj2FKYF9Z5C37y8d9DGf7s52WjsTRDPNWe
        lBMl5u2A==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iBdEu-0007i1-V1; Sat, 21 Sep 2019 12:07:45 +0100
Date:   Sat, 21 Sep 2019 12:07:43 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH RFC nftables 0/4] Add Linenoise support to the CLI.
Message-ID: <20190921110743.GA28617@azazel.net>
References: <4df20614cd10434b9f91080d0862dd0c@de.sii.group>
 <20190916124203.31380-1-jeremy@azazel.net>
 <20190920101520.kwwns3v7nma646bv@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20190920101520.kwwns3v7nma646bv@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-09-20, at 12:15:20 +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 16, 2019 at 01:41:59PM +0100, Jeremy Sowden wrote:
> > Sebastian Priebe [0] requested Linenoise support for the CLI as an
> > alternative to Readline, so I thought I'd have a go at providing it.
> > Linenoise is a minimal, zero-config, BSD licensed, Readline
> > replacement used in Redis, MongoDB, and Android [1].
> >
> >  0 - https://lore.kernel.org/netfilter-devel/4df20614cd10434b9f91080d0862dd0c@de.sii.group/
> >  1 - https://github.com/antirez/linenoise/
> >
> > The upstream repo doesn't contain the infrastructure for building or
> > installing libraries.  I've taken a look at how Redis and MongoDB
> > handle this, and they both include the upstream sources in their
> > trees (MongoDB actually uses a C++ fork, Linenoise NG [2]), so I've
> > done the same.
> >
> >  2 - https://github.com/arangodb/linenoise-ng
> >
> > Initially, I added the Linenoise header to include/ and the source
> > to src/, but the compiler warning flags used by upstream differ from
> > those used by nftables, which meant that the compiler emitted
> > warnings when compiling the Linenoise source and I had to edit it to
> > fix them.
>
> Could you silent these warnings via CFLAGS just like we do with
> mini-gmp.{c,h}? We already cache a copy of mini-gmp.c in the tree,
> this would follow the same approach, just the source under src/ and
> the header in include/.

Ah, yes, thanks for the pointer.

> > Since they were benign and editing the source would make it more
> > complicated to update from upstream in the future, I have, instead,
> > chosen to put everything in a separate linenoise/ directory with its
> > own Makefile.am and the same warning flags as upstream.
> >
> > By default, the CLI continues to be build using Readline, but
> > passing `with-cli=linenoise` instead causes Linenoise to be used
> > instead.
>
> Probably good if you can also update 'nft -v' to display that nft is
> compiled with/without mini-gmp and also with either
> libreadline/linenoise.

Will do.

> > The first two patches do a bit of tidying; the third patch adds the
> > Linenoise sources; the last adds Linenoise support to the CLI.
>
> No objections, please update tests/build/ to check for this new
> ./configure option.

Will do.

J.

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2GBG8ACgkQ0Z7UzfnX
9sNJsA//fuV31N2+tSJccDUaobVVkIvlSfk8wmiQ3gp9/Ag4utG/eEooLn6mRZfB
ZG6nZky2DcVurbO+13F5GVzdmQUEphxLFLLYh9kGa4jQiIk1SQjR7kgGUsO2nlNr
MJlDxJ5zsk9u2aggCpXTqDhkoxQL3grRbjopvnvhputx/MjnKR3y//bDyyPcqw2x
4kuH+P1Mi+f2hz5gpolbbFEZxzUf9X45L/pYfBvWxTLE+rOFEL4kWDkf65zYKixT
9hG0C3mPHsxmwQXKzhkNmqoPumo8nlOvWCt+YsfmFxefrmt8vPlmuIJqpUC2yl/d
raGPM+PTwqtDh5cdmGonegMpkV7E4dEiU3IKbOEs0Vr71V4LEwypy7P8zNU6zKek
fEvSp8cK9iZl4OhMzETFbrb3I1C5AzfnexPirryQUNcPH64w0xE6iCAHajtu7T96
VNNJ2D07e6RIzbKK+7PN/NEghPVuBa+k/M8Sbc6ot6c0NzlYdbCIr+VNrdJB4Cq+
ZWS3GdmOYoA8a/n9WvkSP7nJfwHf9iGjh2DzH5eo3jcklRZ1bST6RTLf3kHIjHcV
ccmwtgGJhd5OB6Ud/OgHcEDjCWGDtjC9n74qpeX+DkvRISEtPUZt56xQcuJeM6hp
+ly27ThHXuEtvcoxPIRI627J79FZ3IuJwSwQqB9Le8vNtT4gDIw=
=UrlG
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
