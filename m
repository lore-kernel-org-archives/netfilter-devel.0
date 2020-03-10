Return-Path: <SRS0=Yj8l=43=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6BAC10F27
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Mar 2020 09:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CD222051A
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Mar 2020 09:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="C4JFVtsV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgCJJaN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:30:13 -0400
Received: from kadath.azazel.net ([81.187.231.250]:42250 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJJaN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 05:30:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=F0xITl+uXOPQGx1AaKxBaLqdwN6COx6hQ21R0g/74nY=; b=C4JFVtsV/H58C3W3d9mx05hA6/
        IjlN+LDL4N9qnQ+Ap0JqvoF8M99/KREgvcwOYUYl41KdVQ7kcmXpyZwpwLh5nC1ivMbRcw0BtF8+E
        M9EYIUkrLWYjPJ84Ql9FESpDUE3H6DQfpp04hlX3sld25YfZQ69NGXU9T4yAgyUtcPTgMmFSqy5T5
        hsgPHTBix19UVz+n2Dyqrn+O3fc08S+0rW6a0FSZqVkXWJoUfhodqY3y2ahVhA/c2z7aknqFg1U8f
        pngYA605KSdmY9eTOad8qWqekGGivbaaiFNkTX3aWu6rNGu9GD2MYKSySy+y4L5LG18kq1hnvVE34
        AeGSvGQQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1jBbDF-000761-VW; Tue, 10 Mar 2020 09:30:10 +0000
Date:   Tue, 10 Mar 2020 09:30:08 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 18/18] tests: py: add variable binop RHS tests.
Message-ID: <20200310093008.GA166204@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
 <20200303094844.26694-19-jeremy@azazel.net>
 <20200310023913.uebkl7uywu4gkldn@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20200310023913.uebkl7uywu4gkldn@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-03-10, at 03:39:13 +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 03, 2020 at 09:48:44AM +0000, Jeremy Sowden wrote:
> [...]
> > diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
> > index 661591257804..17a1c382ea65 100644
> > --- a/tests/py/any/ct.t.payload
> > +++ b/tests/py/any/ct.t.payload
> > @@ -359,6 +359,39 @@ ip test-ip4 output
> >    [ lookup reg 1 set __map%d dreg 1 ]
> >    [ ct set mark with reg 1 ]
> >
> > +# ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
> > +ip
> > +  [ ct load mark => reg 1 ]
> > +  [ bitwise reg 1 = (reg=1 & 0xffff0000 ) ^ 0x00000000 ]
>
> These two are: ct mark and 0xffff0000
>
> > +  [ meta load mark => reg 2 ]
> > +  [ bitwise reg 2 = (reg=2 & 0x0000ffff ) ^ 0xffffffff ]
>
> Refetch.
>
> > +  [ meta load mark => reg 3 ]
> > +  [ bitwise reg 3 = (reg=3 & 0x0000ffff ) ^ 0x00000000 ]
>
> These two are: meta mark and 0xffff
>
> > +  [ bitwise reg 1 = (reg=1 & reg 2 ) ^ reg 3 ]
>
> This one is triggering the refetch from meta load in reg 2, right?
>
> If so, probably extend nft_bitwise to support for 'or' from two
> registers would make things more simple?
>
>      [ bitwise reg 1 = (reg 1 | reg 3) ]
>
> This one requires two registers as input for this new OR operation.
>
> > +  [ ct set mark with reg 1 ]
> > +
> [...]
> > diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
> > index d627b22f2614..d6c5d14d52ac 100644
> > --- a/tests/py/ip/ip.t.payload
> > +++ b/tests/py/ip/ip.t.payload
> [...]
> > +# iif "lo" ip dscp set ip dscp or 0x3
> > +ip
> > +  [ meta load iif => reg 1 ]
> > +  [ cmp eq reg 1 0x00000001 ]
> > +  [ payload load 2b @ network header + 0 => reg 1 ]
> > +  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
> > +  [ payload load 1b @ network header + 1 => reg 2 ]
> > +  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000000 ]
> > +  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
> > +  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000003 ]
> > +  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
> > +  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
> > +  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
>
> Probably extending nft_bitwise again is the way to go to simplify
> this?
>
> 1) fetch two bytes from payload => reg 1.
> 2) reg 2 = ( reg 1 | 0x000c )
>
>    userspace 0x3 << 2 => 0x0c, then extend this to two bytes => 0x000c
>
> This is an OR with immediate value.
>
> 3) payload write reg 1
>
> This one requires two immediates.
>
> Then, how does 'ip dscp set ip dscp and 0x01' bytecode looks like?
>
> 1) fetch two bytes => reg 1.
> 2) reg 1 = (reg 1 & 0xff07) ^ 0x0
>
> userspace 0x01 => 0x04 (after << 2). Then, 0x04 & 0xff03 = 0xff07.
>
> This case should be possible to support it with the existing bitwise.
>
> The delinearization path will need to calculate the closest field
> matching, but there is already code for this in the userspace tree (it
> was required when matching ip dscp using bitwise operation).
>
> Would it be possible to simplify all this through new kernel
> extension? If so, I'm sorry for wasting resources, this might go to a
> different direction than _MREG and _XREG.

No problem. :)

> Moreover, for field updates like in these examples, I wonder if it is
> worth to introduce a new syntax, ie.
>
>         ip dscp |= 0x01
>         ip dscp or_eq 0x01
>
>         ip dscp &= 0x01
>         ip dscp and_eq 0x01
>
> | and & might be a problem for the shell, for the native nft cli this
> should be fine. But this is a different issue.

Thanks for the feedback, Pablo.

J.

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl5nXhoACgkQonv1GCHZ
79fcrQv/UZ6QEyNUuAv04/P4KLjb6WCuQV9REjyCJj3tE8Q9FBbXrzrbCZ8dwBrx
5SFiY799MKcvVesGrchdojM3wfMNZb18zYvhLpK8h/YaJCYBX5W0jBqK5iwMIc3c
GJlyHY6HBek9Vx5B67sRrEEp7rxXcbOqzDIAyJrUeF6FVP61Z1OLzJDbnN2SZda1
4DgJmwsztqJGRzR1ACNUsXJpl5TK+d25HOTe+OMLRVj3cd/2aFoZaH8imYQlKcOf
zXSNxm+h5kzS9t2WBcCyIRDe9iV/Z9MagdnDH3E0jIltmZlP1e1hdN5B5PSiEZht
UxVdB3y5Rwt25tjH+1Y4fp792jdhXq3LUar1y5z1Gz/atgoYZDK4qP3U8jbt2eUH
ZpfARBmrif81QkSuZ/2aMVuc3MeADRYAtQJECOuSghRCCC26v6zKCLe0ivRnnX4v
T2uwMM/Kn7VQKNyp9f/wEFD40VMRVFCu7HZcUHM9IxMu/zRSAQpjm0Yz79Q3tHmX
fSn2cOY2
=ndj9
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
