Received: from mail-10696.protonmail.ch (mail-10696.protonmail.ch [79.135.106.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F20390CB3
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 10:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777889682; cv=none; b=EIFKNLEKwKXbptXjzOJeMETviq7Gr9VavK1HNVEDpwjVuBVUK/HD2PdVNs+Z4NZAU2ZsTxCH1dm/owBsleIHlIs+klpdLDqQe4h8AL6b4Z/b29wLGtb37lpe4k+yrXlv8lYgoqtO0XzdbT98D0scN2fcwmtwr4FSmrDtWjAS8uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777889682; c=relaxed/simple;
	bh=9vYCN0PLs77utSvZD1BYgdAqzizl/M1pvJxUKiggM78=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OwNoc8w+Rjg1OMYM8UVzfx3mAk6c/M4tU05RUy9TXkdpXpt3NWbpFaXLjnZfpy/FiN7Fm3awEatLCwjB8p1qG8Z7dP5TVGDWxjKE5M/I1Vc8PDOdyNIUgOj6cNxa+dlEdkr+gBJ1KqpMtog4oSQjY7bB+hXWJ0i0dvR43J174qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=WiIy46rd; arc=none smtp.client-ip=79.135.106.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="WiIy46rd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1777889671; x=1778148871;
	bh=xh9F1DBY/tyX7V6T3Eeoh1pOA7lrTCvwBS23b8sXXEU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=WiIy46rdkVOUqv86jjqWJgrnp48iaF+kpg15JtQIO6ftq8Dy2IGLcYe/SLCVmlDY1
	 Mohdat7taMKhxo1UXGvF13JcvvVQMQuE3zZUFtRJUieMraDRmpebUXTuj1xDyyeLaj
	 Eb11T3zacxDAWDmz8oHmn1FH+MtZNAep9bG17gIyatiDHyYnpNYVV/bDQvuAFCQAeK
	 /WFSCnydswP8GVB+hFEC7waKhjrySXgTUw8La/X9X6ikxxRekX/MPPtMmKxonekdcl
	 3DjG62KOk/uvjJ3JQI/Q+40HXhskDko/eobeBeBpANqX6mA4LybZHeeDWJwNERUt1j
	 bGtnf6fXpw09g==
Date: Mon, 04 May 2026 10:14:25 +0000
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>, "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: tomaquet18 <tomaquet18@protonmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH v3] netfilter: conntrack: fix integer overflow in expectation timeout
Message-ID: <f23njo6iy6gjV6hIAuL-14bzzPrCruI62xydmyd9GtYmKQIY4x91k1tqKeT7LufsDxVKKUBi6rzkQgq0uj-YSApJe9-L56z2h-U4dvPBLZA=@protonmail.com>
In-Reply-To: <2026050434-regulator-quadrant-dea5@gregkh>
References: <URoBmF5z41cfYHGx8q3nhf3YY8hHFUEBPerB7PUqjKfy_QJ4Ka-i6Vd-_gCFnz3zk6ehxJLuQbbsw9QXoI2Z65Ey3vzsbrZwwI2I76m7VHo=@protonmail.com> <afgHrJui7augpjpY@1wt.eu> <l8AVWvD6RoSmOCOiqbZjUDtyKQ1edunHPFxlYRyOFmcGArTkah4UWfxXZ7bXUTR_4xE4DBb0g-ihuV6htO-hkgEVPcMtkKNt7QczaF0YzGw=@protonmail.com> <2026050434-regulator-quadrant-dea5@gregkh>
Feedback-ID: 64308806:user:proton
X-Pm-Message-ID: 1a5a0d4ef6378b09691f399deac3aaee4553f681
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Pablo, Florian, and Greg,

Here is the v3 resubmission of the fix, with the changelog text properly wr=
apped at 72 columns as requested.

Regarding the security implications: while this function requires CAP_NET_A=
DMIN, I have verified that an unprivileged local user can trigger the overf=
low by setting up a user and network namespace (unshare -Ur -n).

Although this does not escape the sandbox, the 32-bit wrap-around forces th=
e garbage collector to immediately destroy valid expectations. This breaks =
the integrity of the conntrack state machine and causes a selective local D=
oS against protocols relying on expectations within that environment.

Thanks for your time and review.

---
From b7a8f10666325ca70020769dc20d47776ccae440 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?=3DC3=3D80lex=3D20Fern=3DC3=3DA1ndez?=3D <tomaquet18@prot=
onmail.com>
Date: Mon, 4 May 2026 09:51:40 +0200
Subject: [PATCH v3] netfilter: conntrack: fix integer overflow in expectati=
on
 timeout
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

In ctnetlink_change_expect(), the expectation timeout is calculated by
multiplying the user-provided timeout value by HZ. Because ntohl()
returns a 32-bit unsigned integer, this multiplication is performed in
32-bit arithmetic before being promoted to the 64-bit jiffies format.

If a user provides a large enough timeout (e.g., 42949673 on a system
with HZ=3D100), the multiplication wraps around the 32-bit limit,
resulting in a near-zero jiffies value. This causes the expectation
to be immediately collected by the garbage collector instead of staying
open for the requested duration.

This patch casts the result of ntohl() to u64 prior to multiplication,
matching the safe pattern already used for standard conntrack timeouts.

Signed-off-by: =C3=80lex Fern=C3=A1ndez <tomaquet18@protonmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntr=
ack_netlink.c
index eda5fe4a7..be89bf1ba 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3466,7 +3466,7 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x=
,
                        return -ETIME;

                x->timeout.expires =3D jiffies +
-                       ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
+                       (u64)ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) *=
 HZ;
                add_timer(&x->timeout);
        }
        return 0;
--
2.43.0

On Monday, May 4th, 2026 at 10:10, Greg KH <gregkh@linuxfoundation.org> wro=
te:

> On Mon, May 04, 2026 at 08:05:45AM +0000, tomaquet18 wrote:
> > Hi Willy,
> >
> > Thank you for the feedback and the guidance regarding the requirements.=
 I completely understand.
> >
> > I have updated my identity to my real name. I am resending the fix as a=
 v2 patch and including the Netfilter maintainers in CC as requested.
>=20
> As this isn't a security issue, shouldn't this just be sent to the
> normal mailing list and maintainers that way?  Again, no need to cc:
> security@kernel.org anymore, right?
>=20
> Also, you should wrap your changelog text at 72 columns.
>=20
> thanks,
>=20
> greg k-h
> 
