Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300A2C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 02:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiDECjr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 22:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiDECjc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 22:39:32 -0400
X-Greylist: delayed 271 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Apr 2022 18:41:24 PDT
Received: from mout.web.de (mout.web.de [212.227.15.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996D126C578
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 18:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1649122882;
        bh=7jWT2QXUEfY7nbtv9KcAIt3vmvoiDwiU/MOmFaVreVI=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=avDZeigFGs43umOZ5DX3GtuyShXW0M0bw5HoS9NvaT8FuuwFCV2vfb4g66X8ByBn6
         9I+TGfg7E0xrCBfzDOc0YBd23vegE33EPqsTsocwc2HNW18mdeAKbnleSs5qiPzQXu
         pAfXo5WE399VAh7UrbR6vYKswOnbfaLeZkA0oU8A=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko ([46.223.151.228]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MIL4K-1nprhO37DA-00EmJv for
 <netfilter-devel@vger.kernel.org>; Tue, 05 Apr 2022 03:17:14 +0200
Date:   Tue, 5 Apr 2022 01:17:05 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     netfilter-devel@vger.kernel.org
Subject: meta time broken
Message-ID: <20220405011705.1257ac40@gecko>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/pzGoRbn=tu5QAVpiP43OxzZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:g2oct619LoT53ZFO6hajfNIFbb5YTZx7vmeIhgKqezACr0kq48Y
 f53xJoisnGsLBqibqKtAdwxlKFFvHpCkCqD5k7Xyg2Y+cYfxfdn0GhN0F/3IPtmfQ6qyG3E
 fSeWL1egAzJFgOXSz+Rr4mq4FVxZiOvTgoiVvamUjzYWPlhzfTL0IVfgXbtXBlEkQaOI3Yv
 tojdlsi2OFOF45ky8toJw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:r0EPVHDVreE=:/nYbkIP46XbtQmTEzILD1C
 JLUt9vi6aYkYCSz73MASngF2DgfLC4FarxbPfHdn7boeWbkErda8O048RDieVIIjx3kyiSEli
 YsVhMZ23OCVrFbawHECEvERWYFCkuiSIaX8kKUSyh+GOqj980y1bNEVOoq1pttI1QGFki+OxZ
 lPqpz5OtiYbGa2t2ZfAEr36seomgGNv/YTBbPKHojv28eahSX5rTzGUtNpzikKbYqcnHLkxvX
 v7t9UfC+03oY19ISXoEvARmWLg5V4qFXd+gNUMKsKxDh9IsPM+IpOuGi/TbPCdmoEm7PYeLxF
 gumWjK/kDBd/cv6SAFZ2Ircz77LbkTltaeiZ/wAFT/W2JjxhL265Bi37Csl8dilFlOOKy3atE
 JiIgVa3zxX0xOIkyVsRov6H506QJaZWmf1Pn2EoAaTjFH9X8krPuELpZJh938mtD/aavQE75C
 7O78C6/E95Er63BZFaAMfq72BYXw2twvU8zz9yd9EJBMpL2zSSAkrjiVyDvUzk/N3BKJVGeEi
 fmDV0CcoQKmvbyfKwodRYxp4R8pgLZ2h00jEXIrU/JrIKYpbRN3nuWyXfOIDfAWBhriyDf95a
 clUVHYhOC3HCWw3+u5q2MguXdkNm6U/sM8cPaSNX5NF4MzLCzKIeouWFjbXVAv+LC/6KSCJ5s
 SGNxfypEnltVIhY4hc91W/sr5EhB7lhNAyPyae9GDyReuk6wPSWl9p+xX9CRiLwg83hVEoayH
 0a1lE17Tf4Mt1eSP3r3YunqOXKgvR2hL67ih4UGvWoRgG6AekHGNyw/9r8W+9lYgcjHBGuZqh
 b41CJjwQAWjM3dXnxXDJOhuJxrMv02pDgcTlwP126nnNj0UIN0y4kJmWeZmj8UUdXJojMcoz0
 2nvuukFIbXeWWPUSJDAzbOzFm8DL8a8UG2cfK6U59CVlfJYWS/4MNn8h0Wn4f+8ZnEB0k9sBm
 BmDSsf6cKqVNEbP/olXCDYrtesx5Vu3MO03pXZAU7KGrNI/2c6cRTFNz4MeRgc6K39KqbKIs5
 t9yMhAi4n2Z/M9ZXSNmlk9Kp3cRGWum0PIgP8WkWOsTHLpv/MC1EG8lbwABlYzNs4dNt0Q+Zg
 hahaPTKcBiYYGM=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/pzGoRbn=tu5QAVpiP43OxzZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello Everyone,
I want to set up a rule that matches as long as the current time (/time
of packet reception) is smaller than a given unix timestamp. However
the whole "meta time" expression seems to be broken. I can't get it to
work with either a unix timestamp or iso time. What's weird is that
after setting the rule and listing it again, it will always display a
date around 1970 instead of whatever was entered.

Reproducer:
nft "add chain inet filter prg_policy; flush chain inet filter prg_policy; =
add rule inet filter prg_policy meta time < $(date --date=3D'now + 2 hours'=
 '+%s') accept"
nft list chain inet filter prg_policy

Reproducer 2:
nft "add chain inet filter prg_policy; flush chain inet filter prg_policy; =
add rule inet filter prg_policy meta time \"2022-04-01 01:00\" - \"2022-04-=
10 01:00\" accept"
nft list chain inet filter prg_policy

nftables v1.0.2 (Lester Gooch)
Linux usbrouter 5.10.0-13-armmp #1 SMP Debian 5.10.106-1 (2022-03-17) armv7=
l GNU/Linux

Regards,
Lukas Straub

--=20


--Sig_/pzGoRbn=tu5QAVpiP43OxzZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmJLmJEACgkQNasLKJxd
slhl3A/+KNbmBu73eKv94OyA8IGh9YpqIgo7IqMqM9kvUgFyvKHhHxmtPcIWzcYi
7QN9pAc2ihxv56AUbU9ODEI9Vt/iey3CiWf7mG0fp6lbMZkYFTnAevXBLB0Txdxq
K4oiMkCMgk+67GBG0tXlhWxbViSUMCfkj0Gteq7FH+p06PYKK41Wqip+1+zHecYn
z96p+7hGZhhD9hLvQDu3YH9dubcHOhY7QZdvk/U6hMqookLSf4BsxPf/tsqBhELj
OxeQnE6lLewKRlfb1S4oYVgdHHYlY8eSomgkP8fenIhm5ixpaE0qJ6iAVVRss9bH
I0iaY4uZY8dSmV0xihTnoS3eaTNAEl69nYTYdBD3xXtZlqmzIQ53eYlF0N/7lmpp
UwtHphmPINPIajn+CbGwqF3v2aZy9ZPzEsSCyLVQcGeW2o3QKXpItmHVTwWinMlM
ZCad3GR9P1ZkeXAFU5RD/N+rq0LkWNL96TTA6jz4PHbsENKPRGoNDZ/RvqhZfrUk
ECTGizVQPJJyuaXeBTftOBPD6+8etXvTFVBfX4sb0no4bjxhwtABkUbnqGRfGchB
TfPti0Ygq2N79ey4c4D6yNcI+BjCp/npU81gZq7WaMo+IPo/fmb2aDE/2IhwhfzE
opS9HJiRdllXONk75+iPWRLIQtxaytFmBzG7cGQoyTYXmat+I6o=
=smn0
-----END PGP SIGNATURE-----

--Sig_/pzGoRbn=tu5QAVpiP43OxzZ--
