From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH] rework, fill MAC address in ULOG for ethernet.
Date: Wed, 9 Jul 2008 23:04:56 +0200
Message-ID: <20080709210454.GA4461@ghlodit.inl.fr>
References: <486B88F4.7060704@trash.net> <1215554219-13763-1-git-send-email-eric@inl.fr> <487497F4.8070004@netfilter.org> <48749899.7070505@trash.net> <48749AF1.60900@netfilter.org> <48749CAA.3030306@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:59816 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140AbYGIVFE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:05:04 -0400
Content-Disposition: inline
In-Reply-To: <48749CAA.3030306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

On Wednesday, 2008 July  9 at 13:10:34 +0200, Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> Pablo Neira Ayuso wrote:
>>>> +            ret[ULOG_KEY_OOB_PROTOCOL].u.value.ui16 = 0;
>>>> +            ret[ULOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
>>>> +            return ULOGD_IRET_OK;
>>> This appears to be breaking logging for anything but ethernet
>>> packets. We can't do that, especially since ulogd1 has long
>>> been in maintenance-only mode.
>>
>> Hm, this patch applies to ulogd2, probably you got confused with the
>> subject?
>
> Indeed, I mixed that up.
>
>> But indeed, I agree with you. Eric, I think that it's better to drop any
>> effort in trying to add layer 2 support for ulogd2 if the user use ULOG
>> as input logger. If users want new features, eg. the layer 2 information
>> in their log messages, they should upgrade to NFLOG.
>
> Agreed, I really don't see how this can be done without breaking
> things. The necessary information is not present in the ULOG
> messages.

I think the proposed patch is a best effort work. It should be enough
for most users as ethernet headers are the more common. But I agree, we
can't have a full working solution with ULOG.

I will try to find some time to rework my NFLOG patch to see if it is
possible to cleanly send the source and destination hardware address to
userspace via NFLOG.

IMHO, this patch is not harmfull and will help some people. It may worth
to be push in the git tree.

BR,
--
Eric Leblond

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIdSf2nxA7CdMWjzIRAqO5AJ99annWzsR6rhXVcTSSMS120Zin9ACgjTuW
HM1R0TmQVCMdjaLorfcI8aY=
=78iB
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
