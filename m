From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_queue: reject NF_STOLEN verdicts from userspace
Date: Tue, 30 Aug 2011 15:02:02 +0200
Message-ID: <4E5CDF4A.3090206@trash.net>
References: <1313181292-8683-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55029 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab1H3NCI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:02:08 -0400
In-Reply-To: <1313181292-8683-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.08.2011 22:34, Florian Westphal wrote:
> A userspace listener may send (bogus) NF_STOLEN verdict, which causes=
 skb leak.
>=20
> This problem was previously fixed via
> 64507fdbc29c3a622180378210ecea8659b14e40 (netfilter:
> nf_queue: fix NF_STOLEN skb leak) but this had to be reverted because
> NF_STOLEN can also be returned by a netfilter hook when iterating the
> rules in nf_reinject.
>=20
> Reject userspace NF_STOLEN verdict, as suggested by Micha=C5=82 Miros=
=C5=82aw.
>=20
> This is complementary to commit fad54440438a7c231a6ae347738423cbabc93=
6d9
> (netfilter: avoid double free in nf_reinject).
>=20
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
