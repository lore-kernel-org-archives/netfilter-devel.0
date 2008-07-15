From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH] rework, fill MAC address in ULOG for ethernet.
Date: Tue, 15 Jul 2008 14:49:24 +0200
Message-ID: <20080715124924.GA7175@khasse.inl.fr>
References: <486B88F4.7060704@trash.net> <1215554219-13763-1-git-send-email-eric@inl.fr> <487497F4.8070004@netfilter.org> <48749899.7070505@trash.net> <48749AF1.60900@netfilter.org> <48749CAA.3030306@trash.net> <20080709210454.GA4461@ghlodit.inl.fr> <48752B26.3010404@trash.net> <20080710203931.GB4000@bayen.regit.org> <48776972.8080305@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:33060 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbYGOMta (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:49:30 -0400
Content-Disposition: inline
In-Reply-To: <48776972.8080305@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Friday, 2008 July 11 at 16:08:50 +0200, Patrick McHardy wrote:
>>> This comment made me believe that it would break header
>>> printing for non-ethernet packets. If that is not true,
>>> I have no objections.
>>
>> Hmm, you're right but user using non-ethernet packets can upgrade to
>> NFLOG ;)
>
> I assume thats not meant seriously :) But we should integrate
> new features into the new things, not break old things and
> expect users to upgrade :)

Well, we still have a problem here:
 * ULOG logs raw hardware header
 * NFLOG logs source hardware address only
 * SQL output module only support real MAC address (at least for PGSQL which
 has a dedicated type)

I'm not able to find a clean and easy way to fix this.

Here's some possible solutions:
 * Modify mac type in database to support everything:
  * Performance impact
  * Different datatypes in same field :(
 * NFLOG modification to log full hardware header:
  * Will revert to a non parsable field :(
 * ULOG header parsing:
  * Incomplete and untrustable by design
  * May be able to retrieve source HW address info in most cases
  * ULOG could output fields raw.mac and raw.mac.saddr to ensure
  compatibility with older applications

IMHO last solution is the less worst one. If it seems ok for you, I will
provide a patchset implementing this solution.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh8nNQACgkQnxA7CdMWjzLs2ACfUMk18oShBTH4xxxObu5DnFZB
al4AniaDHnJYRbOlJhSqGiFWKqluvIzH
=XZB8
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
