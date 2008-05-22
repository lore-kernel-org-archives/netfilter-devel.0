From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] linux-next: Tree for May 21 - build failure with
 netfilter on __nf_ct_helper_find()
Date: Fri, 23 May 2008 09:29:21 +1000
Message-ID: <20080523092921.9b9cb49b.sfr@canb.auug.org.au>
References: <20080521155936.466bbe86.sfr@canb.auug.org.au>
	<20080521113230.GA10830@linux.vnet.ibm.com>
	<20080521225214.507eb400.sfr@canb.auug.org.au>
	<4834239D.90500@linux.vnet.ibm.com>
	<20080522101148.fbabee96.sfr@canb.auug.org.au>
	<20080522081546.GB7222@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_May_2008_09_29_21_+1000_MFj7k2MbHqRMI6vQ"
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org, apw@shadowen.org,
	Franck Bui-Huu <fbuihuu@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:34460 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110AbYEVX3e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 19:29:34 -0400
In-Reply-To: <20080522081546.GB7222@elte.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Signature=_Fri__23_May_2008_09_29_21_+1000_MFj7k2MbHqRMI6vQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Thu, 22 May 2008 10:15:46 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > Actually this is caused by the splitting out of the rcu stuff from=20
> > list.h that is in linux-next, sorry.
>=20
> this bug has been fixed in the -tip tree 9 days ago:
>=20
> |  commit db3c7a9f07a212d1774e6b432a08b231340e984d
> |  Author: Ingo Molnar <mingo@elte.hu>
> |  Date:   Tue May 13 15:37:05 2008 +0200
>=20
> that commit was in intermediate testing phase in the 'scratch' branch,=20
> and a few days ago linux-next stopped picking up the scratch branch.
>=20
> I've now cherry-picked this fix over into the rcu branch and everything=20
> should be fine again in the next linux-next iteration.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_May_2008_09_29_21_+1000_MFj7k2MbHqRMI6vQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINgHaTgG2atn1QN8RAirPAJ9OdGFLSxM+fsq6tbrf06qPRHezawCgiRGJ
VPhN/+MTSkl7oWkgg5sGQM0=
=vm8l
-----END PGP SIGNATURE-----

--Signature=_Fri__23_May_2008_09_29_21_+1000_MFj7k2MbHqRMI6vQ--
