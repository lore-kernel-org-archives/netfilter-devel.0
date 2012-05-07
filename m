From: Kelvie Wong <kelvie@ieee.org>
Subject: Re: [PATCH] netfilter: nf_ct_expect: partially implement ctnetlink_change_expect
Date: Sun, 6 May 2012 18:51:45 -0700
Message-ID: <CAK2bC5rMTMMdepCUpv6oB17ez-LMp=ZUSXacomZXTiM1ZDB92w@mail.gmail.com>
References: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
	<1336005564-23171-3-git-send-email-kelvie@ieee.org>
	<20120506230915.GA23306@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43957 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab2EGBvr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 May 2012 21:51:47 -0400
Received: by bkcji2 with SMTP id ji2so3303784bkc.19
        for <netfilter-devel@vger.kernel.org>; Sun, 06 May 2012 18:51:46 -0700 (PDT)
In-Reply-To: <20120506230915.GA23306@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hey Pablo,

On Sun, May 6, 2012 at 4:09 PM, Pablo Neira Ayuso <pablo@netfilter.org>=
 wrote:
> You have to protect this with nf_conntrack_lock spinlock. See
> net/netfilter/nf_conntrack_expect.c for expectation handling.

ctnetlink_change_expect is not exported, and it is only called in
ctnetlink_new_expect, which is protected by the spinlock.

>
>> =C2=A0 =C2=A0 =C2=A0 return -EOPNOTSUPP;
>
> Now that we support expectation changing, this should be return 0.

I can make this change.

> We have two choices for this:
>
> a) rework the patch with the suggestion that I made.
> b) add some NF_CT_EXPECT_FIXED_TIMEOUT flag like we have in the
> =C2=A0 connection tracking. Thus, the expectation will not ever expir=
e.
>
> I'd need to know more about how you're using this. Depending on that,
> we can select a) or b).

I think we need to do a). A fixed timeout won't work, as in some cases =
we
need to extend the expectation (the server has asked to use the same po=
rt
again, so we need to give it another 10 minutes, possibly indefinitely)=
,
whereas in other cases we can just safely let the expectation expire.

I want to avoid leaving the expectation forever, but I can't know until=
 I see
the DCERPC traffic.

>
> BTW, I'm working on finishing some user-space framework for developin=
g
> helper in user-space. My question is: would you be interested in
> integrating your DCERPC helper into it?
>
> I expect to post some code soon, still working on it.

I just need something to work right now (I'm going to use my original p=
atch
as-is, unless I made a grave error somewhere), but maybe in the future =
if
it will ease maintenance.

Thanks for your help!
--=20
Kelvie Wong
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
