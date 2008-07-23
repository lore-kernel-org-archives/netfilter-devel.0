From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD2 PATCH 0/4] Misc cleaning
Date: Wed, 23 Jul 2008 18:27:46 +0200
Message-ID: <20080723162746.GB31572@bayen.regit.org>
References: <1216812835-9851-1-git-send-email-eric@inl.fr> <48873F55.2000706@netfilter.org> <488743AC.4040909@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks301150.kimsufi.com ([91.121.73.151]:45584 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYGWRNo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:13:44 -0400
Content-Disposition: inline
In-Reply-To: <488743AC.4040909@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Wednesday, 2008 July 23 at 16:43:56 +0200, Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Eric Leblond wrote:
>>> The main concern here is about IPFIX which is in really bad shape. I've=
 fix
>>> some major error in one of the patch but it remains untested for now an=
d I
>>> don't think it can work properly.
>>
>> Indeed. It's broken Do you plan to look into this?

No, I've got enough work with other modules ;) I will soon send a
complete a patchset about the hardware header issue.

>> If not, I'll fix it
>> myself. Please, let me know since I don't want to duplicate work. Do you
>> also plan to send me a patch to fix all those warnings?

Yes.

> I think would prefer to enable the warnings that make sense
> individually, -Wextra includes lots if crap like "%s expects
> type char *, but argument is void *" or signedness warnings
> that are compiler-detectable irrelevant 50% of the time.
>
> OTOH a lot of the warnings in the current -git version indicate
> that the code really needs more love, like missing return values
> etc, so it seems we really want *some* of the new warnings.

That's right, I plan to do some warning hunting and code cleaning
when I will have finish my current work.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIh1wCnxA7CdMWjzIRAg0FAJoCMUGb2kdYlqUaCk6Z+ikVaZfx2ACfVuvb
vgCmsA823ayC32jYQHKD7e8=
=29ce
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
