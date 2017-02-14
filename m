From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Mon, 13 Feb 2017 19:24:52 -0500
Message-ID: <20170214002452.GT26850@madcap2.tricolour.ca>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
 <10185842.hTv0ExFpgc@x2>
 <20170210225445.GS26850@madcap2.tricolour.ca>
 <3926301.2G9jBBrVEf@x2>
 <20170213205005.GO26855@madcap2.tricolour.ca>
 <CAHC9VhTGJMtg6z-WjW+PYCrEAKdrrKhfJdi3j4DB=91r8XYH4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Paul Moore <paul@paul-moore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751422AbdBNAY4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Feb 2017 19:24:56 -0500
Content-Disposition: inline
In-Reply-To: <CAHC9VhTGJMtg6z-WjW+PYCrEAKdrrKhfJdi3j4DB=91r8XYH4Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-02-13 18:50, Paul Moore wrote:
> On Mon, Feb 13, 2017 at 3:50 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2017-02-13 12:57, Steve Grubb wrote:
> >> On Friday, February 10, 2017 5:54:45 PM EST Richard Guy Briggs wrote:
> >> > On 2017-02-10 17:39, Steve Grubb wrote:
> >> > > > The alternatives that I currently see are to drop packets for which
> >> > > > there is no local process ownership, or to leave the ownership fields
> >> > > > unset.>
> >> >
> >> > > What ownership fields are we talking about?
> >> >
> >> > The ones you want, auid, pid, ses.  Perhaps I'm using the wrong
> >> > terminology.  What technical term is there for the collection of subject
> >> > identifiers?
> >>
> >> Subject attributes.
> >
> > Ah ok, I'll try to remember to use that term...
> >
> > Now that you know what I'm talking about, can you go back and answer the
> > questions I had about packet "ownership" (which is really packet subject
> > attributes)?  If we have that information, how to we include it in the
> > message format?  And if we don't have it, do we ignore the packet, or do
> > we swing fields out, or do we set those fields to "unset" or do we use
> > an auxiliary record?
> 
> Packet "ownership" is likely going to be impossible to determine
> reliably since in some cases you can't even match a packet to a
> socket, let alone a process.  To back up a few messages in this
> thread, to Richard's list of things to potentially log:
> 
> > helpful         action, hook
> 
> I haven't checked, but do we allow setting of an audit key in
> NETFILTER_PKT records?  It seems like that might be a good thing for
> the userspace tools and would likely make logging the action/hook
> unncessary.

Not that I am aware of.  That would be way useful if it were possible.
"AUDIT" is a netfilter target and you can set the type to "accept",
"drop" or "reject".  Similarly, having the sub-chain name would be
useful but that doesn't appear to be available either.  This is why I
used a "mark" in the testsuite to track packets.

> > useless?        len
> 
> I don't see much point in this.
> 
> > helpful         inif, outif, mark
> 
> Let's split this into two things: the interfaces and the mark.  I
> don't see much value in logging the mark, but I could see some value
> in logging the interface.

In fact, the mark I found to be a useful way to track which rule was
involved and I'd be pretty surprised if others don't try to do the same.

> > useless?        smac, dmac, macproto
> 
> Probably useless in the majority of use cases.

How do we deal with the minority of cases where it could be quite useful?

> > helpful         protocol family
> 
> I think we need some clarity on protocol logging; we've got "macproto"
> (I assume this is the ethertype, or similar), "protocol family" (I
> assume this to be a duplicate of ethertype, e.g. AF_INET), and "proto"
> (see below, I assume this to be TCP/UDP/etc.).

Sorry, you are right.  I know that field as "ethertype" which defines
the "protocol family" (network layer protocol, IPv4/6, etc...).  "proto"
is the transport layer protocol.  For some reason, I was thinking
"macproto" was the link layer type, but that's obvious from the media.

> > useless?        truncated
> 
> Definitely useless.  Only keep this if we need it for some backwards
> compatibility.
> 
> > helpful         saddr, daddr
> 
> Helpful.
> 
> > useless?        ipid
> 
> Useless.
> 
> > helpful         proto
> > helpful         sport, dport
> 
> Assuming "proto" means the TCP/UDP/etc. then we should treat the
> proto/ports as one block; you can't log the ports without logging
> "proto".
> 
> > useless?        frag
> > useless?        truncated
> 
> Yes, useless.
> 
> > helpful         icmptype, icmpcode
> 
> Similar to proto/port above.
> 
> > helpful         secmark (I forgot to change it from "obj" to "secmark" in my patch).
> 
> We may also want to log the peer label if we are going to log the secmark.

Ok, noted.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
