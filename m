From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Snooping expected connections in a user CT helper
Date: Tue, 23 Aug 2016 17:36:10 +0200
Message-ID: <20160823153610.GA10746@salvia>
References: <CAJzqFtacjKi+zQT3nS_0UJAr=LD8RWumM5+jeo8bbi-OVZR0Jg@mail.gmail.com>
 <20160818011214.GA1463@salvia>
 <CAJzqFtaj3V2viTtNjhoG5zPsz0XkPXi9XULRwz1PGOe3imq_XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ashley.hughes@blueyonder.co.uk,
        arequipeno@gmail.com
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753298AbcHWPgT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 11:36:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25802131CA4
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:36:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17455100A7F
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:36:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8FBC100A7F
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:36:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAJzqFtaj3V2viTtNjhoG5zPsz0XkPXi9XULRwz1PGOe3imq_XA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 08:34:41PM -0700, Kevin Cernekee wrote:
> On Wed, Aug 17, 2016 at 6:12 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Looking at ctnetlink, it should be possible to make it via
> > CTA_EXPECT_HELP_NAME. Thus, by when we find a matching expectation,
> > the helper is set to this new connection too.
> >
> > See line 1086 in nf_conntrack_core.c.
> 
> Thanks, that works.  After setting the helper string, my callback is
> invoked for the replies.
> 
> I'm running into a couple of other issues with the existing ssdp helper, though:
> 
> 1) The code does not call cthelper_add_expect().  Nor do some of the
> other helpers, such as sane.

If you attach the helper via "myct->exp = exp" then the expectation is
set up from nfqueue path.

cthelper_add_expect() was introduced in first place, so it is an older
way to attach expectations from userspace IIRC.

> When I use a restrictive firewall configuration, the expectation is
> never created (according to `conntrack -L expect`) and all of the
> incoming SSDP replies are dropped.  Adding a call to
> cthelper_add_expect() fixes this.  Do we know the circumstances
> under which the current master branch is expected to work properly?
> 
> 2) Just noticed that the sane and tftp modules require Linux 3.12+.
> My test system is running 3.8.  Does ssdp have a similar restriction,
> and if so, what would need to be backported?

Userspace expectation creation via nfqueue is available since 3.12.
The relevant code is under ctnetlink_nfqueue_attach_expect() in
nf_conntrack_netlink.c, if you want to follow that path, you'll have
to backport, then pull accumulated fixes by tracking my nf.git tree.

I can have a look back and see what needs to be passed to -stable (up
to 3.12) if that makes it easier for you.

> 3) It looks like each expectation matches, at most, one new
> connection.  So if my host multicasts an SSDP request and then 5 other
> hosts send replies (each coming from a unique IP/port), only one of
> them will match the expectation and create a state table entry.  Is
> this true, and if so, what is the best way to allow all 5 replies to
> be treated as related connections?

If you set the permanent expectation flag, the expectation remains
there forever, so all 5 replies will go through as related. Permanent
expectations don't get removed by when we see a matching, they remain
there as long as the master conntrack is there in place.

> 4) Ashley's email address was bouncing due to an overzealous spam
> filter.  Will retry one last time.

OK.
