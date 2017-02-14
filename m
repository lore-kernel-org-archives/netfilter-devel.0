From: Paul Moore <paul@paul-moore.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Tue, 14 Feb 2017 16:06:53 -0500
Message-ID: <CAHC9VhQfwgcc4KquQm3TtNm-GLS+4YpoF6NkoZ8wzVopAn4Now@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca> <10185842.hTv0ExFpgc@x2>
 <20170210225445.GS26850@madcap2.tricolour.ca> <3926301.2G9jBBrVEf@x2>
 <20170213205005.GO26855@madcap2.tricolour.ca> <CAHC9VhTGJMtg6z-WjW+PYCrEAKdrrKhfJdi3j4DB=91r8XYH4Q@mail.gmail.com>
 <20170214002452.GT26850@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:36194 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdBNVGz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Feb 2017 16:06:55 -0500
Received: by mail-vk0-f44.google.com with SMTP id t8so88090140vke.3
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Feb 2017 13:06:54 -0800 (PST)
In-Reply-To: <20170214002452.GT26850@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 13, 2017 at 7:24 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-02-13 18:50, Paul Moore wrote:
>> On Mon, Feb 13, 2017 at 3:50 PM, Richard Guy Briggs <rgb@redhat.com> wrote:

...

>> > useless?        smac, dmac, macproto
>>
>> Probably useless in the majority of use cases.
>
> How do we deal with the minority of cases where it could be quite useful?

First you first need to show me why I should care about this, in other
words, why *must* you have the fields in the audit record.

>> > helpful         secmark (I forgot to change it from "obj" to "secmark" in my patch).
>>
>> We may also want to log the peer label if we are going to log the secmark.
>
> Ok, noted.

Please note well the "*if*" portion in the above statement.  I'm not
overly convinced that either field is all that useful in the majority
of cases.

-- 
paul moore
www.paul-moore.com
