Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE28C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 15:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F0CA61A57
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 15:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355073AbhJAPXP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 11:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbhJAPVW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 11:21:22 -0400
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57932C061775
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 08:19:38 -0700 (PDT)
Received: from [IPV6:2a02:8106:1:6800:8c50:594a:2c4b:80a8] (unknown [IPv6:2a02:8106:1:6800:8c50:594a:2c4b:80a8])
        by dehost.average.org (Postfix) with ESMTPSA id 2012738E613D
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 17:19:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1633101574; bh=EYaygZJQLxqMR78mRyh2cTS0GrVPj86f90RaUpHNHjs=;
        h=Date:To:From:Subject:From;
        b=lyyUgJW7ZQDbQje5/ZbCiT/TIoEjOzW8P5JU93sqPlJPwUPN4M0pdMWILKimtLxEJ
         82TqIsuOo7MGCiDVJi8c3ryv6C88uUujzwXHjsCOYfz8z48ywouL25UXcDybQfC41t
         qmSWFl4kJz0v/oj3KVWbbqzVjG3z7YYzcz0rQ2GI=
Message-ID: <17326577-1ab7-aaaa-0911-13ee131bdee0@average.org>
Date:   Fri, 1 Oct 2021 17:19:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
To:     netfilter-devel@vger.kernel.org
Content-Language: en-US
From:   Eugene Crosser <crosser@average.org>
Subject: In raw prerouting, `iif` matches different interfaces in different
 kernels when enslaved in a vrf
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------2yQ9rTG5vTcfwMmij0Y3t3ke"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------2yQ9rTG5vTcfwMmij0Y3t3ke
Content-Type: multipart/mixed; boundary="------------FUitBToDMoQDH1IhUs50td1O";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: netfilter-devel@vger.kernel.org
Message-ID: <17326577-1ab7-aaaa-0911-13ee131bdee0@average.org>
Subject: In raw prerouting, `iif` matches different interfaces in different
 kernels when enslaved in a vrf

--------------FUitBToDMoQDH1IhUs50td1O
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

When the interface against which you match in the "raw prerouting" is ens=
laved
in a VRF matching is different in the kernel 5.4 and kernels 5.10 and lat=
er (I
have no systems to check kernels in between).

On 5.4, veth interface is matched and zone is set accordingly, then vrf
interface is matched again, rule is executed, according to trace, but onc=
e set
zone does not change.

On 5.10 and later, the rule that should match veth interface _does not ap=
pear in
the trace_, despite trace shows the veth as the `iif` at that moment. The=
n the
rule that matches vrf interface is executed, and corresponding zone is se=
t.

Reproducer script creates a veth pair with one end enslaved in a vrf, and=
 sends
a packet to the unenslaved end of the veth. In the prerouting chain, ther=
e are
rules that set different conntrack zone depending on which iif matched - =
veth or
vrf. As a result, entries are created in different zones when the script =
runs on
earlier and on later kernels. Here are the results (observe different zon=
es),
and the script is below.

=3D=3D=3D=3D=3D=3D=3D=3D
5.4.86-pserver
conntrack v1.4.5 (conntrack-tools): connection tracking table has been em=
ptied.
PING 172.30.30.2 (172.30.30.2) from 172.30.30.1 vein: 56(84) bytes of dat=
a.
64 bytes from 172.30.30.2: icmp_seq=3D1 ttl=3D64 time=3D0.128 ms

--- 172.30.30.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev =3D 0.128/0.128/0.128/0.000 ms
icmp     1 30 src=3D172.30.30.1 dst=3D172.30.30.2 type=3D8 code=3D0 id=3D=
13818 [UNREPLIED]
src=3D172.30.30.2 dst=3D172.30.30.1 type=3D0 code=3D0 id=3D13818 mark=3D0=
 zone=3D1 use=3D1
conntrack v1.4.5 (conntrack-tools): 1 flow entries have been shown.

=3D=3D=3D=3D=3D=3D=3D=3D
5.13.0-16-generic
conntrack v1.4.6 (conntrack-tools): connection tracking table has been em=
ptied.
PING 172.30.30.2 (172.30.30.2) from 172.30.30.1 vein: 56(84) bytes of dat=
a.
64 bytes from 172.30.30.2: icmp_seq=3D1 ttl=3D64 time=3D0.117 ms

--- 172.30.30.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev =3D 0.117/0.117/0.117/0.000 ms
icmp     1 30 src=3D172.30.30.1 dst=3D172.30.30.2 type=3D8 code=3D0 id=3D=
104 [UNREPLIED]
src=3D172.30.30.2 dst=3D172.30.30.1 type=3D0 code=3D0 id=3D104 mark=3D0 z=
one=3D2 use=3D1
conntrack v1.4.6 (conntrack-tools): 1 flow entries have been shown.

=3D=3D=3D=3D=3D=3D=3D=3D
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
sysctl -w net.ipv4.conf.veout.accept_local=3D1
ip addr add $IPIN/$PFXL dev vein
ip addr add $IPOUT/$PFXL dev veout

nft -f - <<__END__
table testct {
	chain rawpre {
		type filter hook prerouting priority raw;
	#	iif { veout, tvrf } meta nftrace set 1
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

uname -r
conntrack -F
ping -W 1 -c 1 -I vein $IPOUT
conntrack -L

=3D=3D=3D=3D=3D=3D=3D=3D

Is this a known situation? Which behavior is "correct"?

Thank you,

Eugene

--------------FUitBToDMoQDH1IhUs50td1O--

--------------2yQ9rTG5vTcfwMmij0Y3t3ke
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmFXJvwACgkQfKQHw5Gd
RYz0UQf/cz51CXeyB9RJrdIQUVIxuydmD1vDaNpgIU0OYW8abvvv6nn9pTyjgTet
Rk79gXwWsEPUueP1m4wJIrSA0QfxqjD5JMUa8X3qrm7WLUa1Edl0wUzxh2CuhuDD
wPJn0NmzNIXV21i3Ob51cS2KiNs68YJ6WnEAiYFGBfwxarCh6TsRAZNfw9i2l+wX
7g97v/pA+5FIt+syhKo1n8gkIQd2kLEgyFORSZRzdSeX0Efkv5eopXsgCtgJw3HX
u3fr412lZrqk/9BPTjUJovn2tuatoEpaOgc0aelXk4l9QjVc/i1a/x1s/eDt8i78
EX7/r4CvEovLCs4Y5c/RNKtzJq1GwQ==
=vJ99
-----END PGP SIGNATURE-----

--------------2yQ9rTG5vTcfwMmij0Y3t3ke--
