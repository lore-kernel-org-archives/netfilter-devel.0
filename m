From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH V3] audit: normalize NETFILTER_PKT
Date: Fri, 3 Mar 2017 08:56:12 -0500
Message-ID: <CAHC9VhQ-n3tvZrZT4b2vmJCZ-qoi8sXBjrOR0YmBV+Zu6mJyXw@mail.gmail.com>
References: <CAHC9VhTUSz-tyPyZ7PJAH08sfhuACeUTkEKEnnwM_axQ4UdorQ@mail.gmail.com>
 <20170301162802.GV18258@madcap2.tricolour.ca> <CAHC9VhTHfyPR-yj4kOAJBeU4D1=o4Uu-=S_STvQoj4OAr9Y-mQ@mail.gmail.com>
 <20170301223447.GA18258@madcap2.tricolour.ca> <CAHC9VhRGSzea_c9Gg-Z3gr8cu2UQA9DhNtba0tf9AShoNakxzw@mail.gmail.com>
 <20170303020007.GF18258@madcap2.tricolour.ca> <CAHC9VhRoy1TR46ZLfzLB1wzOq=VZfX-RnG=7ogVP1Xphk=qtBg@mail.gmail.com>
 <20170303115416.GH18258@madcap2.tricolour.ca> <20170303124526.GC29213@breakpoint.cc>
 <CAHC9VhQNEw4r00Ht-DsQc_t5TYpz395VrT=qGOK5UvxjA7rmRg@mail.gmail.com> <20170303132201.GF29213@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:33044 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdCCN4O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 08:56:14 -0500
Received: by mail-ua0-f180.google.com with SMTP id c11so63888454uaa.0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Mar 2017 05:56:13 -0800 (PST)
In-Reply-To: <20170303132201.GF29213@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 3, 2017 at 8:22 AM, Florian Westphal <fw@strlen.de> wrote:
> Paul Moore <paul@paul-moore.com> wrote:
>> On Fri, Mar 3, 2017 at 7:45 AM, Florian Westphal <fw@strlen.de> wrote:
>> > Richard Guy Briggs <rgb@redhat.com> wrote:
>> >> > Perhaps I'm missing something here, but let me ask again, how does
>> >> > userspace distinguish between an unset nfmark and a nfmark of
>> >> > 0xffffffff?
>> >>
>> >> It can't.
>> >
>> > It can if you log it as 0, as I asked in patch 1 review.
>> >
>> > (You wouldn't log sk uid of 0 as -1 either, would you?)
>>
>> I want to see the code able to handle the full range of nfmark values
>> as well as the unset case; if that means we need to tweak userspace a
>> bit, please work with Steve on that.
>
> There is no 'unset nfmark'.  Its just a 32bit integer.

Yes, my apologies, this thread has dragged on so long I muddled the
details in my mind ... here is what I'm trying to get at, Richard's
latest patch (unless I've missed one in my inbox) has the following
line:

  audit_log_format(ab, "mark=%#x", skb->mark ?: -1);

... which I believe to be incorrect.  I was trying to lead Richard
along to that same realization, but it would appear I'm not having
much success, so to put it bluntly, here is what I want that line to
look like:

  audit_log_format(ab, "mark=%#x", skb->mark);

-- 
paul moore
www.paul-moore.com
