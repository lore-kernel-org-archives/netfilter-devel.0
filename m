From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: Re: [PATCH] netfilter: Allow dropping packet after call to l4proto->packet
Date: Fri, 13 Mar 2009 09:27:14 +0100
Message-ID: <200903130927.20388.christoph.paasch@gmail.com>
References: <200903121603.02733.christoph.paasch@gmail.com> <1236870826-10054-1-git-send-email-christoph.paasch@gmail.com> <49B945C3.4000904@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1636059.8jX3AfRmo2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:44731 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZCMI1Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:27:25 -0400
Received: by ewy25 with SMTP id 25so2429538ewy.37
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2009 01:27:22 -0700 (PDT)
In-Reply-To: <49B945C3.4000904@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--nextPart1636059.8jX3AfRmo2
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu March 12 2009 wrote Pablo Neira Ayuso:
> Christoph Paasch wrote:
> > As NF_DROP = 0, no packets would ever have been dropped.
>
> Good catch. I'll also change -NF_DROP by NF_DROP in
> nf_conntrack_proto_tcp.c. No need to resend the patch. Thanks.

OK, then change also -NF_DROP to NF_DROP in nf_conntrack_in(...), at
if (ret == -NF_DROP)

--
Christoph Paasch

www.rollerbulls.be
--

--nextPart1636059.8jX3AfRmo2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm6GOMACgkQLHtZTroOLZv0IwCfdogYqYuMfPjpVTLwCK4ftwh5
w4MAn1OLsPvpPE4oB9MdOxuSEoDuziHg
=D0XN
-----END PGP SIGNATURE-----

--nextPart1636059.8jX3AfRmo2--
