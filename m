From: Paul Moore <paul@paul-moore.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Wed, 15 Feb 2017 19:32:51 -0500
Message-ID: <CAHC9VhTZZN8u1CmVVSn_tmirvY+nGjry1PEcQFM+a-DhcLgoBg@mail.gmail.com>
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
Received: from mail-ua0-f174.google.com ([209.85.217.174]:35989 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753946AbdBPAcx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 19:32:53 -0500
Received: by mail-ua0-f174.google.com with SMTP id 96so1592867uaq.3
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 16:32:52 -0800 (PST)
In-Reply-To: <20170214002452.GT26850@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 13, 2017 at 7:24 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-02-13 18:50, Paul Moore wrote:
>> On Mon, Feb 13, 2017 at 3:50 PM, Richard Guy Briggs <rgb@redhat.com> wrote:

...

>> > helpful         action, hook
>>
>> I haven't checked, but do we allow setting of an audit key in
>> NETFILTER_PKT records?  It seems like that might be a good thing for
>> the userspace tools and would likely make logging the action/hook
>> unncessary.
>
> Not that I am aware of.  That would be way useful if it were possible.
> "AUDIT" is a netfilter target and you can set the type to "accept",
> "drop" or "reject".  Similarly, having the sub-chain name would be
> useful but that doesn't appear to be available either.  This is why I
> used a "mark" in the testsuite to track packets.

I've been thinking about this off and on and I think you are on to
something here ... the netfilter mark is very similar to what we do
with the audit keys and the audit-folk on this thread already know how
helpful audit keys can be for associating records with a specific [set
of] audit rules; I'm thinking we should treat the netfilter mark the
same way, after all, this is very much in keeping with how
netfilter/iptables uses the mark data.  In an effort to simplify
things greatly for the NETFILTER_PKT record I'm going to offer the
following suggestion:

* Limit NETFILTER_PKT fields to only those present in the IPv4/IPv6
header, e.g. src/dest addresses and next level protocol, and the
netfilter mark.
* Teach ausearch and the other relevant audit userspace tools to
search on the netfilter mark much like they currently search on the
audit key.

This puts a reasonable bound on the fields in the NETFILTER_PKT record
and insulates us from protocol specifics (both very desirable things);
I also think we should be able to do this without having to introduce
a new record, e.g. NETFILTER_PKT2 (another big win).  Any additional
packet information can be conveyed by the netfilter mark and careful
netfilter rule construction.

What do you think Richard?

-- 
paul moore
www.paul-moore.com
