From: Arif Hossain <freefall1986@gmail.com>
Subject: How to get notified if packets are dropped because of checksum
 mismatch error
Date: Fri, 16 Mar 2012 18:18:00 +0600
Message-ID: <1331900280.4147.15.camel@arifLaptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ANOmd0vkFsJ0qtCTRVoQ"
To: netfilter <netfilter@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47768 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761740Ab2CPMSL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:18:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-ANOmd0vkFsJ0qtCTRVoQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

I have a netfilter_queue app which de-obfuscates a already obfuscated
udp packets. de-obfuscation process ends successfully but somehow packet
is not reaching to the udp daemon. i'm suspecting this is happening
because of a udp checksum mismatch. so i'm wondering how can i get logs
of packets which are dropped because of udp checksum mismatch?

I'm receiving the packets ok in my netfilter_queue app. and when i issue
set_nfq_verdict() it also returns a positive value. problem is packet is
not delivered to the udp daemon i'm expecting. i've straced my
netfilter_queue app. it shows that it issues a sendmsg() to the udp
socket which is listening for this. I've also straced my  udp daemon.
its stuck in poll() for receiving udp packet. but it does not return
from this poll meaning that something is wrong. packet is lost in
oblivion after set_nfq_verdict(). how can i debug it?

i've heard linux by default dropps a packet if it does not have correct
checksum if checksum is present, this behavior can be modified by
recompiling the kernel. using a custom kernel is not in our agenda.

my platform :
Linux <hostname> 2.6.32-220.7.1.el6.x86_64 #1 SMP Wed Mar 7 00:52:02 GMT
2012 x86_64 x86_64 x86_64 GNU/Linux

--=-ANOmd0vkFsJ0qtCTRVoQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPYy94AAoJEDcRh2vIjPwjVrsH/0NETQjmR4XwyCzClhgCGG4y
PKrnkfrI1+/5PtklqeUet3IbMKw6iza/Eiqixk0b87NnIyffoazGk6dIHaPgFNUU
uIU3uAgflSX49gBStSW+R9oJfzWRK/qQKJ4bSmR0W6aYoMHGGK1+fHhBrghvAQxP
iNFVXgDMvFKEPGnAAjDp2lNSJoV18RXdyj5iOY7YuuTaGIeWOi6B6HOOVw3ctBF5
Yz0Bel159mpT/QKXBRaLFNBa84jx2S8M04MYLgtI3vb8Zu06gZ/+WQjjMDO6zGwa
WWPBBktWdKXn2zyWkVS5shB5VcdwyOeRbglUsDx8JuoKrgezM6Z22lKadtahrSg=
=8FCv
-----END PGP SIGNATURE-----

--=-ANOmd0vkFsJ0qtCTRVoQ--

