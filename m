Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F110AC10F13
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 01:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4E352084E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 01:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Oamzr4Hg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfDOBk5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Apr 2019 21:40:57 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57607 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfDOBk5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Apr 2019 21:40:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44jB6F4tttz9s4V;
        Mon, 15 Apr 2019 11:40:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555292453;
        bh=kyk5cypsMrdgS7VZVBxwZmC2gR4s38b7p8OKYOEceg8=;
        h=Date:From:To:Cc:Subject:From;
        b=Oamzr4HgmCNIhSiI9rNkXAswcl/uqCemdYSRJQYgjPgA47tz54P36eXn0jyVqdRVn
         7fvAS9/KoByRaL6tv5kv73+eHoc2cJuodJHaf6OQyIel63xlGfskx7nhnP8MfYVtLh
         DVr39TPhqud50eTghwSn+w+4CNjDYZVDI4oL8gK+l/z81rAK5wYT+TSuLQBUd9CoyB
         6KWWOUvlhe9i+ETDfH7Sw8ta3o+VlT46pyuzm/K/pkiS1jQ2iFSBrb21/hcA6z5vvL
         MOlTCHQJ1jS5zgtD+dFWKuymZ0VmSljhW0FHtOvckNZe91BQuHtbJYd764mDMCSxKe
         IkqjbbCtI1Snw==
Date:   Mon, 15 Apr 2019 11:40:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: linux-next: manual merge of the netfilter-next tree with the
 netfiler tree
Message-ID: <20190415114051.50e0fad8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//ljvqTdB5fm.GVlgN/V3pBI"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_//ljvqTdB5fm.GVlgN/V3pBI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the netfilter-next tree got a conflict in:

  tools/testing/selftests/netfilter/nft_nat.sh

between commit:

  51f9960db6ad ("netfilter: nat: fix icmp id randomization")

from the netfiler tree and commit:

  6978cdb129da ("kselftests: extend nft_nat with inet family based nat hook=
s")

from the netfilter-next tree.

I fixed it up (I think, see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/netfilter/nft_nat.sh
index 3194007cf8d1,248905130d5d..000000000000
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@@ -321,7 -346,7 +346,8 @@@ EO
 =20
  test_masquerade6()
  {
 -	local family=3D$1
 +	local natflags=3D$1
++	local family=3D$2
  	local lret=3D0
 =20
  	ip netns exec ns0 sysctl net.ipv6.conf.all.forwarding=3D1 > /dev/null
@@@ -352,16 -377,21 +378,21 @@@
 =20
  # add masquerading rule
  ip netns exec ns0 nft -f - <<EOF
- table ip6 nat {
+ table $family nat {
  	chain postrouting {
  		type nat hook postrouting priority 0; policy accept;
 -		meta oif veth0 masquerade
 +		meta oif veth0 masquerade $natflags
  	}
  }
  EOF
+ 	if [ $? -ne 0 ]; then
+ 		echo "SKIP: Could not add add $family masquerade hook"
+ 		return $ksft_skip
+ 	fi
+=20
  	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
  	if [ $? -ne 0 ] ; then
- 		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natf=
lags"
 -		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerading"
++		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerade $n=
atflags"
  		lret=3D1
  	fi
 =20
@@@ -398,26 -428,20 +429,27 @@@
  		fi
  	done
 =20
 +	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 +	if [ $? -ne 0 ] ; then
- 		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natf=
lags (attempt 2)"
++		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerade $n=
atflags (attempt 2)"
 +		lret=3D1
 +	fi
 +
- 	ip netns exec ns0 nft flush chain ip6 nat postrouting
+ 	ip netns exec ns0 nft flush chain $family nat postrouting
  	if [ $? -ne 0 ]; then
- 		echo "ERROR: Could not flush ip6 nat postrouting" 1>&2
+ 		echo "ERROR: Could not flush $family nat postrouting" 1>&2
  		lret=3D1
  	fi
 =20
- 	test $lret -eq 0 && echo "PASS: IPv6 masquerade $natflags for ns2"
 -	test $lret -eq 0 && echo "PASS: $family IPv6 masquerade for ns2"
++	test $lret -eq 0 && echo "PASS: $family IPv6 masquerade $natflags for ns=
2"
 =20
  	return $lret
  }
 =20
  test_masquerade()
  {
 -	local family=3D$1
 +	local natflags=3D$1
++	local family=3D$2
  	local lret=3D0
 =20
  	ip netns exec ns0 sysctl net.ipv4.conf.veth0.forwarding=3D1 > /dev/null
@@@ -448,16 -472,21 +480,21 @@@
 =20
  # add masquerading rule
  ip netns exec ns0 nft -f - <<EOF
- table ip nat {
+ table $family nat {
  	chain postrouting {
  		type nat hook postrouting priority 0; policy accept;
 -		meta oif veth0 masquerade
 +		meta oif veth0 masquerade $natflags
  	}
  }
  EOF
+ 	if [ $? -ne 0 ]; then
+ 		echo "SKIP: Could not add add $family masquerade hook"
+ 		return $ksft_skip
+ 	fi
+=20
  	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
  	if [ $? -ne 0 ] ; then
- 		echo "ERROR: cannot ping ns1 from ns2 with active ip masquere $natflags"
 -		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerading"
++		echo "ERROR: cannot ping ns1 from ns2 with active $family masquere $nat=
flags"
  		lret=3D1
  	fi
 =20
@@@ -493,19 -522,13 +530,19 @@@
  		fi
  	done
 =20
 +	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 +	if [ $? -ne 0 ] ; then
- 		echo "ERROR: cannot ping ns1 from ns2 with active ip masquerade $natfla=
gs (attempt 2)"
++		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerade $n=
atflags (attempt 2)"
 +		lret=3D1
 +	fi
 +
- 	ip netns exec ns0 nft flush chain ip nat postrouting
+ 	ip netns exec ns0 nft flush chain $family nat postrouting
  	if [ $? -ne 0 ]; then
- 		echo "ERROR: Could not flush nat postrouting" 1>&2
+ 		echo "ERROR: Could not flush $family nat postrouting" 1>&2
  		lret=3D1
  	fi
 =20
- 	test $lret -eq 0 && echo "PASS: IP masquerade $natflags for ns2"
 -	test $lret -eq 0 && echo "PASS: $family IP masquerade for ns2"
++	test $lret -eq 0 && echo "PASS: $family IP masquerade $natflags for ns2"
 =20
  	return $lret
  }
@@@ -760,20 -795,25 +809,34 @@@ if [ $ret -eq 0 ];the
  fi
 =20
  reset_counters
- test_local_dnat
- test_local_dnat6
+ test_local_dnat ip
+ test_local_dnat6 ip6
+ reset_counters
+ $test_inet_nat && test_local_dnat inet
+ $test_inet_nat && test_local_dnat6 inet
+=20
+ reset_counters
 -test_masquerade ip
 -test_masquerade6 ip6
++test_masquerade "" ip
++test_masquerade6 "" ip6
++
++reset_counters
++test_masquerade "fully-random" ip
++test_masquerade6 "fully-random" ip6
 +
 +reset_counters
- test_masquerade ""
- test_masquerade6 ""
++$test_inet_nat && test_masquerade "" inet
++$test_inet_nat && test_masquerade6 "" inet
 +
  reset_counters
- test_masquerade "fully-random"
- test_masquerade6 "fully-random"
 -$test_inet_nat && test_masquerade inet
 -$test_inet_nat && test_masquerade6 inet
++$test_inet_nat && test_masquerade "fully-random" ip
++$test_inet_nat && test_masquerade6 "fully-random" ip6
 =20
  reset_counters
- test_redirect
- test_redirect6
+ test_redirect ip
+ test_redirect6 ip6
+ reset_counters
+ $test_inet_nat && test_redirect inet
+ $test_inet_nat && test_redirect6 inet
 =20
  for i in 0 1 2; do ip netns del ns$i;done
 =20

--Sig_//ljvqTdB5fm.GVlgN/V3pBI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyz4SMACgkQAVBC80lX
0Gxriwf/atWZO+AtZGbi5ncbj+JkzBX3qLaamlgHdlFv+boZRNUeUgUUZaLuipwd
DRnS5EghZdmxF3sPjPORXrNp/OmtW0886qqnWsf/B/mKlD9e9QSjFqQNVtGmfyWU
5llyVNqM2VQ2Mxrv43RvpgGjb3JNS3EDoT2nQPj59GS5akOunxU3T5/d0hHAqbIw
5rgdITfYktTMA8cC8ou3RDG/Qm2mX6YQg2kl1iK9bpjf269MjOO1RvUuE22THpvP
AzOfrvarQMe7C3acK5VrTrlpQxS6eRs5uzCd7H80au+epmhY0QqDVNv5lYSfifSM
1N8benjcRNC5ALxrQvm0Jzkzt2Xwdg==
=8q2a
-----END PGP SIGNATURE-----

--Sig_//ljvqTdB5fm.GVlgN/V3pBI--
