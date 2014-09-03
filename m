From: Kevin Fenzi <kevin@scrye.com>
Subject: nft: crash in describe?
Date: Wed, 3 Sep 2014 14:21:54 -0600
Message-ID: <20140903142154.0a2b32ad@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/zbUhwKtd8RRhCn8XL2_9.px"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from scrye.com ([75.148.32.185]:42561 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbaICUa0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:30:26 -0400
Received: from voldemort.scrye.com (voldemort [10.99.3.2])
	by mail.scrye.com (Postfix) with ESMTP id 712F6658315
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2014 14:21:55 -0600 (MDT)
Received: from voldemort.scrye.com (localhost [IPv6:::1])
	by voldemort.scrye.com (Postfix) with ESMTP id 5BD3524FAC
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2014 14:21:55 -0600 (MDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/zbUhwKtd8RRhCn8XL2_9.px
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Greetings.=20

I'm seeing a crash here in nft:=20

(ask it to describe something like flags, works fine)

% nft describe tcp flags
payload expression, datatype tcp_flag (TCP flag) (basetype bitmask,
integer), 8 bits

pre-defined symbolic constants:
        fin                             0x01
        syn                             0x02
        rst                             0x04
        psh                             0x08
        ack                             0x10
        urg                             0x20
        ecn                             0x40
        cwr                             0x80

(pass anything invalid and boom):

%  nft describe tcp foobar
value expression, datatype inet_proto (Internet protocol) (basetype
integer), 8 bits [1]    2028 segmentation fault (core dumped)  nft
describe tcp foobar

0x0000000000406a84 in handle_free ()
(gdb) where
#0  0x0000000000406a84 in handle_free ()
#1  0x0000000000407822 in cmd_free ()
#2  0x000000000041a3d1 in nft_parse ()
#3  0x0000000000405e40 in nft_run ()
#4  0x0000000000405a98 in main ()

Happy to gather more info if it will help...=20

kevin


--Sig_/zbUhwKtd8RRhCn8XL2_9.px
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJUB3hjAAoJEEs3sNgP+7teSqoQAKy4U+BSTt4KN6qQHHiCfnLY
SYTva4Ky/dAGKiSg4nYTFQ59qOhTeUKeYqBUvDAXoUKqCjU5K2AOol5lbvDCBOZI
sP0d8TvKypxH0DwtLpRi4stHfZImq3TGhjNtM/UNiuJ7kr5+IRLuPzicgdIy+K9G
Dk5ZUeXfjTCAKrAK//+Qgg92c6OPYLTsIgJU36F2FUHmSN0yU3YrXtsPSUpz4tNK
+0cMfUCx2yIEJ8wkGuLyzu5OpvEAWPYc00WWd/dwzAEi0djgJIJgohD7HvEwdyOG
S9rhnS8drXL6IYUnKtmXinGzUhQ86+veGnXgWv4V6T4XpoRhdfo8Edw9V6kBUR/e
YShOvuyUgptQ7a/2QXwT8WA3kdkFebpffli6Z3Ch5H6HCFnk7UE04Hnn51S8lNdx
rHGN/Vt5EjGd81apgKgAp7hpwZast8ykDn6/Flzw/ueO2yS58VMO6d71KEcRwqPF
PiQoIbBIDWvelehOzzs4bzeTnJlwsgw32sAP1HUyEH5uWrPeWdEOr4oB+S04yIgu
feIl1PCTWHzHEt3nuYYy4lauK9FJDNOb+QXVK6FaTlDlVvb9sf9dx5dy4zSf0DMo
w/v/e+loBxCOtRu0OMQF8EncW6t5GhsvfvZGm3E37IYBxeE13bKcknlWQ2QULmUU
h4t7oCZqUwQkOwRBH6Nl
=x/oD
-----END PGP SIGNATURE-----

--Sig_/zbUhwKtd8RRhCn8XL2_9.px--
