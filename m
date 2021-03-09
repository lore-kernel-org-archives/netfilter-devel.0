Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4C2C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 10:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A14B065266
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 10:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhCIKr5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 05:47:57 -0500
Received: from zucker.schokokeks.org ([178.63.68.96]:58217 "EHLO
        zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCIKrk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 05:47:40 -0500
Received: from localhost (localhost [::1])
  (AUTH: PLAIN simon@ruderich.org, TLS: TLSv1.3,256bits,TLS_AES_256_GCM_SHA384)
  by zucker.schokokeks.org with ESMTPSA
  id 00000000000000EE.000000006047524B.0000754B; Tue, 09 Mar 2021 11:47:39 +0100
Date:   Tue, 9 Mar 2021 11:47:39 +0100
From:   Simon Ruderich <simon@ruderich.org>
To:     Frank Myhr <fmyhr@fhmtech.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC PATCH] doc: use symbolic names for chain priorities
Message-ID: <YEdSS3PRMF7WURDl@ruderich.org>
References: <b1320180e5617ae9910848b7fc17daf9c3edca04.1615109258.git.simon@ruderich.org>
 <0a7f088c-f813-0425-8bec-d693d95a97a0@fhmtech.com>
 <YEW34W5oCspFnSt+@ruderich.org>
 <ced3e003-45c4-a39a-62a6-0e2f4e2abc47@fhmtech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512; protocol="application/pgp-signature"; boundary="=_zucker.schokokeks.org-30027-1615286859-0001-2"
Content-Disposition: inline
In-Reply-To: <ced3e003-45c4-a39a-62a6-0e2f4e2abc47@fhmtech.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_zucker.schokokeks.org-30027-1615286859-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 08, 2021 at 04:46:34AM -0500, Frank Myhr wrote:
> I'm glad. If you have suggestions for how to make the wiki clearer I'd lo=
ve
> to hear them. (Probably better to use the regular netfilter list, where
> developers are also present, rather than this netfilter-devel list.)

Hello Frank,

I'm not sure what exactly tripped me up (or is still confusing
me). I think it's mainly that the concepts of hooks (prerouting,
postrouting, etc.), chain types (filter, nat, etc.) and netfilter
hook priority was never really spelled out in a way that all the
pieces fit together (for me). The fact that the order of
priorities is not directly related to hooks made it worse (I
didn't realize that the priorities only order entries for a
single hook).

>> Wouldn't it also work to set for example
>> NF_IP_PRI_NAT_SRC to -400 because it only applies in postrouting
>> anyway?
>
> Just to be clear, NF_IP_PRI_NAT_SRC is a named constant in the netfilter
> codebase. So not something you can change unless you edit the source code
> and compile it yourself. But you could create a base chain using "hook
> postrouting priority -400" and add rules with "snat to" statements to said
> chain, and this will happily snat your packets as you specify. Whether th=
is
> overall config does what you want, depends on what else is hooked to
> postrouting, and their relative priorities. For example:
>
> * Conntrack is almost always used. Using -400 for snat doesn't change its
> relative order to NF_IP_PRI_CONNTRACK_HELPER and NF_IP_PRI_CONNTRACK_CONF=
IRM
> (both of which are also at postrouting hook).
>
> * If you are also mangling packets (in ways other than snat) at postrouti=
ng,
> NF_IP_PRI_MANGLE =3D -150. By moving your snat from usual 100 to -400, yo=
u've
> re-ordered the mangle and snat processes -- unless you also use a
> nonstandard priority for your base chain that does mangling.
>
> * There's also NF_IP_PRI_SECURITY, maybe important if you're using SELINU=
X.

Thank you. That made it clearer for me.

> General point: you should have a good reason for using priorities other t=
han
> the traditional ones.

Of course.

>> What exactly is the difference between the chain types? Is it
>> relevant for netfilter or is it only for nftables so it knows
>> which rules to expect in the given chain?
>
> I think you mean?:
> https://wiki.nftables.org/wiki-nftables/index.php/Nftables_families

No. I was talking about the chain types:
https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains#Base_c=
hain_types

And I'm curious what's the difference in regard to netfilter
between these types. They are all added to the same netfilter
hook (e.g. prerouting can use filter, nat, etc. chains). Does
netfilter see any difference or is this just relevant to
nftables?

Regards
Simon
--=20
+ privacy is necessary
+ using gnupg http://gnupg.org
+ public key id: 0x92FEFDB7E44C32F9

--=_zucker.schokokeks.org-30027-1615286859-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEO7rfWMMObpFkF3n0kv79t+RMMvkFAmBHUj0ACgkQkv79t+RM
MvmQ7w//QeNyYInwbOSNxUc9wOfblpKQiFzxZokWI8kQxRimKqQ6Wte4QtrtyvfY
754HQGHOjUPDqY2CbjpWqADDg+Eao0zEyGzFQrr006khcXXzVrt7ydPbBR1/HaCb
y3XppWAn/Z9ZOJ2sUNssZ5ETp8HzCG50+X9JiMZrMB+vl9cL8Exf9Z3grRJ8ASiZ
QZd62Ff03ZjViDULexxbNv8bf2j8P6P2dsWvKRBVmim6umR5jL1VtRm/SCQeOCoM
wVlSa8wbBadX2c8jyPaX3/eR8OBugP8qCoElfJfLKKFJVvHm4It9502vK4XkBtBn
7BOWncc/w3vSRprEvI44xq6OvKq+VQpP9ht4Hx2ZaymQ/ToLu5Ub9pQ6qu8OHDSF
PLNEE6MtgT9f2k6xA/67G8tO+6hzaXsBjL5kX3jZQjkgGn+cfdhY1Sx7NkfRGumc
cvOoxoncOuUyJUgaofhWaE5eCRtKWXONAb4D4zAmdhjB8fhVon4xEGk/LyyPjp6Y
SpQ1K+uUxx8Vf/QVgTspk3bQySf005wSpHgH5nHpb0IENkdGtpOHltAsI5OMDd2H
n5uqI47Sak5KJEc3EZZWpnJnUqkzuyeJjVemmUB/zrc40bVkp6J7lIc9D2G61xqK
c8dnU4I0G01sB8pEb7TzAG43joyxerJs/Z6ZIUgT70hLt3irhCg=
=m6Pa
-----END PGP SIGNATURE-----

--=_zucker.schokokeks.org-30027-1615286859-0001-2--
