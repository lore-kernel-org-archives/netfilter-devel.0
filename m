From: "Christoph A." <casmls@gmail.com>
Subject: codesize: netfilter/iptables vs. nftables
Date: Tue, 11 Aug 2009 12:24:04 +0200
Message-ID: <4A8146C4.5090108@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig1E3D6C9511EF925DE72B99C9"
Cc: "Christoph A." <casmls@gmail.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:37728 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZHKMUM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:20:12 -0400
Received: by yxe5 with SMTP id 5so4610989yxe.33
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2009 05:20:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1E3D6C9511EF925DE72B99C9
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

from my understanding of the initial announcement of nftables [1]

unlike the iptables kernel approach, nftables does not have a 1-to-1
mapping of matches with modules in the kernel and provides only basic
functionality/operations, userspace can use to combine to build
matches/rules. (intelligence moves from kernel to userspace)

[1]
http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/289=
22

When creating new matches/targets in iptables one must create the
appropriate ipt/xt_<match> module for the kernel plus the userspace
module  libipt/libxt_<match>.

With the generic way in which a nftables kernel handles data / provides
functions I would assume that this approach of supporting new matches
would change, and one must only create new combinations of kernel
provided operations which does not require kernel code modifications.
The kernelcode size of nftables would be constant regardless of how many
matches it supports.
Is this assumption correct?

Another thing I would like to know is the current codesize of
netfilter/iptables (including ip6tables and ebtables modules) compared
to nftables kernelsize (sloc) (although the current featureset may defer)=



I compared them like this:

1. step:
count lines with sloccount in the following directories:
net/ipv4/netfilter/
net/ipv6/netfilter/
net/bridge/netfilter/
net/netfilter/

(gives me 802 files and 62462 SLOC)

2. step:
count lines in the same directories but only including files starting
with nft_*

(62 files and 2288 SLOC)

3. step:
subtraction:
sloc_step1
sloc_step2
(62462 - 2288 =3D 60174)

netfilter/iptables: 60174 SLOC
only nft_ files: 2288 SLOC
(using nft-2.6 87f619abc27c38583abbf7268319c3f105bf09fd)

this is only correct if nftables does not depend on any code already
present in non nft_* files and I guess this is not correct...(?)

thanks in advance
Christoph A.


--------------enig1E3D6C9511EF925DE72B99C9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkqBRskACgkQrq+riTAIEg2a7wCg6eJxKfWX1wMmk2HZ9TToAZjF
AJkAoOmuzhm7o0Mu3HzEcz/cJ/9ECZHA
=W9Uf
-----END PGP SIGNATURE-----

--------------enig1E3D6C9511EF925DE72B99C9--
