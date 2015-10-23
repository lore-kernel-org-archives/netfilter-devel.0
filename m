From: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Subject: Re: linux 3.4.43 : kernel crash at __nf_conntrack_confirm
Date: Thu, 22 Oct 2015 22:39:45 -0400
Message-ID: <20151022223945.660a1838@playground>
References: <CAOxq_8PF91fpX9jYTgBbXnOVeVfSu3tytu-3P_Zr5OodGRoz+g@mail.gmail.com>
	<CAOxq_8Pt7VMwkV8+wdjS9vj=-L0L8Xxkd3Beit0zZN_oR6ixhw@mail.gmail.com>
	<20151018080702.GA14564@breakpoint.cc>
	<CAOxq_8P9Qgy5+qWNCHtbG8qJwfdKSO3ZiDWoQW_6BVS-+hcTRA@mail.gmail.com>
	<20151021211911.GD31323@breakpoint.cc>
	<CAOxq_8PLX_+w-7mfx1Agh+utogEiFWHSmEFd0Bax1LY6qbEN-w@mail.gmail.com>
	<20151022034232.58e5af7a@playground>
	<CAOxq_8PTLQGZ7WwMX8W0dmWW3+cMbv5BkocR3rsW=rNTfxXRjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ani Sinha <ani@arista.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from MAIL1.WPI.EDU ([130.215.36.91]:53610 "EHLO MAIL1.WPI.EDU"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbbJWCjt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Oct 2015 22:39:49 -0400
In-Reply-To: <CAOxq_8PTLQGZ7WwMX8W0dmWW3+cMbv5BkocR3rsW=rNTfxXRjw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 22 Oct 2015 12:53:57 -0700
Ani Sinha <ani@arista.com> wrote:

> On Thu, Oct 22, 2015 at 12:42 AM, Neal P. Murphy
> <neal.p.murphy@alum.wpi.edu> wrote:
> > On Wed, 21 Oct 2015 14:26:35 -0700
> > Ani Sinha <ani@arista.com> wrote:
> >
> >> On Wed, Oct 21, 2015 at 2:19 PM, Florian Westphal <fw@strlen.de> wrote:
> >> > Ani Sinha <ani@arista.com> wrote:
> >> >> >> > commit c6825c0976fa7893692e0e43b09740b419b23c09
> >> >> >> > Author: Andrey Vagin <avagin@openvz.org>
> >> >> >> > Date:   Wed Jan 29 19:34:14 2014 +0100
> >> >> >> >      netfilter: nf_conntrack: fix RCU race in nf_conntrack_find_get
> >> >> >> >
> >> >> >> > and a followup patch :
> >> >> >> >
> >> >> >> > commit e53376bef2cd97d3e3f61fdc677fb8da7d03d0da
> >> >> >> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> >> >> >> > Date:   Mon Feb 3 20:01:53 2014 +0100
> >> >> >> >         netfilter: nf_conntrack: don't release a conntrack with non-zero refcnt
> >> >> >> >
> >> >> >
> >> >> > These for instance fix such bugs.
> >> >>
> >> >> So since both these patches were not backported to 3.4 series and
> >> >> since now we have evidence of a crash that points to issues which the
> >> >> patches fix, should we consider backporting the above patches to 3.4?
> >> >
> >> > Yes.
> >>
> >> Ok cool. I will send out backport patches for 3.4 corresponding to
> >> both the above patches.
> >
> > As an FYI, Zefan Li just released 3.4.110; I didn't see the fix in the list. No surprise, of course; it does take more than 12 hours to get patches right, as I am painfully aware.
> >
> > I just bumped Smoothwall Express to 3.4.109 in Update4, and 3.4.110 contains fixes that relate to Smoothwall. May I safely assume that these patches will apply easily to 3.4.110? The obvious answer is, "Yes," but I'd like a bit of reassurance (<pat> <pat> "There, there; it'll be fine. The patches will be OK.") before I prepare and release the next update.
> 
> The patches won't apply as is. There will be some work involved. For
> example, one of the patches involves modification in synproxy module.
> This isn't available in 3.4 train. So don't hold your breath. I will
> work on this as soon as I can.

Agreed and accepted. The patches will be ready when they're ready and not a moment sooner. I'm not trying to rush the process, and certainly not trying to brace you while asking questions you cannot possibly answer (yet).

Just for planning purposes, might you expect the changes to be confined to modules? That is, would I be able to rebuild the kernel and distribute just a few updated modules? Or might I have to release a complete kernel? At this point, "could go either way" is a good answer, too.

Considering Greg K-H's recent releases, I expect a 3.4.111 release in the next couple months.

Thanks,
Neal
