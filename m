From: "Christoph A." <casmls@gmail.com>
Subject: Re: nftables: NULL pointer dereference
Date: Fri, 24 Jul 2009 01:48:13 +0200
Message-ID: <4A68F6BD.8060709@gmail.com>
References: <4A6856E6.9030600@trash.net> <4A687BD0.1030906@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigB0A1797C6D7581093E80E87C"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	"Christoph A." <casmls@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:59698 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbZGWXuV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2009 19:50:21 -0400
Received: by fg-out-1718.google.com with SMTP id e21so360072fga.17
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2009 16:50:19 -0700 (PDT)
In-Reply-To: <4A687BD0.1030906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB0A1797C6D7581093E80E87C
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable


Patrick McHardy wrote:
>> Christoph A. wrote:
>>> when executing the testscript [1] (just to see if my nftables setup i=
s
>>> working), I get the following stack trace.
>>>
>>> [1] http://article.gmane.org/gmane.linux.network/122512
>>>
>>> I'm using the latest version from:
>>> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nft-2.6.git
>>> kernel config is attached
>>>
>>> BUG: unable to handle kernel NULL pointer dereference at 00000014
>>>  IP: [<f8b471ff>] nft_validate_data_load+0x20/0x53 [nf_tables]
>> Thanks for the report. This is likely happening because the kernel
>> includes support for some changes for which I haven't pushed out the
>> corresponding userspace support yet, but it certainly shouldn't oops.
>> I'll look into it ...
>=20
> I've added and pushed out this patch to fix it, thanks.

Thank you very much for providing a fix that fast!

Now I executed my first small nftables script successfully.

With some other scripts I got segmentation faults but I will report that
in a new thread.

thanks!
Christoph A.


--------------enigB0A1797C6D7581093E80E87C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkpo9sIACgkQrq+riTAIEg1qGwCgjPMVZTTo7/Dopjn1yTyLW/pL
lhAAnjXXB8W5si09vucQsr1VnfpJF0nZ
=akvt
-----END PGP SIGNATURE-----

--------------enigB0A1797C6D7581093E80E87C--
