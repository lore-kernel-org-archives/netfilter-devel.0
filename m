From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] netfilter: fix the race when initializing
 nf_ct_expect_hash_rnd
Date: Wed, 05 Jan 2011 19:03:18 +0100
Message-ID: <1294250598.10633.77.camel@edumazet-laptop>
References: <1294237403-15616-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65105 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1AESDY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 13:03:24 -0500
In-Reply-To: <1294237403-15616-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 05 janvier 2011 =C3=A0 22:23 +0800, Changli Gao a =C3=A9cri=
t :
> Since nf_ct_expect_dst_hash() may be called without nf_conntrack_lock
> locked, nf_ct_expect_hash_rnd should be initialized in the atomic way=
=2E
>=20
> In this patch, we use nf_conntrack_hash_rnd instead of
> nf_ct_expect_hash_rnd.
>=20
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ---

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Problem is Patrick seems not responsive these days ;)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
