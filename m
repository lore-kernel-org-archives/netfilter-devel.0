From: Gargi Sharma <gs051095@gmail.com>
Subject: Re: [Outreachy kernel] Re: [PATCH] iptables: Constify option struct
Date: Tue, 28 Mar 2017 01:27:29 +0530
Message-ID: <CAOCi2DFc2aURc5gAuF5q6NLvBwiVSbF6cpoF=ipfVwntz=86Hg@mail.gmail.com>
References: <1490641815-12741-1-git-send-email-gs051095@gmail.com>
 <20170327191239.GA18080@salvia> <CAOCi2DFt9kYKDE8Cn47Pbh=B4-E_PLSKLxXLmsdjfdyNWwcm7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org,
        outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36332 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbdC0T6B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 15:58:01 -0400
Received: by mail-it0-f67.google.com with SMTP id 190so13794391itm.3
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 12:58:00 -0700 (PDT)
In-Reply-To: <CAOCi2DFt9kYKDE8Cn47Pbh=B4-E_PLSKLxXLmsdjfdyNWwcm7Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 28, 2017 at 12:45 AM, Gargi Sharma <gs051095@gmail.com> wrote:
> On Tue, Mar 28, 2017 at 12:42 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>
>> On Tue, Mar 28, 2017 at 12:40:15AM +0530, Gargi Sharma wrote:
>> > The struct  of the type option is only used to initialise a field
>> > inside the xtables_match struct and is not modified anywhere.
>> > Done using Coccinelle:
>> >
>> > @r1 disable optional_qualifier@
>> > identifier s,i;
>> > position p;
>> > @@
>> >
>> > static struct option i@p[] ={...};
>> >
>> > @ok1@
>> > identifier r1.i;
>> > expression e;
>> > position p;
>> > @@
>> > e = i@p
>> >
>> > @bad@
>> > position p != {r1.p,ok1.p};
>> > identifier r1.i;
>> > @@
>> > e@i@p
>> >
>> > @depends on !bad disable optional_qualifier@
>> > identifier r1.i;
>> > @@
>> > static
>> > +const
>> > struct option i[] = { ... };
>>
>> Applied, thanks.
>>
>> You can probably have a look at ebtables.git, probably there are more
>> things to constify there.

Hi Pablo,

There are around 18 files being affected by this semantic patch in
ebtables. Should I still send them as a single patch(since it might be
difficult to review a large single patch)?

Thanks!
Gargi
>>
> Okay, I will. :)
>
> Thanks!
> Gargi
>> --
>> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
>> To post to this group, send email to outreachy-kernel@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20170327191239.GA18080%40salvia.
>> For more options, visit https://groups.google.com/d/optout.
