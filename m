Return-Path: <SRS0=t7ih=D6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F286DC55179
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Oct 2020 11:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8108E2192A
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Oct 2020 11:07:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="ICXzdbLV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462768AbgJWLHO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Oct 2020 07:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462745AbgJWLHO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Oct 2020 07:07:14 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB5BC0613CE
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2020 04:07:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y12so1338125wrp.6
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2020 04:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ivQ27H4Me/0gJ9ynsQhsYdlmDyhmpdOr0rFajIrbwvQ=;
        b=ICXzdbLVy49ho5H8auFaym86ud6/fLmN3wKdUMLlNyz7bdgeeXv203mZc1vxgLK+Kc
         aJlxL33WkTrhP0UKpNziKPuyYLcjQsLp7tLBGE24vo80rs3HEBclXENrCFaPrvTvPHJd
         /c0xrelZn2aUoVPEBuOxo9Gxay0b6JNWfELh0rzsSu0amxBYJveOLIZtZGI3zuWdXusx
         j6MfTe0495N7Bn4AUi2bpN+PneQ+CONmse/iXuAw05kovJ9hHCyqP2I4GV+FfdnFqLfN
         x6g8VbN4yGnFrC/K8BzFiJVDmu+35+b+OcOIjrOCfqqWoDDNoQzJiEU9XIZUviT5sxmk
         9MZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ivQ27H4Me/0gJ9ynsQhsYdlmDyhmpdOr0rFajIrbwvQ=;
        b=q/BA+5AqfriaxhV6N5kvTh4xQAPTEOgRSWu73ch6oLnVHlvMikBktxkCPCnJFcX466
         /e2rko5Wmdc/OWNqy7UIlVW68641AZ+MahgQDttDtmWTECZMz4Kz7LVUH9U96A3OCn2i
         Umztp7lBusOCZHJXasCcH2f3arzcf1ajF+r0OgfzQCpjEnC25GiWA936p/pXOLElqgzG
         gefJfuvMO0M7u34fL/VkToIrqy5q7xU2F/W7uONnozAGUPtD8Tpb9C5VFGHNeJ243lhv
         BvlP89mB3c+YAweiyWYOI5Rpsek1QIS+WwRpIGNpMbxNrekCImx9MYDo0nCaYPywza0j
         rPjA==
X-Gm-Message-State: AOAM530JDvSklutmk6AVr1dIB8LnFE8yQEMJoEt+Dae2pc5pMc7jJXYs
        rJ0cGKiwSgF2pd5DcZM62pdFWeSU4bjdSqyxJpqCFEGrznI=
X-Google-Smtp-Source: ABdhPJyejUcKCX62MevW4BB9MljuCMJknZktntCDvcQW8fvE1+Ox7puksAGxheACaap1lMRP/p2XVFuWrLJmjvpHb0o=
X-Received: by 2002:adf:8405:: with SMTP id 5mr2135148wrf.143.1603451232500;
 Fri, 23 Oct 2020 04:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
 <20200925124919.9389-7-mikhail.sennikovskii@cloud.ionos.com>
 <20201022123647.GA15948@salvia> <20201022123740.GA17175@salvia>
In-Reply-To: <20201022123740.GA17175@salvia>
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Date:   Fri, 23 Oct 2020 13:07:01 +0200
Message-ID: <CALHVEJbsA_-mKKEW_hn6s0W5xRus6bn4pDQNz-VViLoH8cVtxA@mail.gmail.com>
Subject: Re: [PATCH 6/8] conntrack: implement options output format
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks Pablo,

Do you want me to send the updated patchset with your adjustments incorporated?

Mikhail

On Thu, 22 Oct 2020 at 14:37, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Thu, Oct 22, 2020 at 02:36:47PM +0200, Pablo Neira Ayuso wrote:
> > Hi Mikhail,
> >
> > Thanks for your patchset.
> >
> > On Fri, Sep 25, 2020 at 02:49:17PM +0200, Mikhail Sennikovsky wrote:
> > > As a counterpart to the "conntrack: accept parameters from stdin"
> > > commit, this commit allows dumping conntrack entries in the format
> > > used by the conntrack parameters.
> > > This is useful for transfering a large set of ct entries between
> > > hosts or between different ct zones in an efficient way.
> > >
> > > To enable the "options" output the "-o opts" parameter needs to be
> > > passed to the "contnrack -L" tool invocation.
> >
> > I started slightly revisiting this 6/8 patch a bit (please find it
> > enclosed to this email), I have rename -o opts to -o save, to get this
> > aligned with iptables-save.
>
> Attaching the revisited patch 6/8 to this email.
>
> > I have also added a check for -o xml,save , to reject this
> > combination.
> >
> > I have extended it to display -I, -U, -D in the conntrack events.
> >
> > I have removed several safety runtime checks, that can be done at
> > registration time (make sure the option description is well-formed
> > from there, otherwise rise an error message to spot buggy protocol
> > extensions).
> >
> > This patch should also be extended to support for other existing
> > output flags combinations. Or just bail out if they are specified.
> >
> > At this point I have concerns with NAT: I don't see how this can work
> > as is. There is also a conntrack helpers that might trigger NAT
> > sequence adjustments, this information would be lost.
> >
> > We would need to expose all these details through the -o save, see
> > below. For some of this, there is no options from command line,
> > because it made no sense to expose them.
> >
> > We have to discuss this before deciding where to go. See below for
> > details.
> >
> > > To demonstrate the overall idea of the options output format works
> > > in conjunction with the "stdin parameter"s mode,
> > > the following command will copy all ct entries from one ct zone
> > > to another.
> > >
> > > conntrack -L -w 15 -o opts | sed 's/-w 15/-w 9915/g' | conntrack -I -
> >
> > For zone updates in the same host, probably conntrack can be extended
> > to support for:
> >
> >         conntrack -U --zone 15 --set-zone 9915
> >
> > If --set-zone is specified, then --zone is used a filter.
> >
> > Then, for "zone transfers" *between hosts*, a different way to address
> > this is to extend conntrackd.
> >
> > The idea is:
> >
> > 1) Add new "transfer" mode which does _not_ subscribe to
> >    conntrack events, it needs to register a new struct ct_mode
> >    (currently there is "sync" and "stats" ct_modes).
> >
> > 2) Add a new message type to request a zone transfer, e.g.
> >
> >         conntrackd --from 192.168.10.20 --zone 15 --set-zone 9915
> >
> >    This will make your local daemon send a request to the conntrackd
> >    instance running on host 192.168.10.20 to retrieve zone 1200. The
> >    remote conntrackd instance dumps the existing conntrack table from
> >    kernel and sends it to you.
> >
> >    You can reuse the channel infrastructure to establish communications
> >    between conntrackd instances in the new "transfer mode". You can
> >    also reuse the sync protocol, see network.h, build.c and parse.c,
> >    which takes a conntrack object and it translates it to network
> >    message.
> >
> >    Note that the struct internal_handler actually refers to the
> >    netlink handler for this new struct ct_mode that you would be
> >    registering.
> >
> > Let me know, thanks.
