From: Kevin Cernekee <cernekee@chromium.org>
Subject: Re: Snooping expected connections in a user CT helper
Date: Mon, 22 Aug 2016 20:34:41 -0700
Message-ID: <CAJzqFtaj3V2viTtNjhoG5zPsz0XkPXi9XULRwz1PGOe3imq_XA@mail.gmail.com>
References: <CAJzqFtacjKi+zQT3nS_0UJAr=LD8RWumM5+jeo8bbi-OVZR0Jg@mail.gmail.com>
 <20160818011214.GA1463@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, ashley.hughes@blueyonder.co.uk,
        arequipeno@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:35528 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbcHWDfE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 23:35:04 -0400
Received: by mail-it0-f53.google.com with SMTP id x131so125047459ite.0
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 20:35:04 -0700 (PDT)
Received: from mail-it0-f49.google.com (mail-it0-f49.google.com. [209.85.214.49])
        by smtp.gmail.com with ESMTPSA id o201sm738100iod.16.2016.08.22.20.35.02
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Aug 2016 20:35:02 -0700 (PDT)
Received: by mail-it0-f49.google.com with SMTP id e63so125101782ith.1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 20:35:02 -0700 (PDT)
In-Reply-To: <20160818011214.GA1463@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 17, 2016 at 6:12 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Looking at ctnetlink, it should be possible to make it via
> CTA_EXPECT_HELP_NAME. Thus, by when we find a matching expectation,
> the helper is set to this new connection too.
>
> See line 1086 in nf_conntrack_core.c.

Thanks, that works.  After setting the helper string, my callback is
invoked for the replies.

I'm running into a couple of other issues with the existing ssdp helper, though:

1) The code does not call cthelper_add_expect().  Nor do some of the
other helpers, such as sane.  When I use a restrictive firewall
configuration, the expectation is never created (according to
`conntrack -L expect`) and all of the incoming SSDP replies are
dropped.  Adding a call to cthelper_add_expect() fixes this.  Do we
know the circumstances under which the current master branch is
expected to work properly?

2) Just noticed that the sane and tftp modules require Linux 3.12+.
My test system is running 3.8.  Does ssdp have a similar restriction,
and if so, what would need to be backported?

3) It looks like each expectation matches, at most, one new
connection.  So if my host multicasts an SSDP request and then 5 other
hosts send replies (each coming from a unique IP/port), only one of
them will match the expectation and create a state table entry.  Is
this true, and if so, what is the best way to allow all 5 replies to
be treated as related connections?

4) Ashley's email address was bouncing due to an overzealous spam
filter.  Will retry one last time.
