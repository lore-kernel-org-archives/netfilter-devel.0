From: Kevin Cernekee <cernekee@chromium.org>
Subject: Re: Snooping expected connections in a user CT helper
Date: Thu, 1 Sep 2016 16:47:44 -0700
Message-ID: <CAJzqFtaRHOLUG=Fma+A_0gOe3E3AUzheK4x7_t-2e+eebrpZtg@mail.gmail.com>
References: <CAJzqFtacjKi+zQT3nS_0UJAr=LD8RWumM5+jeo8bbi-OVZR0Jg@mail.gmail.com>
 <20160818011214.GA1463@salvia> <CAJzqFtaj3V2viTtNjhoG5zPsz0XkPXi9XULRwz1PGOe3imq_XA@mail.gmail.com>
 <20160823153610.GA10746@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, ashley.hughes@blueyonder.co.uk,
        Ian Pilcher <arequipeno@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:36062 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbcIAXsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2016 19:48:07 -0400
Received: by mail-it0-f48.google.com with SMTP id i184so9495328itf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Sep 2016 16:48:06 -0700 (PDT)
Received: from mail-it0-f42.google.com (mail-it0-f42.google.com. [209.85.214.42])
        by smtp.gmail.com with ESMTPSA id f65sm611608ita.10.2016.09.01.16.48.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Sep 2016 16:48:05 -0700 (PDT)
Received: by mail-it0-f42.google.com with SMTP id i184so9494698itf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Sep 2016 16:48:05 -0700 (PDT)
In-Reply-To: <20160823153610.GA10746@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 23, 2016 at 8:36 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> 2) Just noticed that the sane and tftp modules require Linux 3.12+.
>> My test system is running 3.8.  Does ssdp have a similar restriction,
>> and if so, what would need to be backported?
>
> Userspace expectation creation via nfqueue is available since 3.12.
> The relevant code is under ctnetlink_nfqueue_attach_expect() in
> nf_conntrack_netlink.c, if you want to follow that path, you'll have
> to backport, then pull accumulated fixes by tracking my nf.git tree.
>
> I can have a look back and see what needs to be passed to -stable (up
> to 3.12) if that makes it easier for you.

Thanks for the offer.  I have switched to a different test device
which is running Linux 3.14, and I added a note to the comments in
ssdp.c regarding the 3.12+ requirement.

>> 3) It looks like each expectation matches, at most, one new
>> connection.  So if my host multicasts an SSDP request and then 5 other
>> hosts send replies (each coming from a unique IP/port), only one of
>> them will match the expectation and create a state table entry.  Is
>> this true, and if so, what is the best way to allow all 5 replies to
>> be treated as related connections?
>
> If you set the permanent expectation flag, the expectation remains
> there forever, so all 5 replies will go through as related. Permanent
> expectations don't get removed by when we see a matching, they remain
> there as long as the master conntrack is there in place.

The patch that I sent out last night is able to handle scenarios in
which the event occurs shortly after the subscription is established.
But in my testing I am noticing two other problems:

1) Approximately two minutes after the subscription is set up, the
expectation abruptly disappears.  This even happens if I set the
timeout to 3600; it shows up in `conntrack -L expect` until the time
column drops to ~3480, then it is gone.  This may be caused by the
master conntrack expiring.  Is there a way to set up the expectation
so that it persists for the entire timeout period?

2) The timeout is not extended when there is activity on the
expectation.  It would be good if it was extended any time there is
new activity, in order to support long-lived subscriptions.
