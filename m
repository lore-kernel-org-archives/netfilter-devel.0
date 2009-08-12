From: "Christoph A." <casmls@gmail.com>
Subject: Re: codesize: netfilter/iptables vs. nftables
Date: Wed, 12 Aug 2009 16:32:06 +0200
Message-ID: <4A82D266.8040605@gmail.com>
References: <4A8146C4.5090108@gmail.com> <4A8177CF.6030708@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigA2D0AAF9315BEDB3EE048811"
Cc: Patrick McHardy <kaber@trash.net>,
	"Christoph A." <casmls@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56378 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbZHLOe4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:34:56 -0400
Received: by bwz19 with SMTP id 19so39688bwz.37
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Aug 2009 07:34:56 -0700 (PDT)
In-Reply-To: <4A8177CF.6030708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA2D0AAF9315BEDB3EE048811
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

thanks your replies

On 11.08.2009 15:53, Patrick McHardy wrote:
> but some of that are just API changes touching other files. The
> real code size currently is roughly 7300 lines I would guess, the
> number of files is somewhere around 25.

at the end I would like to now how many loc has the netfilter/iptables
subsystem(*)  (of a iptables-only kernel) and how many  loc has the
netfilter/nftables(**) subsystem (of a nftables-only kernel) (rawly)

*includes: {ip,ip6,eb,x}tables

**includes: nftables

I hope this is reasonable.

On 11.08.2009 18:53, Jan Engelhardt wrote:
> Hence I counted by
>
> 	net/{bridge,ipv4,ipv6,}/netfilter/*tables.c
> 	net/{bridge,ipv4,ipv6}/netfilter/*table_{filter,raw,security,mangle}.c=



is it ok to add net/netfilter/x_tables.c to this list?

>
> Something like that. iptables clocks in at some 9 kLOC IIRC (~5k
> after my large consolidation), and nftables somewhere at 2.5k, but
> that's only because I have not yet started trimming down ebtables.


ok, here my second attempt:

for the iptables part I used a vanilla 31rc4
http://git.kernel.org/?p=3Dlinux/kernel/git/kaber/nft-2.6.git;a=3Dcommit;=
h=3D4be3bd7849165e7efa6b0b35a23d6a3598d97465

cp
{bridge,ipv4,ipv6}/netfilter/*table{s,_filter,_raw,_security,_mangle}.c
 netfilter/x_tables.c /tmp/31rc4/

ls /tmp/31rc4/|wc -l
15

sloccount /tmp/31rc4/
Creating filelist for 31rc4
Computing results.

SLOC=09
8834  <=3D=3D


for nftables I used
http://git.kernel.org/?p=3Dlinux/kernel/git/kaber/nft-2.6.git;a=3Dcommit;=
h=3Da80c1f56e68fd0a7a57a82c85ff50a96a4e38267

find . -name 'nf_table*' -exec cp -i {} /tmp/nftables/ \;
find . -name 'nft_*' -exec cp -i {} /tmp/nftables/ \;
ls /tmp/nftables|wc -l
25  (conforming to the number mentioned by Patrick)

sloccount  /tmp/nftables
Creating filelist for nftables
Computing results.

SLOC
4697	<=3D=3D


at the end it comes to:
8834 LOC vs. 4697 LOC


for sure this is another flawed comparison but hopefully a better one
than the previous ;)

thanks
Christoph A.


just for the record:

ls /tmp/31rc4/
arptable_filter.c  ebtable_filter.c  ip6table_filter.c  ip6table_raw.c
ip6table_security.c  iptable_mangle.c  ip_tables.c         x_tables.c
arp_tables.c       ebtables.c        ip6table_mangle.c  ip6_tables.c
iptable_filter.c     iptable_raw.c     iptable_security.c

ls /tmp/nftables
nf_table_nat_ipv4.c    nf_tables_bridge.c  nft_bitwise.c    nft_ct.c
         nft_immediate.c  nft_meta.c         nft_reject_ipv4.c
nf_table_route_ipv4.c  nf_tables_core.c    nft_byteorder.c
nft_expr_template.c  nft_limit.c      nft_meta_target.c
nf_table_route_ipv6.c  nf_tables_ipv4.c    nft_cmp.c        nft_exthdr.c
        nft_log.c        nft_payload.c
nf_tables_api.c        nf_tables_ipv6.c    nft_counter.c    nft_hash.c
         nft_lookup.c     nft_rbtree.c



--------------enigA2D0AAF9315BEDB3EE048811
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkqC0msACgkQrq+riTAIEg2Y3QCfdofVNHyZjsuTna1m+IaLqlw1
UrIAoJTyAT6vJVkR5VYC+ydfuta/iVFY
=BAKJ
-----END PGP SIGNATURE-----

--------------enigA2D0AAF9315BEDB3EE048811--
