From: Eric Leblond <eric@regit.org>
Subject: Re: [RFC PATCH 0/1] add insert after to nf_tables
Date: Thu, 20 Jun 2013 14:17:00 +0200
Message-ID: <1371730620.6038.2.camel@ice-age.regit.org>
References: <1371628997-13548-1-git-send-email-eric@regit.org>
	 <51C17E26.2020608@linux.intel.com> <20130620094243.GA5703@localhost>
	 <51C2D0D8.1020309@linux.intel.com> <20130620101012.GA19679@localhost>
	 <51C2DB10.1060607@linux.intel.com>
	 <20130620104621.GC31140@macbook.localnet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-N5XI55vXdfB+b7EG5b06"
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:55746 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab3FTMRI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:17:08 -0400
In-Reply-To: <20130620104621.GC31140@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-N5XI55vXdfB+b7EG5b06
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 20 juin 2013 =E0 12:46 +0200, Patrick McHardy a =E9crit :
> On Thu, Jun 20, 2013 at 01:36:00PM +0300, Tomasz Bursztyka wrote:
> > Hi Pablo,
> >=20
> > >>Hum, how?
> > >>The handle it will get from the notification is the handle of the
> > >>newly created rule, not the one used to identify the rule for
> > >>insertion.
...
> LE_F_COMMIT in its anonymous enum)
> >=20
> > Maybe there is a better way, probably. But you get my point.
>=20
> We could instead of using NLA_RULE_HANDLE for the position add a new
> attribute NLA_RULE_POSITION and use that both for creating rules and
> for notifications.

I like that. Reusing NLA_RULE_HANDLE was making feel somehow
uncomfortable.

>  It would always be set and contain the handle of
> the rule preceeding the new rule (for NLM_F_APPEND) or the one
> following it (for !NLM_F_APPEND).

Nice, reworking my patches in that direction.

BR,
--
Eric

--=-N5XI55vXdfB+b7EG5b06
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBRwvK8nxA7CdMWjzIRAu0nAJ4+uha196M82alt5N9iTHSEn3SsagCdG0BY
/7RMccFaskgt9aC2iwAh+do=
=ewrE
-----END PGP SIGNATURE-----

--=-N5XI55vXdfB+b7EG5b06--

