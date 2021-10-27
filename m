Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73203C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 20:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54A3E60F39
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 20:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240602AbhJ0Umx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 16:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbhJ0Umw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 16:42:52 -0400
X-Greylist: delayed 2285 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Oct 2021 13:40:26 PDT
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDFAC061570
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Oct 2021 13:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IceR7HXeh4b1zIyfxIcmS2JakqoLVLiXacfHFvafJnk=; b=QjC7c44NXtG3J8xEyBJhRzLjFN
        s/4cwsZAVyBODziSEOs4YinleneWXKnzG3cfmrPze6wWn9KmhW8gp09OyB3CvYGj/6WQbZieg9ZHg
        9orng+a0EDpFYTrSC3jPWlzdzLJ/cujHceV5UcYmrfsJL87lHTIKvZsxIiuZdOWcEgD3rgSh8ilQM
        jgSlyXjams/vNElPODIG7F20anyH6Yeft3OUqpExi/AWLjScKIRYvRN3R1Tr2ODK1HJmXPu5loqzJ
        Ji291T3euyCQur+FA890h9pkO9jJG0hPZe8cmcciHCKAS0IMn0siVO5FoEXORBv/wrMCEuer2yb6T
        KqfsrTFQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mfp7p-007IVW-C5; Wed, 27 Oct 2021 21:02:17 +0100
Date:   Wed, 27 Oct 2021 21:02:13 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH] parser: extend limit statement syntax.
Message-ID: <YXmwRcI1A5wpNZs7@azazel.net>
References: <20211002152230.1568537-1-jeremy@azazel.net>
 <YVnFGPHsva1xm7F+@azazel.net>
 <YXkaInao+hLzLkR7@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sOb7zdfFxOijEGGI"
Content-Disposition: inline
In-Reply-To: <YXkaInao+hLzLkR7@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--sOb7zdfFxOijEGGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-27, at 11:21:38 +0200, Pablo Neira Ayuso wrote:
> On Sun, Oct 03, 2021 at 03:58:32PM +0100, Jeremy Sowden wrote:
> > On 2021-10-02, at 16:22:30 +0100, Jeremy Sowden wrote:
> > > The documentation describes the syntax of limit statements thus:
> > >
> > >   limit rate [over] packet_number / TIME_UNIT [burst packet_number packets]
> > >   limit rate [over] byte_number BYTE_UNIT / TIME_UNIT [burst byte_number BYTE_UNIT]
> > >
> > >   TIME_UNIT := second | minute | hour | day
> > >   BYTE_UNIT := bytes | kbytes | mbytes
> > >
> > > This implies that one may specify a limit as either of the following:
> > >
> > >   limit rate 1048576 / second
> > >   limit rate 1048576 mbytes / second
> > >
> > > However, the latter currently does not parse:
> > >
> > >   $ sudo /usr/sbin/nft add filter input limit rate 1048576 mbytes / second
> > >   Error: wrong rate format
> > >   add filter input limit rate 1048576 mbytes / second
> > >                    ^^^^^^^^^^^^^^^^^^^^^^^^^
> > >
> > > Extend the parser to support it.
> > >
> > > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > > ---
> > >
> > > I can't help thinking that it ought to be possible to fold the two
> > >
> > >   limit rate [over] byte_number BYTE_UNIT / TIME_UNIT [burst byte_number BYTE_UNIT]
> > >
> > > rules into one.  However, my attempts to get the scanner to
> > > tokenize "bytes/second" as "bytes" "/" "second" (for example)
> > > failed.
> >
> > Having reread the Flex manual, I've changed my mind.  While it would be
> > possible, it would be rather fiddly and require more effort than it
> > would be worth.
>
> I can apply this workaround meanwhile we have a better solution for
> this if this is an issue on your side.
>
> Did you get any bug report regarding this?

Can't quite remember how I found it.  I may have been doing some testing
in relation to this:

  https://lore.kernel.org/netfilter-devel/20211007201222.2613750-1-jeremy@azazel.net/#r

I happened to notice that nft would accept all these:

  limit rate 1048576/second
  limit rate 1048576 / second
  limit rate 1048576 mbytes/second

but not this:

  limit rate 1048576 mbytes / second

The problem is that the scanner defines a string as:

  ({letter}|[_.])({letter}|{digit}|[/\-_\.])*

This means that:

  1048576/second

cannot be tokenized as a string, but:

 mbytes/second

can.  Thus the scanner will tokenize both

 1048576/second

and:

  1048576 / second

as:

  numberstring slash string

allowing this parser rule:

  LIMIT RATE limit_mode NUM SLASH time_unit limit_burst_pkts close_scope_limit

to match both.  On the other hand, the scanner will tokenize:

  mbytes/second

as:

  string

which is matched by the existing parser rule:

  LIMIT RATE limit_mode NUM STRING limit_burst_bytes close_scope_limit

but:

  mbytes / second

as:

  string slash string

and so I added a new parser rule to match the latter.

I did consider removing '/' from the scanner's definition of "string",
and it didn't seem to cause any unit test failures, but I dare say
somebody has used it somewhere weird that would break. :)

The other possibility I tried was to have a separate definition of
"string" active in the "SCANSTATE_LIMIT" start-condition, but that
turned out to require a lot more than just the one extra rule and to be
a much more fiddly and invasive change than just adding the parser rule.

J.

--sOb7zdfFxOijEGGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmF5sD0ACgkQKYasCr3x
BA0ONQ/9HiRBvRZ/V0BPLk0hrYbSS9KndodLU+ReiTRSIMXD+E/1FBnKeUq/CFur
kUQgyTFjIs27XyueEDwk13tPHMLeYOVcBUfRivLYE2IuUQzLixhWfAsoFYzBBFo5
wob6/yIXsf1BBcdA22dikyllf2Fg7IGUWcpyxFjzeIyDhcIQHovTfk0xjWXYVQar
8MJOZc5IeRe6q0p2KIP96SCWPv/E2svzGEC7hQU9/6txd9ylqGxb4rai0YgHV9As
5mvVyz4IEW5GKmvuC5ZlwCYXMsx5T2h5Lha0mnHl5eYyN7h4SGQKT01oa2ijG6cO
id7sOTcCMILRWVdBDsDSe/ofK9/m9+piKpnPbTOurXGUKv5b2mrfuOtqPH0aVbLa
vD1mOUNX+xkCz/ocF0TJRQUjM12wPRe74PRAoJVwX1SRn6C8QiRJUrmdGtQGq1dx
YJXyYU3wYaGM8cqL1tCfK58ccWAc2BwX2Buc9+lgwwMY4Za0vC3wLa7Hez+dv43R
UhSl2PH1SNjfbTprmg2OGLjNHPCvZCW8WvoXLKJXQKeYlodWj0LdmN1SS7Wjyz8S
ZC+budAqhL+MxCbpWG9wbcMzJ6uB/6AEWi9vT3b+hVOQRGT1eRlwxnZJSdiCju/J
Dcvm0tfrDbKAGgJUXjHaw6SOdOP5zqBcdX6yt/4KIe/5Xxz7CKg=
=gRt4
-----END PGP SIGNATURE-----

--sOb7zdfFxOijEGGI--
