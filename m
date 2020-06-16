Return-Path: <SRS0=UdzR=75=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C90C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jun 2020 14:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8BA620644
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jun 2020 14:56:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=average.org header.i=@average.org header.b="JESsNejn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgFPO4J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jun 2020 10:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729588AbgFPO4G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jun 2020 10:56:06 -0400
X-Greylist: delayed 425 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 Jun 2020 07:56:05 PDT
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11BFC061573
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2020 07:56:05 -0700 (PDT)
Received: from [IPv6:2a02:247f:ffff:2548:9a90:96ff:fea0:e2f] (unknown [IPv6:2001:1438:4010:2548:9a90:96ff:fea0:e2f])
        by dehost.average.org (Postfix) with ESMTPSA id F3BB6354608B
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2020 16:48:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1592318935; bh=ATjczuyMKTnCuebKX4CSxtt4bhqLpPv7xqvO6iY4bQs=;
        h=To:From:Subject:Date:From;
        b=JESsNejnaWj6ewf79iLVQwbHCYqOKczk70HCHARTtCNbu3ljrErG3mjDB5EJ0VFrZ
         ruCnksmkXPE2MGFiYdbWGF3A91BhT2JBiDe1qBE7/WDS8LuCDEpOlH7LtDNXfXIM78
         35CYUhVhZJZCzbMUE8p2tpuL9bGBlJ25tfhfrbN8=
To:     netfilter-devel@vger.kernel.org
From:   Eugene Crosser <crosser@average.org>
Subject: ebtables: load-on-demand extensions
Autocrypt: addr=crosser@average.org; prefer-encrypt=mutual; keydata=
 mQIFBFWr0boBD8DHz6SDQBf1hxHqMHAqOp4RbT0J4X0IonpicOxNErbLRrqpkiEvJbujWM7V
 5bd/TwppgFL3EkQIm6HCByZZJ9ZfH6m6I3tf+IfvZM1tmnqPL7HwGqwOHXZ2RVbJ/JA2jB5m
 wEa9gBcVtD9HuLVSwPOW8TTosexi7tDIcR9JgxMs45/f7Gy5ceZ/qJWJwrP3eeC3oaunXXou
 dHjVj7fl1sdVnhXz5kzaegcrl67aYMNGv071HyFx14X4/pmIScDue4xsGWQ79iNpkvwdp9CP
 rkTOH+Lj/iBz26X5WYszSsGRe/b9V6Bmxg7ZoiliRw+OaZe9EOAVosf5vDIpszkekHipF8Dy
 J0gBO9SPwWHQfaufkCvM4lc2RQDY7sEXyU4HrZcxI39P+CTqYmvbVngqXxMkIPIBVjR3P+HL
 peYqDDnZ9+4MfiNuNizD25ViqzruxOIFnk69sylZbPfYbMY9Jgi21YOJ01CboU4tB7PB+s1i
 aQN0fc1lvG6E5qnYOQF8nJCM6OHeM6LKvWwZVaknMNyHNLHPZ2+1FY2iiVTd2YGc3Ysk8BNH
 V0+WUnGpJR9g0rcxcvJhQKj3p/aZxUHMSxuukuRYPrS0E0HgvduY0FiD5oeQMeozUxXsCHen
 zf5ju8PQQuPv/9z4ktEl/TAqe7VtC6mHkWKvz8cAEQEAAbQ4RXVnZW5lIENyb3NzZXIgKEV2
 Z2VueSBDaGVya2FzaGluKSA8Y3Jvc3NlckBhdmVyYWdlLm9yZz6JAkkEEwEIADsCGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4ACGQEWIQTVPoXvPtQ2x3jd1a6pBBBxAPzFlQUCWvR9CQAK
 CRCpBBBxAPzFlbeED74/OErA7ePerptYfk09H/TGdep8o4vTU8v8NyxctoDIWmSh0Frb+D3L
 4+gmkPEgOIKoxXCTBd6beQOLyi0D4lspBJif7WSplnMJQ9eHNc7yV6kwi+JtKYK3ulCVGuFB
 jJ7BfQ1tey1CCY38o8QZ8HJOZHpXxYuHf0VRalwrYiEONJwhWNT56WRaBMl8fT77yhVWrJme
 W58Z3bPWD6xbuOWOuEfKpxMyh4aGTirXXLI+Um69m6aRvpUzh7gTHyfB/Ye0hwlemiWREDZo
 O1kKCq3stNarzckjMRVS0eNeoHMWR15vR3S/0I4w7IAHMQcb489rRC6odD88eybCI7KftRLy
 nvjeMuUFEVne9NZZGGG6alvoC9O8Dak/7FokJ00RW/Pg79MSk7bKmGsqqWXynHKqnWMzrIay
 eolaqrssBKXr2ys4mjh0qLDPTO5kWqsbCbi3YVY7Eyzee0vneFSX1TkA+pUNqHudu8kZmh9N
 Q+c/FEHJDC6KzvjnuKPu0W724tjPRpeI9lLXUVjEFDrLrORD7uppY0FGEQFNyu9E4sd2kEBn
 cvkC01OPxbLy07AHIa3EJR/9DIrmlN1VBT1Sxg52UehCzQga4Ym/Wd0fjID1zT+8/rhFD/9q
 RowXrrpK7lkcY0A1qY6JNBVpyYefH43IrzDaJe0izT65AQ0EVavXagEIAMlmFDUdDw45GMAQ
 neDdPbsIr71noyPwZbIO3CkmhBdMFU7HeSClyHfBEGLXb1JrZQb0qa/vL8wsDv3WOGgqUm+3
 wwQd37HV9B1LyuKxjfgjKlxqW/6OrkEdqqL30oFXVbyzDkPNilLBu9hL6RvwVZM7jCLz9Sue
 1aUUu1nx2HHq6AalOP7w8xanVdlnWKSypnqVU8Tuz/+EQlLm7OSkomzwVp0K9qqxq9Y8d6m1
 oMz37s5Ja492cZWawrJuuU74/RKIXyQwQA3gTaemwxIcIWGN1sno7gTm9YRJB/ad6ikMG3XI
 i8QGgJkEWouFKPX0KGY9Kb/ntr5kRm+AbL5rtgkAEQEAAYkDNgQYAQgACQUCVavXagIbAgEp
 CRCpBBBxAPzFlcBdIAQZAQgABgUCVavXagAKCRB8pAfDkZ1FjOY0B/9DMKCWC7qGxDJ4QZJF
 V0aYA2YFJl3wVs14Y5ubFfDKc5O+MAL53NJz5EfdX/SE0yjBg23xiD1ur4QNiectW/kQ9/Iv
 VFftZzn+Yk2FGnVJJrjhWb5PAfdS0Yae+SqcnI2qSYdANwQ3frfiXKevW7CBS8lWBfsujW7P
 8eAvh0HTc8gfpktnuyKhuEJ0Y2tIahpxihUmIJwq1KXauz99q5VAiTzlyNlGbhxsXf2ric2v
 1ju8wKJt/v18oBSDtM6yBtbyPPGIAOFFrwRm0TXk2bZ5LErPb57kyV1cnhn1HaZD7mwO137v
 7BTlw5tB4Hz+vySM/sTXtJdT+FcQNSeGgHybnMMPv0gysndYZVrViCb1uCjnwj7ESmJ+eQ1Y
 xUnlQzckrNlnfrbn66amR6yz0edQ/DC5vGBqROqn9IRhVXtWk2pMf49D60uyQUyTXlW+k2eN
 V4jhLd2SfCwikPxM+KrlaXKE80OB1u8w/cXzCYDI7teLM+fh6iqq+mQKYlpiObRxv1oLBuIo
 DtorKJF8z0o0g1PNbc4Fjy86ymYFhF/jyrkiO8st2sR8PykcvIOUemJ0tvmQm2auMOj3RSHN
 NU0rvU8pDwwYq9oQulGkeApjM8a1MXV0hWQd2lQbQzxu82x9BhcHwt/OOV2gQpVM4UmBcQkY
 Q0CVhsf043flUugqRGuAeb6cQFi+u0CA1GF3EMjHA9Hq2d1L74Mf3C41JK7Bu2ZeTxBwtZgq
 sBmQwsv1Q0vyHhuDbuPjov0kiDywbVlc92AvE10Z0bZeZQvh68FoO9wOSSVCZAUFIBvuv8tk
 tgvLpDQugeNjZqjBxj9GLLHKu7hNAsZ7SOc3xgngKCbc+8QVT7Lefr+ACiEpcx+65EMzNjVA
 oxLh7Qitw3iUppUr7HMuCEu0E+836pErUfR9uCkTzEY4U5rjih3KHIPVWuxlJQjeHLAzo2N8
 i2noLO+wnpDzROUTrVOXGD3bzveOCpxO0q63O1SuRFlTI8yoYzmM9ncIXvt488WCPrkBDQRV
 q9gPAQgAyYZ0HIjIx8AXxS/nAa13FaC72mLvQq+kQyhPC2dAhRfMtbcKITP/qHkB93rYMhUo
 9SQw7J55Ex4s7iZMJbfQ6gxO8HGzaUUKFbb5wj481Hyzv7eH7W3Y/LLpFvCfKm3cDU8bQ7IX
 AsookmxAAUAvfeE3dSG/toNrtQy9Xaro/Q8hRat+AxO8PuivMvexmYDA9Vx+vMwVpyszqkKF
 E7vOwH9WLNNfJf2NshBBr8uQSoom2c9NI/hUmRpzerurIFRRBq0wj4OHokrOy9jMO7RRrDAV
 NCyJu3fZ7CQBrat3/uJT4FvArFw3PYw+WkAhycAt0fVu7geRqJm04OUg4JQNmQARAQABiQIX
 BBgBCAAJBQJVq9gPAhsMAAoJEKkEEHEA/MWVmWcPwIdMvS0//TQZKFvNlKZaeyWpRgWu/O/r
 fG+7s6kRrUpB6dE7qWKdVijy1wx07G2xZMtJhhf+/xiKZFsc4Ay+93iqEpNg4dz/WVyA9euA
 Q1tC06Qib3WRkZoNK6BEkoHUwx6dtnuz7nvDs4kjOzFdMWTft6aBz2qhvPHJS+mnwG9N1mbf
 JqHBebwzXsoJU8hKSMkeBz7sYEjbBCHkXMjyUm/ATH7zpP74/DQs0EOEz7R0vZr7VQzR5aSN
 cjhML7P6VqAKVcLKP9W05dkW8vIpP08/iQK6qXFrnsNQRPVr8FUcndU2XpmZxYAPj0DVWCNk
 MR4nzrtmIqPhhAh4y8WbiVzUIY6O/+AADmous7BcpoeYW8matyzi/JcdVDGiEvlsOyKJZqcq
 /XxJbdZc1yL47IfFc/zpMQhc7Ai07N6gTJhi/gIpPnQvY9kjOooBsynoAgNqBsB+lX5Y1ESd
 95loICq/RipNY/OrEd16TtZLGgQnzV/LQyxicNfIugiE0Zc1rRTXUXBi0VZLZL/H2QnduMIH
 u2rEhf8hzTT5DeRhZ144q/6byP4XtRHD2mAJg0ThF+9by9Q2poVj+SwxJEeIZV2Hvty42nnG
 VPLk/DuQLZ9BjRa8Si1zWnNk6ZLXGIrqmXKHlFhRhSZw6hIufGJQVrGCEnKro4blzQ==
Message-ID: <76cd59a3-6403-9408-1b8c-af5f11d5fa85@average.org>
Date:   Tue, 16 Jun 2020 16:48:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="V8lyJKxHNeuZ3UNzWBkbw8XJvXFxUjnsc"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--V8lyJKxHNeuZ3UNzWBkbw8XJvXFxUjnsc
Content-Type: multipart/mixed; boundary="uZm2ObVABlAGgRCwbMqsrNE27ZSq1j8rg";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: netfilter-devel@vger.kernel.org
Message-ID: <76cd59a3-6403-9408-1b8c-af5f11d5fa85@average.org>
Subject: ebtables: load-on-demand extensions

--uZm2ObVABlAGgRCwbMqsrNE27ZSq1j8rg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hello all,

we need a custom "extention" module working on Layer 2 (nfproto "bridge"
or "netdev"). Making a kernel module and an xtables "extention" shared
object is simple enough. But then it gets more complicated.

In order to make an "extention" work on Layer 3 (with command
`iptables`) it is sufficient to place the shared object in the directory
with other existing extensions (/usr/lib/x86_64-linux-gnu/xtables in a
typical linux distro), and then existing `iptables` command will load it
on demand if it was specified as a "match extension" option `-m` or used
as a jump target. (Existing third party tools such as iptables-netflow
use this approach).

However such "load on demand" mechanism does not exist for Layer 2
(`ebtables` command). Instead, `ebtables` has a hardcoded list of
extensions that are all loaded at startup time (iptables/xtables-eb.c,
function `ebt_load_match_extensions()`). This makes the use of in-house
extensions impossible without rolling out a modified version of
`ebtables` command.

Questions:

1. Is my analysis correct, and it is not possible to use existing
netfilter control tools to configure and enable custom extensions on
layer 2?

2. Is it correct that "new generation" `nft` filtering infrastructure
does not support dynamically loadable extensions at all? (We need a
custom kernel module because we need access to the fields in the skb
that are not exposed to `nft`, and we need a custom extension to
configure the custom module.)

3. If modification to `ebtables` is indeed inevitable, and we make such
modification to allow on demand loading the same way as in `iptables`,
would upstream be interested to incorporate such patch for some future
relase?

Thank you,

Eugene


--uZm2ObVABlAGgRCwbMqsrNE27ZSq1j8rg--

--V8lyJKxHNeuZ3UNzWBkbw8XJvXFxUjnsc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAl7o29IACgkQfKQHw5Gd
RYwGMwf+LZt6zGJjX7LjGYgNHkJhpDeE4j2TxZ7FYOQhlW1TorvtOrNjJA98jgqd
X7dQ1OJ1cZk8/EfkcuOn46Nw4n2B6BvoG6J+u7ZKY9g/zLfnPpaMzcgyEMBCkB8d
kIBUhjMqXRPdzRCB+I8DHCkratbk2wDzewKrm7F8soc/Jb7SsRS14e1NtYmEfHc4
x+gt2xz5in6IOzjMRNrI2BWsQoxPkRNAIXaExMPMb3N0txjvpRkMKrupyiQH7qdL
KzsT8wocEwvkQb1Z7VqxFwbtBrscmQZV3o1dEFdfC4hE5DmQp8N7Ij6fW7O3Jk1Z
j0aYLMfCZiN4cekixw/QOy6k8FkKeQ==
=07Ee
-----END PGP SIGNATURE-----

--V8lyJKxHNeuZ3UNzWBkbw8XJvXFxUjnsc--
