Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D58C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Oct 2021 08:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09DB860234
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Oct 2021 08:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhJ1IJS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 04:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJ1IJS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 04:09:18 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B92CC061570
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Oct 2021 01:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=STdAgEMfYWYA0GyzH4y6HnGfXB+VBboJUpU70MTfZ+U=; b=RZkzJy+3VCLavMc2YmTRQJRw7C
        +N/KJgbBUo1T5RYx1d0+reU0dmFOGjQf+d9Ejo/w5J1ICTl2+j1WvcAjdfoUhQw1emnQMjZvcZzNM
        LxnSh6+DCKJcqp8CKNtH7m2sI4UKME7dOfZccqlsI791Ed6XRNIEUkhQYZq7ls0TbEd0/FOydYDMP
        1XvwfJu2VMqHDeHhAo6kkmLGSc9ANWDScCQ1fTU4gxm/sgt7C8i433P8tNgYJdFNkdkUbDtXR+q5o
        nWmaEfVHgtluhxlFtgkwOvNFZFPIc662vh3EnWxS0zfnCmlNiJ+ircBXXoGYulA+8jLaGaZh0Hm94
        FAXzXe3Q==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mg0Qw-00844R-T6; Thu, 28 Oct 2021 09:06:46 +0100
Date:   Thu, 28 Oct 2021 09:06:42 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH] parser: extend limit statement syntax.
Message-ID: <YXpaEvRuNdHVqS1h@azazel.net>
References: <20211002152230.1568537-1-jeremy@azazel.net>
 <YVnFGPHsva1xm7F+@azazel.net>
 <YXkaInao+hLzLkR7@salvia>
 <YXkcZzCwBufryOqc@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="X7E1ycOuvxyf3AUw"
Content-Disposition: inline
In-Reply-To: <YXkcZzCwBufryOqc@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--X7E1ycOuvxyf3AUw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-27, at 11:31:19 +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 27, 2021 at 11:21:42AM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Oct 03, 2021 at 03:58:32PM +0100, Jeremy Sowden wrote:
> > > On 2021-10-02, at 16:22:30 +0100, Jeremy Sowden wrote:
> > > > The documentation describes the syntax of limit statements thus:
> > > >
> > > >   limit rate [over] packet_number / TIME_UNIT [burst packet_number packets]
> > > >   limit rate [over] byte_number BYTE_UNIT / TIME_UNIT [burst byte_number BYTE_UNIT]
> > > >
> > > >   TIME_UNIT := second | minute | hour | day
> > > >   BYTE_UNIT := bytes | kbytes | mbytes
> > > >
> > > > This implies that one may specify a limit as either of the following:
> > > >
> > > >   limit rate 1048576 / second
> > > >   limit rate 1048576 mbytes / second
> > > >
> > > > However, the latter currently does not parse:
> > > >
> > > >   $ sudo /usr/sbin/nft add filter input limit rate 1048576 mbytes / second
> > > >   Error: wrong rate format
> > > >   add filter input limit rate 1048576 mbytes / second
> > > >                    ^^^^^^^^^^^^^^^^^^^^^^^^^
> > > >
> > > > Extend the parser to support it.
> > > >
> > > > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > > > ---
> > > >
> > > > I can't help thinking that it ought to be possible to fold the two
> > > >
> > > >   limit rate [over] byte_number BYTE_UNIT / TIME_UNIT [burst byte_number BYTE_UNIT]
> > > >
> > > > rules into one.  However, my attempts to get the scanner to tokenize
> > > > "bytes/second" as "bytes" "/" "second" (for example) failed.
> > >
> > > Having reread the Flex manual, I've changed my mind.  While it would be
> > > possible, it would be rather fiddly and require more effort than it
> > > would be worth.
> >
> > I can apply this workaround meanwhile we have a better solution for
> > this if this is an issue on your side.
> >
> > Did you get any bug report regarding this?
>
> Another possibility is to remove the existing call to rate_parse().
>
> the bison parser accepts both:
>
> add filter input limit rate 1048576 mbytes / second
> add filter input limit rate 1048576 mbytes/second
>
> after your update, right? I'm missing a few deletions in this previous
> (the existing rules). I think there's a way to consolidate this bison
> rule.

I'll take another look.

J.

--X7E1ycOuvxyf3AUw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmF6WgwACgkQKYasCr3x
BA32oBAAnweIj5ftE+dAqjv4iDqOz7f5bvnYZe4HCh97bfCBPjuABfus+YSEhM2T
1eqp7Df47FhvcJbSJvukbdqF//sLLrOv9Fj2X7KyZ8nLRNhLQw/upFtcfyTUs1uO
lK+MdVwnDkHTjjB6HdYEr8b+ym8fbI49IqF30FJGyUYcH9bmuFrnF5wn+u/AOGxd
7DwcE2SgCPF/+V6DCSYlBuA0KKkFJjPMTtV5dl4hx2PBYFbtM/nubUEZi/I+KSLd
rxvVGuQbK+cxZUftlR+0fVsVstIW0wTxpW4xolbSA81xFxxZORUADyvxwZsQjXH7
6fey55Bcx0DX+mE6FF/G41f+pT7kogu1cHrdZoaiemY/qBzv5rV3gCbTBK7Q2NQT
6uwv85KtG8oPYRJN33SKB4wpN3N8idYt7nw+wE6EA4oxp4uk/VTGyQcJZz25ewLi
PQukm3x2IN/zIKB6Y2Oi4QoAcQfrHHm7PgjxX3Zq99QC+YwEMO7HVAgxQzNwix7F
4W/IuimZIowTR3BIRSHjSFStp29gZRI1VCvONnZMONz83btKFw0Ejm1h2Zq7X6Xq
o6kNEzAkT7efXvYnF0JS6g6r/guTDA9QQbCZl9FwN5sc4IUin/I6BqoEo9A+zBI7
Edt54AWjF2J2H2wk1Z+U6lsVtr6rBByg+1TqXUIY/M1liUVQ+jI=
=g/HP
-----END PGP SIGNATURE-----

--X7E1ycOuvxyf3AUw--
