Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60480C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Oct 2021 12:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CB49610A8
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Oct 2021 12:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbhJFMNE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Oct 2021 08:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbhJFMND (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Oct 2021 08:13:03 -0400
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEC9C061749
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Oct 2021 05:11:11 -0700 (PDT)
Received: from [IPv6:2a02:8106:1:6800:644:959e:952f:424a] (unknown [IPv6:2a02:8106:1:6800:644:959e:952f:424a])
        by dehost.average.org (Postfix) with ESMTPSA id CF50238EA9F3;
        Wed,  6 Oct 2021 14:11:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1633522266; bh=OyuWZLglLaXQxFdkeH+YRZAUbz0vv847ODcnBeCjPEw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AQmHCUyRU5M2Ls0mjKj2omgihz0WCulzaqpMHwCaH0cuHtLHRnuuAjvRiYUG/0xln
         MsvWe9NYiLhRCrhBTZeuDUEJp5+UXWZy4OsMmN+6N6Vg6EtKzkNrJnXQX0uQjZGsjx
         2Eu7Zeeq+Jg7rVA76HdiNZjFDGbHIeefDZ3FHZIU=
Subject: Re: In raw prerouting, `iif` matches different interfaces in
 different kernels when enslaved in a vrf
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <17326577-1ab7-aaaa-0911-13ee131bdee0@average.org>
 <20211002185036.GJ2935@breakpoint.cc>
From:   Eugene Crosser <crosser@average.org>
Message-ID: <dc693a0b-cb3f-877e-1352-cfeb97f2f092@average.org>
Date:   Wed, 6 Oct 2021 14:11:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211002185036.GJ2935@breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cb2RhxhM3PRk4smvQm6IKQinl7A6LFWt5"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cb2RhxhM3PRk4smvQm6IKQinl7A6LFWt5
Content-Type: multipart/mixed; boundary="bJSAKIh6X6klJ64zYze1f2HwWeycX0AxJ";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Message-ID: <dc693a0b-cb3f-877e-1352-cfeb97f2f092@average.org>
Subject: Re: In raw prerouting, `iif` matches different interfaces in
 different kernels when enslaved in a vrf
References: <17326577-1ab7-aaaa-0911-13ee131bdee0@average.org>
 <20211002185036.GJ2935@breakpoint.cc>
In-Reply-To: <20211002185036.GJ2935@breakpoint.cc>

--bJSAKIh6X6klJ64zYze1f2HwWeycX0AxJ
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hello Florian,



On 02/10/2021 20:50, Florian Westphal wrote:



 > Eugene Crosser <crosser@average.org> wrote:

 >> Is this a known situation? Which behavior is "correct"?

 >

 > No idea, your reproducer gives this on my laptop:

 >

 >  unshare -n bash repro.sh

 > net.ipv4.conf.veout.accept_local =3D 1

 > 5.14.9-200.fc34.x86_64

 > conntrack v1.4.5 (conntrack-tools): connection tracking table has=20
been emptied.

 > PING 172.30.30.2 (172.30.30.2) from 172.30.30.1 vein: 56(84) bytes of =

data.

 >

 > --- 172.30.30.2 ping statistics ---

 > 1 packets transmitted, 0 received, 100% packet loss, time 0ms

 >

 > conntrack v1.4.5 (conntrack-tools): 0 flow entries have been shown.



It would seem that you have an existing filter that drops packets and=20
prevents creation of conntrack entries? I can reproduce the behaviour on =

freshly installed Debian and Ubuntu VMs without any modifications, with=20
and without `unshare`.



 >

 > A bisection is needed to figure out what introduced a change.

 >

 > However, if this is already changeed for a few releases then we can't

 > revert it again.



I think that behaviour change is not benign though. If you have several=20
interfaces enslaved in one VRF, (which is a normal configuration), you=20
can no longer create rules that depend on the specific interface from=20
which the packet arrived.



So far I was able to prove that it depends on the kernel version and=20
nothing else. I've installed debian bullseye on a fresh VM, and upgraded =

it to debian sid. The VM now has two kernels: 5.10.0-8 and 5.14.0-2=20
(debian builds). When booted with the older kernel, my reproducer shows=20
"correct" behaviour (rule matches the original veth), when booted with=20
the newer kernel, behaviour is altered (rule matches VRF instead).



I also updated the reproducer to write nftrace, and it looks=20
"interesting". I am including the new reproducer below, and I can send=20
nftrace files if needed.



Now I am trying to bisect upstream kernel.



Thanks.



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



#!/bin/sh



IPIN=3D172.30.30.1

IPOUT=3D172.30.30.2

PFXL=3D30



ip li sh vein >/dev/null 2>&1 && ip li del vein

ip li sh tvrf >/dev/null 2>&1 && ip li del tvrf

nft list table testct >/dev/null 2>&1 && nft delete table testct



ip li add vein type veth peer veout

ip li add tvrf type vrf table 9876

ip li set veout master tvrf

ip li set vein up

ip li set veout up

ip li set tvrf up

/sbin/sysctl -w net.ipv4.conf.veout.accept_local=3D1

ip addr add $IPIN/$PFXL dev vein

ip addr add $IPOUT/$PFXL dev veout



nft -f - <<__END__

table testct {

	chain rawpre {

		type filter hook prerouting priority raw;

		iif { veout, tvrf } meta nftrace set 1

		iif veout ct zone set 1 return

		iif tvrf ct zone set 2 return

		notrack

	}

	chain rawout {

		type filter hook output priority raw;

		notrack

	}

}

__END__



uname -rv

conntrack -F

stdbuf -o0 nft monitor trace >nftrace.`uname -r`.txt &

monpid=3D$!

ping -W 1 -c 1 -I vein $IPOUT

conntrack -L

sleep 1

kill -15 $monpid

wait
=3D=3D=3D=3D=3D=3D=3D=3D


--bJSAKIh6X6klJ64zYze1f2HwWeycX0AxJ--

--cb2RhxhM3PRk4smvQm6IKQinl7A6LFWt5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmFdklQACgkQfKQHw5Gd
RYz2xwf/er9uz6v/PCvWJDcyALQPOdJQcwZlI8/j2BR3hKj1c53K0Q3bv38khqMw
qxK+/8r471q0N3GlG/WpLc29PR4259eVjyTPZ7yB2jej1FqFofA0bHSq9lElYk3j
497xaKBKdVGlII5CnyUcrZhjunhds1M2xHXgqctQ58sIJAL6O8jDUa/vrhb5HXR1
vOtM6vXVY5wgvZOX400XVYALV9KsCJ8rHd1akzUbYxqKD9KTleRD9/y6B+9fvpk4
KzWid470pCK/BTXiqExW1m7CHqhEQMrUJp6AU+/4xh30XHBVXWY9r9onu5Er43sw
i3NgyHSmMowHQ6dh4i9gfnupYTS8QA==
=rulY
-----END PGP SIGNATURE-----

--cb2RhxhM3PRk4smvQm6IKQinl7A6LFWt5--
