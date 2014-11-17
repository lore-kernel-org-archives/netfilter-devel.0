From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC] bridge: fix netfilter/NF_BR_LOCAL_OUT for own,
 locally generated queries
Date: Mon, 17 Nov 2014 12:42:27 +0100
Message-ID: <20141117114227.GA7148@salvia>
References: <1416223228-8411-1-git-send-email-linus.luessing@c0d3.blue>
 <1416223228-8411-2-git-send-email-linus.luessing@c0d3.blue>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@web.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41696 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaKQLk1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:40:27 -0500
Content-Disposition: inline
In-Reply-To: <1416223228-8411-2-git-send-email-linus.luessing@c0d3.blue>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 17, 2014 at 12:20:28PM +0100, Linus L=C3=BCssing wrote:
> From: Linus L=C3=BCssing <linus.luessing@web.de>
>=20
> Ebtables on the OUTPUT chain (NF_BR_LOCAL_OUT) would not work as expe=
cted
> for both locally generated IGMP and MLD queries. The IP header specif=
ic
> filter options are off by 14 Bytes for netfilter (actual output on
> interfaces is fine).
>=20
> NF_HOOK()=E2=80=AFexpects the skb->data to point to the IP header, no=
t the
> ethernet one (while dev_queue_xmit()=E2=80=AFdoes not). Luckily there=
 is an
> br_dev_queue_push_xmit() helper function already - let's just use tha=
t.
>=20
> Introduced by eb1d16414339a6e113d89e2cca2556005d7ce919
> ("bridge: Add core IGMP snooping support")
>=20
> Ebtables example:
>=20
> $ ebtables -I OUTPUT -p IPv6 -o eth1 --logical-out br0 \
> 	--log --log-level 6 --log-ip6 --log-prefix=3D"~EBT: " -j DROP
>=20
> before (broken):
>=20
> ~EBT:  IN=3D OUT=3Deth1 MAC source =3D 02:04:64:a4:39:c2 \
> 	MAC dest =3D 33:33:00:00:00:01 proto =3D 0x86dd IPv6 \
> 	SRC=3D64a4:39c2:86dd:6000:0000:0020:0001:fe80 IPv6 \
> 	DST=3D0000:0000:0000:0004:64ff:fea4:39c2:ff02, \
> 	IPv6 priority=3D0x3, Next Header=3D2
>=20
> after (working):
>=20
> ~EBT:  IN=3D OUT=3Deth1 MAC source =3D 02:04:64:a4:39:c2 \
> 	MAC dest =3D 33:33:00:00:00:01 proto =3D 0x86dd IPv6 \
> 	SRC=3Dfe80:0000:0000:0000:0004:64ff:fea4:39c2 IPv6 \
> 	DST=3Dff02:0000:0000:0000:0000:0000:0000:0001, \
> 	IPv6 priority=3D0x0, Next Header=3D0

Applied, thanks Linus.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
