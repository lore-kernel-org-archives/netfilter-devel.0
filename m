From: Paul Moore <paul@paul-moore.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Mon, 13 Feb 2017 18:50:24 -0500
Message-ID: <CAHC9VhTGJMtg6z-WjW+PYCrEAKdrrKhfJdi3j4DB=91r8XYH4Q@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca> <10185842.hTv0ExFpgc@x2>
 <20170210225445.GS26850@madcap2.tricolour.ca> <3926301.2G9jBBrVEf@x2> <20170213205005.GO26855@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:36410 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdBMXu0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Feb 2017 18:50:26 -0500
Received: by mail-ua0-f170.google.com with SMTP id 96so76248606uaq.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Feb 2017 15:50:25 -0800 (PST)
In-Reply-To: <20170213205005.GO26855@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 13, 2017 at 3:50 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-02-13 12:57, Steve Grubb wrote:
>> On Friday, February 10, 2017 5:54:45 PM EST Richard Guy Briggs wrote:
>> > On 2017-02-10 17:39, Steve Grubb wrote:
>> > > > The alternatives that I currently see are to drop packets for which
>> > > > there is no local process ownership, or to leave the ownership fields
>> > > > unset.>
>> >
>> > > What ownership fields are we talking about?
>> >
>> > The ones you want, auid, pid, ses.  Perhaps I'm using the wrong
>> > terminology.  What technical term is there for the collection of subject
>> > identifiers?
>>
>> Subject attributes.
>
> Ah ok, I'll try to remember to use that term...
>
> Now that you know what I'm talking about, can you go back and answer the
> questions I had about packet "ownership" (which is really packet subject
> attributes)?  If we have that information, how to we include it in the
> message format?  And if we don't have it, do we ignore the packet, or do
> we swing fields out, or do we set those fields to "unset" or do we use
> an auxiliary record?

Packet "ownership" is likely going to be impossible to determine
reliably since in some cases you can't even match a packet to a
socket, let alone a process.  To back up a few messages in this
thread, to Richard's list of things to potentially log:

> helpful         action, hook

I haven't checked, but do we allow setting of an audit key in
NETFILTER_PKT records?  It seems like that might be a good thing for
the userspace tools and would likely make logging the action/hook
unncessary.

> useless?        len

I don't see much point in this.

> helpful         inif, outif, mark

Let's split this into two things: the interfaces and the mark.  I
don't see much value in logging the mark, but I could see some value
in logging the interface.

> useless?        smac, dmac, macproto

Probably useless in the majority of use cases.

> helpful         protocol family

I think we need some clarity on protocol logging; we've got "macproto"
(I assume this is the ethertype, or similar), "protocol family" (I
assume this to be a duplicate of ethertype, e.g. AF_INET), and "proto"
(see below, I assume this to be TCP/UDP/etc.).

> useless?        truncated

Definitely useless.  Only keep this if we need it for some backwards
compatibility.

> helpful         saddr, daddr

Helpful.

> useless?        ipid

Useless.

> helpful         proto
> helpful         sport, dport

Assuming "proto" means the TCP/UDP/etc. then we should treat the
proto/ports as one block; you can't log the ports without logging
"proto".

> useless?        frag
> useless?        truncated

Yes, useless.

> helpful         icmptype, icmpcode

Similar to proto/port above.

> helpful         secmark (I forgot to change it from "obj" to "secmark" in my patch).

We may also want to log the peer label if we are going to log the secmark.

-- 
paul moore
www.paul-moore.com
