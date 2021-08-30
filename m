Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAB9C432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 10:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8971561076
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 10:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbhH3KDp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Aug 2021 06:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhH3KDp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 06:03:45 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F56EC061575
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2021 03:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8u+LPP21mFD+eg59Bq9nuAbo0LtNaI24+5QwilZxCk8=; b=lEzsfpv6AmpCHHnV+6aaLJEDTt
        4gV6X/iUlJFaSi9U3JGQoQsEX+N43emm1blBcKLnUIHskQ6rKs0rcCntsbhjydqYab75o8Nckt4Vt
        r7VBnkCyuQX6Cy3WXReQYwOqSEKLnUXMCBmKjw5NS4umKnAPlXsYjTh0G01660znzaiAKmP4xFI0k
        rKJQF9G5HoQlRFDakDdqPTpBtkpk/P4G2RFwyH+gjAdTDCJERbBh/Q4Afxc9IElMvyIMkPfyBSoGJ
        3aNSfJCaMa7Xz4T02bJTsat0S0qqsqVXNlIyv8XZ/Vs19AqkMqQ9kQIl4AMUtuaQCkJafNYI/wjkd
        ZWZtB4Yw==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mKe7q-0007wK-Tx; Mon, 30 Aug 2021 11:02:47 +0100
Date:   Mon, 30 Aug 2021 11:02:45 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log 0/6] Implementation of some fields
 omitted by `ipulog_get_packet`.
Message-ID: <YSysxcqZ7iSZsPjZ@azazel.net>
References: <20210828193824.1288478-1-jeremy@azazel.net>
 <20210830001621.GA15908@salvia>
 <YSw1dN3aO6GeIPWq@slk1.local.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Oant7L4ChF31L51F"
Content-Disposition: inline
In-Reply-To: <YSw1dN3aO6GeIPWq@slk1.local.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Oant7L4ChF31L51F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-30, at 11:33:40 +1000, Duncan Roe wrote:
> On Mon, Aug 30, 2021 at 02:16:21AM +0200, Pablo Neira Ayuso wrote:
> > On Sat, Aug 28, 2021 at 08:38:18PM +0100, Jeremy Sowden wrote:
> > > The first four patches contain some miscellaneous improvements,
> > > then the last two add code to retrieve time-stamps and interface
> > > names from packets.
> >
> > Applied, thanks.
> >
> > > Incidentally, I notice that the last release of libnetfilter_log
> > > was in 2012.  Time for 1.0.2, perhaps?
> >
> > I'll prepare for release, thanks for signalling.
>
> With man pages?

I was waiting for you and Pablo to finalize the changes to
libnetfilter_queue with the intention of then looking at porting them to
libnetfilter_log. :)

The most recent Debian release included a -doc package with the HTML
doc's in it, and the next one will include the test programmes as
examples, but I think the man-pages need a bit of work first.

J.

--Oant7L4ChF31L51F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEsrL8ACgkQKYasCr3x
BA0M+Q//Y4bSa2zWHpPxbjbIY3Sw4i+PbCY13QrfrvDr9WIYWKGKKAOOk5nzrIDS
GN7SykjkztbvP5Nz2RihtZXjqBi1iYdocZUf02g2QWgk/aXw08zW4iYkFfmf6wLI
4QnWoahkTJld4JSWX4ud8QirJXN/UL6QDrIlk5Z3qOnhIqEe80KASTQk+WdSGxVe
XQIueW8BtyZu3o8z4yxqqUlIQLYISPbbtJzyqi19/pdKjnkNkyqT6N1ROtKV7YZo
uqkZkhfyUAhHrsR0cvOp9py2cQnClNYhC9o2NEdb68NjG5/EX0NF5CY957xm7OMJ
iHdxrpQBEp/lanRBLgcMDSNy7+MAJnM8vP9b2PtPTzkyR1X6+jCQ+AUPA8Ws4yiv
Wa+JeuLv3FKzMau/qd5+OIe4yuhtKc7qiHpmJR6fE9UhTk/sxigVwMambaHJghRy
wg5/HPj6pAsI/jR4KzoIqEYAG9+BK1nnccebHrc9/A6h/IbMqNZ+vgBK+AstkSqS
Mk38S4flnu2rLi0LcnmmVSEW0BQAHCWy8nsGOxn2dW+fMXHIUdxBsFVZtPmWiXwe
T5Rd7WrbIwlABNjkMKE5CY9dcqIsZpYyBVFJ4IbaskBqwv50SA2/VOlhiIjGW1Bz
cFCqeu/7PoX2fhWoWVWd16WftIg4vu2rvJcSO8qBKM1bdB0JVkI=
=nnkz
-----END PGP SIGNATURE-----

--Oant7L4ChF31L51F--
