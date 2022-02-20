Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBE6C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Feb 2022 13:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiBTNK7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Feb 2022 08:10:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiBTNK6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Feb 2022 08:10:58 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901704ECD8
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Feb 2022 05:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pnANegpXG+voO89BNg7r+6qX6Uv5GkdsveSLbc+qoEw=; b=OIsEaOk4p9Okv3PS06WRc/eTcN
        aVRtIkpppvCcxCdm1KBqudX0vLcyKn2s+wygn9ZgwnWHK8wC1pfOZ6PPganayRdIEXl3R/Fgq4fwb
        CI9R8qmuv+khKpDJpTBVxlXD/zO29AtxVcrxDtHJ3RlZSkvd7I3zRXUWifsJ02YuPRbrIsTnQIbRE
        u7XHWSkVFHeLJw1oMGQqR20jpQW3mpGuOBiseuXZ2+ErI5fP0ODArsGeJDmWwo7d0gwEcWl9yvzZI
        7hzprZnZM+dhXs5WQW/nBMviOVLnClG4nAi4vf/19r5NB8IaPcbTefI2+H6g6+Tn7WkRmzsoKOKe1
        G4j7zmfw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nLlz0-00A8HF-7h; Sun, 20 Feb 2022 13:10:34 +0000
Date:   Sun, 20 Feb 2022 13:10:29 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [iptables PATCH 2/4] tests: add `NOMATCH` test result
Message-ID: <YhI9xcXbHhjkc+ya@ulthar.dreamlands>
References: <20220212165832.2452695-1-jeremy@azazel.net>
 <20220212165832.2452695-3-jeremy@azazel.net>
 <YgooaU4M6ju9++Cy@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iO0qgNPX2KzgqlFU"
Content-Disposition: inline
In-Reply-To: <YgooaU4M6ju9++Cy@orbyte.nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--iO0qgNPX2KzgqlFU
Content-Type: multipart/mixed; boundary="BRcjVxCWkv1Eu0/Y"
Content-Disposition: inline


--BRcjVxCWkv1Eu0/Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-02-14, at 11:01:13 +0100, Phil Sutter wrote:
> On Sat, Feb 12, 2022 at 04:58:30PM +0000, Jeremy Sowden wrote:
> > Currently, there are two supported test results: `OK` and `FAIL`.
> > It is expected that either the iptables command fails, or it
> > succeeds and dumping the rule has the correct output.  However, it
> > is possible that the command may succeed but the output may not be
> > correct.  Add a `NOMATCH` result to cover this outcome.
>
> Hmm. Wouldn't it make sense to extend the scope of LEGACY/NFT keywords
> to output checks as well instead of introducing a new one? I think we
> could cover expected output that way by duplicating the test case with
> different expected output instead of marking it as unspecific "may
> produce garbage".

Something like the following?  One reason why I went with the `NOMATCH`
result is that in the two divergent test-cases, there is no -nft output
to match.  We can make that work by just using the empty string as the
alternative output since that will match anything.  I don't think it's
ideal, but it's simpler than overhauling the matching code for what is a
rare corner case.

J.

--BRcjVxCWkv1Eu0/Y
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="v2-0001-tests-specify-non-matching-output-instead-of-NOMA.patch"
Content-Transfer-Encoding: quoted-printable

=46rom a18fa07425f82d71a46846e4f3656ec65155fd0c Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Sun, 20 Feb 2022 12:49:23 +0000
Subject: [iptables PATCH v2] tests: specify non-matching output instead of
 `NOMATCH` test result

Recently, we introduced a new test result `NOMATCH` to cover the case
where the test succeeds for both -legacy and -nft, but the two variants
do not have the same output.  This patch does away with the new result
in favour of specifying the alternative output.  For example, instead of

  -j EXAMPLE-TARGET --example-option;=3D;OK;LEGACY;NOMATCH

which specifies that the test passes for -legacy with the output
matching the rule, but for -nft it passes with output which does not
match the rule, we specify the test as:

  -j EXAMPLE-TARGET --example-option;=3D;OK;LEGACY;-j EXAMPLE-TARGET --nft-=
option

which specifies that the test passes for -legacy with the output
matching the rule, but for -nft it passes with the different output
given in the last field.

In the case of tests which have no output to match, we leave the last
field empty:

  -j EXAMPLE-TARGET --example-option;=3D;OK;LEGACY;

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.t |  4 ++--
 iptables-test.py         | 50 ++++++++++++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/extensions/libxt_NFLOG.t b/extensions/libxt_NFLOG.t
index 25f332ae16b6..b3241f51b153 100644
--- a/extensions/libxt_NFLOG.t
+++ b/extensions/libxt_NFLOG.t
@@ -5,8 +5,8 @@
 -j NFLOG --nflog-group 0;-j NFLOG;OK
 # `--nflog-range` is broken and only supported by xtables-legacy.
 # It has been superseded by `--nflog--group`.
--j NFLOG --nflog-range 1;=3D;OK;LEGACY;NOMATCH
--j NFLOG --nflog-range 4294967295;=3D;OK;LEGACY;NOMATCH
+-j NFLOG --nflog-range 1;=3D;OK;LEGACY;
+-j NFLOG --nflog-range 4294967295;=3D;OK;LEGACY;
 -j NFLOG --nflog-range 4294967296;;FAIL
 -j NFLOG --nflog-range -1;;FAIL
 -j NFLOG --nflog-size 0;=3D;OK
diff --git a/iptables-test.py b/iptables-test.py
index 6acaa82228fa..763e5b449ca5 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -192,17 +192,18 @@ def execute_cmd(cmd, filename, lineno):
     return ret
=20
=20
-def variant_res(res, variant, alt_res=3DNone):
+def variant_res(res, variant, alt_rule_save):
     '''
     Adjust expected result with given variant
=20
     If expected result is scoped to a variant, the other one yields a diff=
erent
-    result. Therefore map @res to itself if given variant is current, use =
the
-    alternate result, @alt_res, if specified, invert @res otherwise.
+    result or different output. Therefore map @res to itself if given vari=
ant is
+    current, use "OK" if the expected result is "OK" but the other variant=
 yields
+    different output, invert @res otherwise.
=20
-    :param res: expected result from test spec ("OK", "FAIL" or "NOMATCH")
+    :param res: expected result from test spec ("OK" or "FAIL")
     :param variant: variant @res is scoped to by test spec ("NFT" or "LEGA=
CY")
-    :param alt_res: optional expected result for the alternate variant.
+    :param alt_rule_save: alternative output if the variants have differen=
t output
     '''
     variant_executable =3D {
         "NFT": "xtables-nft-multi",
@@ -210,17 +211,40 @@ def variant_res(res, variant, alt_res=3DNone):
     }
     res_inverse =3D {
         "OK": "FAIL",
-        "FAIL": "OK",
-        "NOMATCH": "OK"
+        "FAIL": "OK"
     }
=20
     if variant_executable[variant] =3D=3D EXECUTABLE:
         return res
-    if alt_res is not None:
-        return alt_res
+    if res =3D=3D "OK" and alt_rule_save is not None:
+        return res
     return res_inverse[res]
=20
=20
+def variant_rule_save(rule_save, variant, alt_rule_save):
+    '''
+    Adjust expected output with given variant
+
+    If expected output is scoped to a variant, the other one yields differ=
ent
+    output. Therefore map @rule_save to itself if given variant is current=
, use the
+    alternate output, @alt_rule_save otherwise.
+
+    :param rule_save: expected output if variant matches test spec
+    :param variant: variant given in test spec
+    :param alt_rule_save: expected output if the variant does not match the
+                          test spec
+    '''
+    variant_executable =3D {
+        "NFT": "xtables-nft-multi",
+        "LEGACY": "xtables-legacy-multi"
+    }
+
+    if variant_executable[variant] =3D=3D EXECUTABLE:
+        return rule_save
+    else:
+        return alt_rule_save
+
+
 def run_test_file(filename, netns):
     '''
     Runs a test file
@@ -317,10 +341,12 @@ def run_test_file(filename, netns):
             if len(item) > 3:
                 variant =3D item[3].rstrip()
                 if len(item) > 4:
-                    alt_res =3D item[4].rstrip()
+                    alt_rule_save =3D item[4].rstrip()
                 else:
-                    alt_res =3D None
-                res =3D variant_res(res, variant, alt_res)
+                    alt_rule_save =3D None
+
+                res =3D variant_res(res, variant, alt_rule_save)
+                rule_save =3D variant_rule_save(rule_save, variant, alt_ru=
le_save)
=20
             ret =3D run_test(iptables, rule, rule_save,
                            res, filename, lineno + 1, netns)
--=20
2.34.1


--BRcjVxCWkv1Eu0/Y--

--iO0qgNPX2KzgqlFU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmISPb4ACgkQKYasCr3x
BA2dlg/8CjAuFivnvSjAQ8QhcG6xFsqBFeyyVgzHdYTE1a1q1z7bmMSnqj9J/+p1
koRs+Pa9tjUcn86DpL0kl/w4G0vWwx9VgtJnXf8IKwg9MaoEKWPK8+rJ4lLPgpsa
f7gKHPPrZ5SwhBk+h9rhDfHzKUgqdj9bkPOQ1D6Dhky/aLa4OwlIaBZ2QGtnHsox
MVqkwQt4J70CTyw7GpfzZJxpL2Im3WmB5GCK6AV81dQYk1xBZBTtJ9U+8iEfaDEX
sLExxx5j7ASNbnppvL9KRWtOnL1ZKHuZWp79eX5CleziYfavO/4Ax1SeAIMsHd+i
5TVcxz4YbLhtu8gSp5rk/mLK+VDyrTyYXjX1pcp2AAxJ9sckcrvy8y4woZjRMeSq
ciB6qMIyAUti6j2jiXgA4pRpzK8D5HOgBm3vBqxvU50GqbqXCntCQwCCDAucBBBa
HyjH4MF2ye53yMgy8Z06jhVS2/aQkLotq40wV1Aghhw73irSBflbp3+8pwLn3v4e
+a9iQgACTpAtnT7h7eoLQ5NeAx1ZcuZoHxKPSfKBd0KWKlascGJAQHYtq2Co9gWC
WvLcYWzq0eFZAsy+o2kwMtpQUEkCKmHWHcbJQcxoNk/eya1MTDJNoQ4LBEBR/VEz
xF22VqgHcdw9m1vJJa0mTikIs7VQxkpvXDYUMskd3YKKDjp/ORE=
=riMC
-----END PGP SIGNATURE-----

--iO0qgNPX2KzgqlFU--
