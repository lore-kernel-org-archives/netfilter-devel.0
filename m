Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A97236495E
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 11:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777894201; cv=none; b=aV6Qu1rEvBoOGgriIghcgW0o4JnCfuc7LxJGfJuy0US6AKrwR9tRgvi0J+N7rFCTVZH4izPnJvOAMEXoSEMwu/KM+86dO13viZ4KtgQSG9PQNORLkxRPXAiLK+/9n0lbtZ4R4/qcqu2CrQqSbrrVNhSBuh8HfDAPTZAYhfz7FnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777894201; c=relaxed/simple;
	bh=V7SqjBUZMTFrmDm6K4pU5Bk6on/oOTTibfjTnP91aI0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VrqQbLM3JN4pOdmtYveD4AaO/ockImTb+WHaUZ8vCUNKP5mcAGY6O+/4JzdjbMxp7r2jAlt5eFSH/VezjJLjpqJeqpFRgQfGpuxSixXyv1zpr5UJvnlKcFgSfhKevmVvZHGA2mXUZuonp22Zfe9c7rHflUQYXOAJCW/nevLUIoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=Jgu/qBZV; arc=none smtp.client-ip=109.224.244.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Jgu/qBZV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1777894190; x=1778153390;
	bh=jNFSLYzIBfzRaexxXE/7K9XwCgdiTGJl6US0l+LpVwk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Jgu/qBZVBA247AFUXNuZffV2cW5q2e1Fy+wOheK/mKot1LmMmDElE7IKxk8dNsnBq
	 zeNmSRsY+OgmYB9oomt65vPmqZhbNkXZrMq59oiI1TYjyjT+rC1HzaVUdVwaKmd+33
	 i6KcQ0K3GaHS4+/Pxc/5yJ2lhDv+5pRdTNNGsXp64FXhdYH8Xzwg27ZZB0eVKQ8hT2
	 4u1G3uHLQoy26Gi0IiEqjjhRNISPXNicYsCr0TQrpGW1Xs0XI98XeLk2+W0CqCh1Cr
	 ZkSlphHQksr4NdvRkxsMe7scFSQEFWln82apXDbP2HhxDv3YHalEpqjGUBO5UyUCFU
	 vwdChAMDoPAxw==
Date: Mon, 04 May 2026 11:29:45 +0000
To: Pablo Neira Ayuso <pablo@netfilter.org>
From: tomaquet18 <tomaquet18@protonmail.com>
Cc: Florian Westphal <fw@strlen.de>, "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH v3] netfilter: conntrack: fix integer overflow in expectation timeout
Message-ID: <1wNAdKdLmyI6gBcuB3LhV6nKdw5Vm8J2cws0KCh2o7lXL4ClTlENEz2a8dBNmGLfbPg6BSH6retla7Q2hrd8cEHTOTkTuTRz5U-bacqjBjo=@protonmail.com>
In-Reply-To: <afh2nhDpxA_fpvMN@chamomile>
References: <URoBmF5z41cfYHGx8q3nhf3YY8hHFUEBPerB7PUqjKfy_QJ4Ka-i6Vd-_gCFnz3zk6ehxJLuQbbsw9QXoI2Z65Ey3vzsbrZwwI2I76m7VHo=@protonmail.com> <afgHrJui7augpjpY@1wt.eu> <l8AVWvD6RoSmOCOiqbZjUDtyKQ1edunHPFxlYRyOFmcGArTkah4UWfxXZ7bXUTR_4xE4DBb0g-ihuV6htO-hkgEVPcMtkKNt7QczaF0YzGw=@protonmail.com> <2026050434-regulator-quadrant-dea5@gregkh> <f23njo6iy6gjV6hIAuL-14bzzPrCruI62xydmyd9GtYmKQIY4x91k1tqKeT7LufsDxVKKUBi6rzkQgq0uj-YSApJe9-L56z2h-U4dvPBLZA=@protonmail.com> <afh2nhDpxA_fpvMN@chamomile>
Feedback-ID: 64308806:user:proton
X-Pm-Message-ID: 76489a8c3650745348a827bf30df590773f038fe
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Understood completely. I have dropped the security framing and will treat t=
his strictly as a functional bug fix for nf-next.

I realize my previous email format broke Patchwork. I have just sent a clea=
n v4 patch in a new thread addressing all your feedback.

Thanks for the guidance and your time.

On Monday, May 4th, 2026 at 12:36, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:

> Hi,
>
> This is not security stuff, submitting this via
> netfilter-devel@vger.kernel is sufficient.
>
> Patchwork does not show your patch.
>
> https://patchwork.ozlabs.org/project/netfilter-devel/list/
>
> On Mon, May 04, 2026 at 10:14:25AM +0000, tomaquet18 wrote:
> > Hi Pablo, Florian, and Greg,
> >
> > Here is the v3 resubmission of the fix, with the changelog text properl=
y wrapped at 72 columns as requested.
> >
> > Regarding the security implications: while this function requires CAP_N=
ET_ADMIN, I have verified that an unprivileged local user can trigger the o=
verflow by setting up a user and network namespace (unshare -Ur -n).
>
> What security implication? This is just the entry being removed
> inmediately.
>
> > Although this does not escape the sandbox, the 32-bit wrap-around force=
s the garbage collector to immediately destroy valid expectations. This bre=
aks the integrity of the conntrack state machine and causes a selective loc=
al DoS against protocols relying on expectations within that environment.
>
> What? "Selective local DoS against protocol relying on expectation"?
>
> No, sorry. This is not security material, maybe nf-next stuff at best.
>
> > Thanks for your time and review.
> >
> > ---
> > From b7a8f10666325ca70020769dc20d47776ccae440 Mon Sep 17 00:00:00 2001
> > From: =3D?UTF-8?q?=3DC3=3D80lex=3D20Fern=3DC3=3DA1ndez?=3D <tomaquet18@=
protonmail.com>
> > Date: Mon, 4 May 2026 09:51:40 +0200
> > Subject: [PATCH v3] netfilter: conntrack: fix integer overflow in expec=
tation
> >  timeout
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=3DUTF-8
> > Content-Transfer-Encoding: 8bit
> >
> > In ctnetlink_change_expect(), the expectation timeout is calculated by
> > multiplying the user-provided timeout value by HZ. Because ntohl()
> > returns a 32-bit unsigned integer, this multiplication is performed in
> > 32-bit arithmetic before being promoted to the 64-bit jiffies format.
> >
> > If a user provides a large enough timeout (e.g., 42949673 on a system
> > with HZ=3D100), the multiplication wraps around the 32-bit limit,
> > resulting in a near-zero jiffies value. This causes the expectation
> > to be immediately collected by the garbage collector instead of staying
> > open for the requested duration.
> >
> > This patch casts the result of ntohl() to u64 prior to multiplication,
> > matching the safe pattern already used for standard conntrack timeouts.
> >
> > Signed-off-by: =C3=80lex Fern=C3=A1ndez <tomaquet18@protonmail.com>
> > ---
> >  net/netfilter/nf_conntrack_netlink.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_co=
nntrack_netlink.c
> > index eda5fe4a7..be89bf1ba 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -3466,7 +3466,7 @@ ctnetlink_change_expect(struct nf_conntrack_expec=
t *x,
> >                         return -ETIME;
> >
> >                 x->timeout.expires =3D jiffies +
> > -                       ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * =
HZ;
> > +                       (u64)ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT]=
)) * HZ;
> >                 add_timer(&x->timeout);
> >         }
> >         return 0;
> > --
> > 2.43.0
> >
> > On Monday, May 4th, 2026 at 10:10, Greg KH <gregkh@linuxfoundation.org>=
 wrote:
> >
> > > On Mon, May 04, 2026 at 08:05:45AM +0000, tomaquet18 wrote:
> > > > Hi Willy,
> > > >
> > > > Thank you for the feedback and the guidance regarding the requireme=
nts. I completely understand.
> > > >
> > > > I have updated my identity to my real name. I am resending the fix =
as a v2 patch and including the Netfilter maintainers in CC as requested.
> > >
> > > As this isn't a security issue, shouldn't this just be sent to the
> > > normal mailing list and maintainers that way?  Again, no need to cc:
> > > security@kernel.org anymore, right?
> > >
> > > Also, you should wrap your changelog text at 72 columns.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
>
