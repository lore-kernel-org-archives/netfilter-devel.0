From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] Re: [PATCH] iptables: Constify option
 struct
Date: Mon, 27 Mar 2017 23:37:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1703272336390.3204@hadrien>
References: <1490641815-12741-1-git-send-email-gs051095@gmail.com> <20170327191239.GA18080@salvia> <CAOCi2DFt9kYKDE8Cn47Pbh=B4-E_PLSKLxXLmsdjfdyNWwcm7Q@mail.gmail.com> <CAOCi2DFc2aURc5gAuF5q6NLvBwiVSbF6cpoF=ipfVwntz=86Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Gargi Sharma <gs051095@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:50767 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751852AbdC0VhS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 17:37:18 -0400
In-Reply-To: <CAOCi2DFc2aURc5gAuF5q6NLvBwiVSbF6cpoF=ipfVwntz=86Hg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On Tue, 28 Mar 2017, Gargi Sharma wrote:

> On Tue, Mar 28, 2017 at 12:45 AM, Gargi Sharma <gs051095@gmail.com> wrote:
> > On Tue, Mar 28, 2017 at 12:42 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>
> >> On Tue, Mar 28, 2017 at 12:40:15AM +0530, Gargi Sharma wrote:
> >> > The struct  of the type option is only used to initialise a field
> >> > inside the xtables_match struct and is not modified anywhere.
> >> > Done using Coccinelle:
> >> >
> >> > @r1 disable optional_qualifier@
> >> > identifier s,i;
> >> > position p;
> >> > @@
> >> >
> >> > static struct option i@p[] ={...};
> >> >
> >> > @ok1@
> >> > identifier r1.i;
> >> > expression e;
> >> > position p;
> >> > @@
> >> > e = i@p
> >> >
> >> > @bad@
> >> > position p != {r1.p,ok1.p};
> >> > identifier r1.i;
> >> > @@
> >> > e@i@p
> >> >
> >> > @depends on !bad disable optional_qualifier@
> >> > identifier r1.i;
> >> > @@
> >> > static
> >> > +const
> >> > struct option i[] = { ... };
> >>
> >> Applied, thanks.
> >>
> >> You can probably have a look at ebtables.git, probably there are more
> >> things to constify there.
>
> Hi Pablo,
>
> There are around 18 files being affected by this semantic patch in
> ebtables. Should I still send them as a single patch(since it might be
> difficult to review a large single patch)?

If they are just independent structures, you can cut up the patches if it
seems best.  If the changes are interdependent, then one patch would be
better.

julia

>
> Thanks!
> Gargi
> >>
> > Okay, I will. :)
> >
> > Thanks!
> > Gargi
> >> --
> >> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> >> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> >> To post to this group, send email to outreachy-kernel@googlegroups.com.
> >> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20170327191239.GA18080%40salvia.
> >> For more options, visit https://groups.google.com/d/optout.
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/CAOCi2DFc2aURc5gAuF5q6NLvBwiVSbF6cpoF%3DipfVwntz%3D86Hg%40mail.gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
