Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68A7EB64DC
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 11:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjFTLPI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 07:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjFTLOv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 07:14:51 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14967B2
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2023 04:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=U6zzAbDVpCse4T9Vw4qXQ7NOTHyzocIEhpckOw+ahTI=; b=J5IkR4koLuuDHHDWt85vVRyyIU
        1vQ7J6Hlc37KRbewV+vNydTWdN9s45nxgZ1WQJmWpP95lDLrA/fUOcdf6YngcawnLXGMrZqeDuOcm
        QYl11CyS4zQqch5J4GT4hG1W0QhNSD12ZwYBslpLZWUBJT8pPkmoE0V3c8gotx1nQ9R2WWe36RoAB
        JLzQDm4Uuti+JT2EjjQncsuK0CJGDD/FJyFzYlxxv9REaxjfOj5n2A4IBKakw0RyFQRHB+U1DtXXA
        Pm8FE6tTCZgX7gIlyVA9j1YM0ZCUwL8FR5AJ1acSRmIB2/eHCNHxO0w4yHY777NVp4YH8tDYkpK8k
        9FyHQsQw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=azazel.net)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qBZJw-0094JJ-2U
        for netfilter-devel@vger.kernel.org;
        Tue, 20 Jun 2023 12:14:48 +0100
Date:   Tue, 20 Jun 2023 12:14:47 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] lib/ts_bm: add helper to reduce indentation and
 improve readability
Message-ID: <20230620111447.GE82872@azazel.net>
References: <20230619190803.1906012-1-jeremy@azazel.net>
 <202306201819.BoQ5IT7Y-lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KgQf1w82oH8c1QVn"
Content-Disposition: inline
In-Reply-To: <202306201819.BoQ5IT7Y-lkp@intel.com>
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--KgQf1w82oH8c1QVn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-06-20, at 18:42:43 +0800, kernel test robot wrote:
> kernel test robot noticed the following build warnings:
>=20
> [auto build test WARNING on linus/master]
> [also build test WARNING on v6.4-rc7 next-20230620]
> [cannot apply to nf-next/master]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Jeremy-Sowden/lib-=
ts_bm-add-helper-to-reduce-indentation-and-improve-readability/20230620-031=
043
> base:   linus/master
> patch link:    https://lore.kernel.org/r/20230619190803.1906012-1-jeremy%=
40azazel.net
> patch subject: [PATCH nf-next] lib/ts_bm: add helper to reduce indentatio=
n and improve readability
> config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/202=
30620/202306201819.BoQ5IT7Y-lkp@intel.com/config)
> compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git =
8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
> reproduce: (https://download.01.org/0day-ci/archive/20230620/202306201819=
=2EBoQ5IT7Y-lkp@intel.com/reproduce)
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202306201819.BoQ5IT7Y-lkp=
@intel.com/
>=20
> All warnings (new ones prefixed by >>):
>=20
> >> lib/ts_bm.c:101:34: warning: variable 'i' is uninitialized when used h=
ere [-Wuninitialized]
>                            bs =3D bm->bad_shift[text[shift-i]];
>                                                          ^
>    lib/ts_bm.c:79:16: note: initialize the variable 'i' to silence this w=
arning
>            unsigned int i, text_len, consumed =3D state->offset;
>                          ^
>                           =3D 0
>    1 warning generated.

Whoops.  Will fix and send v2.

J.

--KgQf1w82oH8c1QVn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmSRiiEACgkQKYasCr3x
BA0bnQ/8CIy2qRRZAgmIhhfiSO8mP9craoaT8f9D6q+U98LCgY+87a+2E/CEZB+l
OVs2R3+Gplu+r7E6m7GcdDrCFtrJGl7CV6jNzsP8niy9Huvacl2M3qYWSoeggbai
5yMuEEQvXDtEmhvpy0M66W3FhLOjN5+H9m6TgMBq+zarMQx7Gkter4PMGDhCHHah
kr1/0Savzj3vJZfEJjpx9pRf5D9R0bPswcOWnNXIZiSzlUaG+2tOw8YJNwRdKlKW
NceGi2Y8p8YcHkMeByKnCyiZqP1hivB9lh3V8s9irft7b8nTDtIKHR0xkQ1uRgUc
Nf/BK03YzJV9/JcA5mguEe8cZZHioJ2lUWGxsaYcG7mjujeMw7H9rB0dMNsxxo/p
S1dXlp4fTY2E/JgNB/H4WhhWDPurAUobCzg6uKoTsI2wBoCxDlcTqItqmmcCcn9W
tXnJQj1SsK2Zs4/sSTIIvb7VttCnfZ0vEd8qj2nN0MZoQQxdBJvchGBwAlRR9xfR
Q7BcssQgPjdOqSwPbS7ssIDSve+SbNBcPm3qNHbyWdQ+Zf2gRYXKAzRrgKr5n5kZ
LFURKTedQ6WLuoVNyIYGiXVX/yNYqsje3dJqAd2/c1A+7ixchFEZLkV6dumfVfOB
Y/dV7lhuKkiVlmUJIJ4qM7QiMjjbd2Di9IXiiSZQlbpn3MI2a9E=
=W72M
-----END PGP SIGNATURE-----

--KgQf1w82oH8c1QVn--
