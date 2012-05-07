From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_expect: partially implement
 ctnetlink_change_expect
Date: Mon, 7 May 2012 10:42:28 +0200
Message-ID: <20120507084228.GA27334@1984>
References: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
 <1336005564-23171-3-git-send-email-kelvie@ieee.org>
 <20120506230915.GA23306@1984>
 <CAK2bC5rMTMMdepCUpv6oB17ez-LMp=ZUSXacomZXTiM1ZDB92w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Kelvie Wong <kelvie@ieee.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54015 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab2EGImb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 04:42:31 -0400
Content-Disposition: inline
In-Reply-To: <CAK2bC5rMTMMdepCUpv6oB17ez-LMp=ZUSXacomZXTiM1ZDB92w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 06, 2012 at 06:51:45PM -0700, Kelvie Wong wrote:
> Hey Pablo,
>=20
> On Sun, May 6, 2012 at 4:09 PM, Pablo Neira Ayuso <pablo@netfilter.or=
g> wrote:
> > You have to protect this with nf_conntrack_lock spinlock. See
> > net/netfilter/nf_conntrack_expect.c for expectation handling.
>=20
> ctnetlink_change_expect is not exported, and it is only called in
> ctnetlink_new_expect, which is protected by the spinlock.

You're right, I've overlooked this.

> >
> >> =A0 =A0 =A0 return -EOPNOTSUPP;
> >
> > Now that we support expectation changing, this should be return 0.
>=20
> I can make this change.
>=20
> > We have two choices for this:
> >
> > a) rework the patch with the suggestion that I made.
> > b) add some NF_CT_EXPECT_FIXED_TIMEOUT flag like we have in the
> > =A0 connection tracking. Thus, the expectation will not ever expire=
=2E
> >
> > I'd need to know more about how you're using this. Depending on tha=
t,
> > we can select a) or b).
>=20
> I think we need to do a). A fixed timeout won't work, as in some case=
s we
> need to extend the expectation (the server has asked to use the same =
port
> again, so we need to give it another 10 minutes, possibly indefinitel=
y),
> whereas in other cases we can just safely let the expectation expire.
>=20
> I want to avoid leaving the expectation forever, but I can't know unt=
il I see
> the DCERPC traffic.

OK, then I'll take your patch. I'll mangle it to return 0 instead.

> > BTW, I'm working on finishing some user-space framework for develop=
ing
> > helper in user-space. My question is: would you be interested in
> > integrating your DCERPC helper into it?
> >
> > I expect to post some code soon, still working on it.
>=20
> I just need something to work right now (I'm going to use my original=
 patch
> as-is, unless I made a grave error somewhere), but maybe in the futur=
e if
> it will ease maintenance.

I guess it will ease maintainance, really.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
