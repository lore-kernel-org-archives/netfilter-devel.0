From: David Binderman <dcb314@hotmail.com>
Subject: ip_set_hash_netnet.c:62: possible typo ?
Date: Mon, 25 Nov 2013 19:19:55 +0000
Message-ID: <DUB118-W3449F030E13F8088A847CC9CED0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dub0-omc1-s5.dub0.hotmail.com ([157.55.0.204]:19413 "EHLO
	dub0-omc1-s5.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507Ab3KYT0H convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:26:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello there,

I just ran the static analyser "cppcheck" over the source
code of linux-3.13-rc1. It said

[linux-3.13-rc1/net/netfilter/ipset/ip_set_hash_netnet.c:62] -> [linux-=
3.13-rc1/net/netfilter/ipset/ip_set_hash_netnet.c:62]: (style) Same exp=
ression on both sides of '=3D=3D'.

Source code is

static inline bool
hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const struct hash_netnet4_elem *ip=
2,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 *multi)
{
=A0=A0=A0 return ip1->ipcmp =3D=3D ip2->ipcmp &&
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ip2->ccmp =3D=3D ip2->ccmp;
}

Maybe=20

static inline bool
hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const struct hash_netnet4_elem *ip=
2,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 *multi)
{
=A0=A0=A0 return ip1->ipcmp =3D=3D ip2->ipcmp &&
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ip1->ccmp =3D=3D ip2->ccmp;
}

would be better code ?

Regards

David Binderman 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
