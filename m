From: Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] netfilter: conntrack: use power efficient workqueue
Date: Mon, 6 Nov 2017 17:33:43 +0100
Message-ID: <CAKfTPtAXJsq4cYxyYbeBqYx8W9v8MBEdHqkxM4DfyrYMr+GPSg@mail.gmail.com>
References: <1509635767-12253-1-git-send-email-vincent.guittot@linaro.org>
 <20171106143155.GA8738@salvia> <20171106145632.GA20091@salvia>
 <CAKfTPtDXb5x23UzapinOo=Wg8fPf0G-sJoD1Dpw15e0sMteLEQ@mail.gmail.com> <20171106152533.GA27072@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:48029 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753827AbdKFQeE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 11:34:04 -0500
Received: by mail-io0-f194.google.com with SMTP id h70so16304814ioi.4
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Nov 2017 08:34:04 -0800 (PST)
In-Reply-To: <20171106152533.GA27072@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 November 2017 at 16:25, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Nov 06, 2017 at 04:15:42PM +0100, Vincent Guittot wrote:
>> Hi Pablo,
>>
>> On 6 November 2017 at 15:56, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Mon, Nov 06, 2017 at 03:31:55PM +0100, Pablo Neira Ayuso wrote:
>> >> On Thu, 2 Nov 2017 15:16:07 +0100 Vincent Guittot <vincent.guittot@linaro.org> wrote:
>> >> > conntrack uses the bounded system_long_wq workqueue for its works that
>> >> > don't have to run on the cpu they have been queued.  Using bounded
>> >> > workqueue prevents the scheduler to make smart decision about the best
>> >> > place to schedule the work.
>> >> >
>> >> > This patch replaces system_long_wq with system_power_efficient_wq.
>> >> > the work stays bounded to a cpu by default unless the
>> >> > CONFIG_WQ_POWER_EFFICIENT is enable. In the latter case, the work can
>> >> > be scheduled on the best cpu from a power or a performance point of
>> >> > view.
>> >>
>> >> Applied, thanks.
>> >
>> > I'm stepping back. According to what I'm reading
>> > system_power_efficient_wq becomes system_wq when disabled, which is
>> > not semantically the same as system_long_wq that we have now.
>>
>> When disabled, system_power_efficient_wq behaves like system_wq (and
>> system_long_wq) as the worqueue are bounded to a cpu but It stays a
>> different workqueue.
>>
>> > My concern is that the conntrack garbage collector may run for quite a
>> > bit of time. Did you test this with a large conntrack table full of
>>
>> No, I haven't done specific tests with a large conntrack table full of entries.
>>
>> There is no system_power_efficient_long_wq. I was not convinced that
>> we should create one that's why I have used system_power_efficient_wq
>
> My concern is that this garbage collector may run intensively on busy
> conntrack tables to get rid of expired entries, so my question is if
> switching from system_long_wq to system_wq is a real issue.

system_long_wq and system_wq have the same configuration. They are
just named differently so people will use one or the other but they
behave exactly the same.
Then system_power_efficient_wq is a 3rd workqueue that behaves like
system_wq and system_long_wq when CONFIG_WQ_POWER_EFFICIENT is disable
but uses ubounded workqueue when enabled

I don't think that switching from system_long_wq to
system_power_efficient_wq is an issue.
I haven't seen any problem so far but i'm haven't done specific tests
that stress the system with a large conntrack table full of entries.
Furthermore, these workqueue use default max active context (256)
which means that other work should be able to run.

Regards,
Vincent


>
> Thanks.
