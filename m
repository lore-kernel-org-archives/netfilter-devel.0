From: Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Subject: Dynamic IP set support
Date: Sat, 24 Oct 2015 12:48:28 -0400
Message-ID: <562BB65C.9040100@aim.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OJpdIxgvNtdQluJc8189l3p7St9RKtQAN"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from omr-a008e.mx.aol.com ([204.29.186.51]:42082 "EHLO
	omr-a008e.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbbJXQxp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Oct 2015 12:53:45 -0400
Received: from mtaout-aae01.mx.aol.com (mtaout-aae01.mx.aol.com [172.27.1.97])
	by omr-a008e.mx.aol.com (Outbound Mail Relay) with ESMTP id 22E66380009F
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2015 12:48:34 -0400 (EDT)
Received: from [192.168.1.10] (cpe-71-68-67-174.carolina.res.rr.com [71.68.67.174])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mtaout-aae01.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id E48A83800008B
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2015 12:48:33 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OJpdIxgvNtdQluJc8189l3p7St9RKtQAN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I'm interested in knowing since nftables supports sets directly, if
there is any support for dynamic sets much the same way that an iptables
rule can match a packet and add information such as an address or port
to an existing ipset.  How would I do something like this in nftables:

iptables -A FWOUTPUT -m addrtype --dst-type BROADCAST -j SET --add-set
udptracking4 src,src --exist --timeout 40

Thanks,

Brian Vanderburg II


--OJpdIxgvNtdQluJc8189l3p7St9RKtQAN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWK7ZgAAoJEHoXNbfOP+xwjbUP/ij4LoDl2mU/vyl/XQWI25Ua
oZ4M77lgA95kJi43DQcw6OQ/nYypu0XDfrfKRawCIpFUtoux57d95neN5J3ieDLC
8ti7za/dTQY85/x1BWzESdSWV+h/ACGEVgp2uGn6Msc0xM4QW7nuw97Dweg+TT7C
a3nDOhgqFHxfkXAVHsRcSvLiCd5scojz/OQSVRUZq38vKR7woHOCfwpHKxdIoCs3
uFrFr/enwix9vxuC+buqdGzAidLYV5VYMI8raC1WK9PKdutvn7exMHTNb7EN1nH2
UemjDOD+GcDc/O5uJHoXLZ8oeWMGX2Befb9uE7elmUlBANFlcP6trppduJSNd0eA
mvhJu/DR4VNZi7/Yagm8imemG4vPCNIXUxvOo9mv0ol9gmeNDwGXx/UFTnlBHSuW
MvB70AtoCo3CYeoOoxndjfB1f1nffPyWjoVVSYahWoLpL0/wsz5kiYEdGqqzvXFP
GrnOkj/K46kobexzElyDCLYHVQGl5mC9P+PUeND++839tf7aX05QiQUpTN+wZP0O
ESiq2T7jIl2SYzwJg8jwywjoJ1Gu0vsAcTm+QXJtLrqe0yjRMewZVYNsBmdHDhRR
1la1hXEbyx0qQKxC+LvKHv6bOsdh5SVe9/va95UwRCtFcQpeGfBpE6jcB//MVlZo
p3pvZ4j+wD5WEhKuGDEL
=a1iA
-----END PGP SIGNATURE-----

--OJpdIxgvNtdQluJc8189l3p7St9RKtQAN--
