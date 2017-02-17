From: Paul Moore <paul@paul-moore.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Fri, 17 Feb 2017 18:04:30 -0500
Message-ID: <CAHC9VhTTaPB_fO01F+rV76fAPbT2pdGM2uM7H=WXc1U7RCpybA@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca> <10185842.hTv0ExFpgc@x2>
 <20170210225445.GS26850@madcap2.tricolour.ca> <3926301.2G9jBBrVEf@x2>
 <20170213205005.GO26855@madcap2.tricolour.ca> <CAHC9VhTGJMtg6z-WjW+PYCrEAKdrrKhfJdi3j4DB=91r8XYH4Q@mail.gmail.com>
 <20170214002452.GT26850@madcap2.tricolour.ca> <CAHC9VhTZZN8u1CmVVSn_tmirvY+nGjry1PEcQFM+a-DhcLgoBg@mail.gmail.com>
 <20170216223612.GM21519@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34241 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964780AbdBQXFb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2017 18:05:31 -0500
Received: by mail-vk0-f54.google.com with SMTP id r136so37593531vke.1
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2017 15:04:32 -0800 (PST)
In-Reply-To: <20170216223612.GM21519@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 16, 2017 at 5:36 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-02-15 19:32, Paul Moore wrote:
>> On Mon, Feb 13, 2017 at 7:24 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> > On 2017-02-13 18:50, Paul Moore wrote:
>> >> On Mon, Feb 13, 2017 at 3:50 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
>>
>> ...
>>
>> >> > helpful         action, hook
>> >>
>> >> I haven't checked, but do we allow setting of an audit key in
>> >> NETFILTER_PKT records?  It seems like that might be a good thing for
>> >> the userspace tools and would likely make logging the action/hook
>> >> unncessary.
>> >
>> > Not that I am aware of.  That would be way useful if it were possible.
>> > "AUDIT" is a netfilter target and you can set the type to "accept",
>> > "drop" or "reject".  Similarly, having the sub-chain name would be
>> > useful but that doesn't appear to be available either.  This is why I
>> > used a "mark" in the testsuite to track packets.
>>
>> I've been thinking about this off and on and I think you are on to
>> something here ... the netfilter mark is very similar to what we do
>> with the audit keys and the audit-folk on this thread already know how
>> helpful audit keys can be for associating records with a specific [set
>> of] audit rules; I'm thinking we should treat the netfilter mark the
>> same way, after all, this is very much in keeping with how
>> netfilter/iptables uses the mark data.
>
> I felt like I was kind of cheating to use it, but no other fine-grained
> method was evident to me when I wrote that test script.  In a test
> script it is a controlled environment with no other conflicting users.
>
> My thoughts were that use of it as a key for tracking audit events
> itself might not be as viable due to other uses of the nfmark.
>
> What it comes down to is simply spending a bit more careful design
> effort to have the uses of nfmark co-exist since I don't see any
> inherent conflicts.

I think it is safe to say that anyone who is going to the trouble of
using NETFILTER_PKT is going to have a well considered security
configuration.  I don't view using the nfmark as a shorthand for audit
to help identify complex netfilter matches to be a major ask in these
situations, and it seems in keeping with the intent of the nfmark
concept.

>>  In an effort to simplify
>> things greatly for the NETFILTER_PKT record I'm going to offer the
>> following suggestion:
>>
>> * Limit NETFILTER_PKT fields to only those present in the IPv4/IPv6
>> header, e.g. src/dest addresses and next level protocol, and the
>> netfilter mark.
>
> (I'd start with: mark, saddr, daddr, proto)

Yeah, that's what I said ;)

> That seems a bit oversimplified, requiring a lot more effort and lists
> of rules to track down different application-layer protocols (ports).

I relies more heavily on the nfmark as discussed above.

> This reminds me of Rusty's sig a while back "Premature optmztion is rt
> of all evl."  ;-)

Perhaps this is being nitpicky, but you optimize something for a given
set of requirements, something which we are lacking here.  This isn't
an optimization, but rather a simplified approach brought about by a
lack of requirements.

Right now the only real requirement we have is that Steve would like
something a bit more predictable in the NETFILTER_PKT record
<insert-my-usual-comments-about-the-audit-kernel/userspace-API-being-a-pile-of-garbage>.
While we have indications that people are using this in the wild, they
aren't letting their voices be heard here, or anywhere else that we
can see, so I'd like to focus on a solution that satisfies Steve and
doesn't burden us in the future in case we have to start adding
additional fields/records.  This is why I'm thinking of limiting us to
just the IP layer information + the nfmark; this should provide a
fairly rich capability without saddling us with a lot of baggage to
worry about in the future.  I do agree that it does add some
administrative setup cost, but as I said earlier, those admins who
make use of this are likely already used to dealing with a high setup
cost.

I *really* don't want to add a bunch of new records and fields for a
bit of functionality with uncertain usage and requirements; that
almost never works out well for anyone, especially those who have to
maintain that crap for the long term.

> There are a limited number of actions, hooks, interfaces and protocol
> families, so this seems plausibly reasonable to ditch in favour of
> nfmark, but all of these would just need to be re-coded in the nfmark if
> needed, although the typical assumption about number of interfaces may
> be naive for those users who may find this sort of auditing very useful.
> (I'm thinking of network appliances.)

... this is a good time to point out that trying to arrive at a set of
fields that fully satisfies every use case that comes our way is going
to be impossible at worst, and increasingly frustrating at best.  I
think we are always going to need to rely on the nfmark to some
extent, let's admit that now and make our lives easier; if we hear
from users (e.g. actual requirements!) in the future we can always add
new fields/records to make their lives easier.

>> * Teach ausearch and the other relevant audit userspace tools to
>> search on the netfilter mark much like they currently search on the
>> audit key.
>
> That sounds potentially useful, and until that happens, a user could
> pull together a perl or python script to deal with them.

Granted I'm stubborn and ornery, but I still do most of lot of log
spelunking with grep and friends.

-- 
paul moore
www.paul-moore.com
