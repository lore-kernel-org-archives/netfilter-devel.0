From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Thu, 16 Feb 2017 17:36:12 -0500
Message-ID: <20170216223612.GM21519@madcap2.tricolour.ca>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
 <10185842.hTv0ExFpgc@x2>
 <20170210225445.GS26850@madcap2.tricolour.ca>
 <3926301.2G9jBBrVEf@x2>
 <20170213205005.GO26855@madcap2.tricolour.ca>
 <CAHC9VhTGJMtg6z-WjW+PYCrEAKdrrKhfJdi3j4DB=91r8XYH4Q@mail.gmail.com>
 <20170214002452.GT26850@madcap2.tricolour.ca>
 <CAHC9VhTZZN8u1CmVVSn_tmirvY+nGjry1PEcQFM+a-DhcLgoBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Paul Moore <paul@paul-moore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933507AbdBPWgP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 17:36:15 -0500
Content-Disposition: inline
In-Reply-To: <CAHC9VhTZZN8u1CmVVSn_tmirvY+nGjry1PEcQFM+a-DhcLgoBg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-02-15 19:32, Paul Moore wrote:
> On Mon, Feb 13, 2017 at 7:24 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2017-02-13 18:50, Paul Moore wrote:
> >> On Mon, Feb 13, 2017 at 3:50 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> 
> ...
> 
> >> > helpful         action, hook
> >>
> >> I haven't checked, but do we allow setting of an audit key in
> >> NETFILTER_PKT records?  It seems like that might be a good thing for
> >> the userspace tools and would likely make logging the action/hook
> >> unncessary.
> >
> > Not that I am aware of.  That would be way useful if it were possible.
> > "AUDIT" is a netfilter target and you can set the type to "accept",
> > "drop" or "reject".  Similarly, having the sub-chain name would be
> > useful but that doesn't appear to be available either.  This is why I
> > used a "mark" in the testsuite to track packets.
> 
> I've been thinking about this off and on and I think you are on to
> something here ... the netfilter mark is very similar to what we do
> with the audit keys and the audit-folk on this thread already know how
> helpful audit keys can be for associating records with a specific [set
> of] audit rules; I'm thinking we should treat the netfilter mark the
> same way, after all, this is very much in keeping with how
> netfilter/iptables uses the mark data.

I felt like I was kind of cheating to use it, but no other fine-grained
method was evident to me when I wrote that test script.  In a test
script it is a controlled environment with no other conflicting users.

My thoughts were that use of it as a key for tracking audit events
itself might not be as viable due to other uses of the nfmark.

What it comes down to is simply spending a bit more careful design
effort to have the uses of nfmark co-exist since I don't see any
inherent conflicts.

>  In an effort to simplify
> things greatly for the NETFILTER_PKT record I'm going to offer the
> following suggestion:
> 
> * Limit NETFILTER_PKT fields to only those present in the IPv4/IPv6
> header, e.g. src/dest addresses and next level protocol, and the
> netfilter mark.

(I'd start with: mark, saddr, daddr, proto)

That seems a bit oversimplified, requiring a lot more effort and lists
of rules to track down different application-layer protocols (ports).

This reminds me of Rusty's sig a while back "Premature optmztion is rt
of all evl."  ;-)

There are a limited number of actions, hooks, interfaces and protocol
families, so this seems plausibly reasonable to ditch in favour of
nfmark, but all of these would just need to be re-coded in the nfmark if
needed, although the typical assumption about number of interfaces may
be naive for those users who may find this sort of auditing very useful.
(I'm thinking of network appliances.)

It would be tempting to just keep the reports of data packets
(TCP/UDP...) and forego the control packets (ICMP) but that somehow
seems like cheating and irresponsible.

I'm still inclined to keep the 4 message types proposed, minimum data
and control, then the other two as more general catchers.

> * Teach ausearch and the other relevant audit userspace tools to
> search on the netfilter mark much like they currently search on the
> audit key.

That sounds potentially useful, and until that happens, a user could
pull together a perl or python script to deal with them.

> This puts a reasonable bound on the fields in the NETFILTER_PKT record
> and insulates us from protocol specifics (both very desirable things);

Steve has requested the subject attributes which prefixes 7 fields.

If you are ditching port numbers, then it seems reasonable to ditch IP
addresses too, at which point all we keep is the subject attributes and
the nfmark which could be argued should be enough.  What's the point in
keeping the protocol if we don't keep the source and destination ports?

> I also think we should be able to do this without having to introduce
> a new record, e.g. NETFILTER_PKT2 (another big win).  Any additional
> packet information can be conveyed by the netfilter mark and careful
> netfilter rule construction.

I'm sure sure either way if we are absolved from introducing a new
record type since we are changing the existing one.

> What do you think Richard?

There's my thoughts.  I'd love to get some from users.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
