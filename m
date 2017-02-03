From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH] audit: normalize NETFILTER_PKT
Date: Fri, 3 Feb 2017 18:44:16 -0500
Message-ID: <CAHC9VhQu7sG_mMWjhYC=k-Kr_YQmrOyMboR3mckuBdSqsFuboQ@mail.gmail.com>
References: <e3af1eaaf566af375dbc79abd4535e86f2fc8a6d.1485522479.git.rgb@redhat.com>
 <20170130155330.55a91c7d@ivy-bridge> <20170130151355.GS3087@madcap2.tricolour.ca>
 <20170131125723.GA27141@madcap2.tricolour.ca> <20170131171326.55d414bf@ivy-bridge>
 <20170131194419.GE27141@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:35135 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752938AbdBCXoS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 18:44:18 -0500
Received: by mail-ua0-f170.google.com with SMTP id y9so25315158uae.2
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Feb 2017 15:44:17 -0800 (PST)
In-Reply-To: <20170131194419.GE27141@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 31, 2017 at 2:44 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-01-31 17:13, Steve Grubb wrote:

...

>> I was curious about something. Auparse is trying to interpret the
>> icmptype field for every event. This is not good. Which fields are
>> valid for each kind of packet? Are there fields valid for all packets?
>> Is the icmptype/code the only ones that don't apply in all cases?
>
> Ok, this is important to know...  You sound surprised.  So if that field
> isn't valid for all cases of that event, then the event should be split
> or the "unset" value should be used as a hint to ignore it.
>
> This was the point of my earlier posting:
>         https://www.redhat.com/archives/linux-audit/2017-January/msg00074.html
> There are still a number of questions from that thread that had no
> reply.  Answering those questions would help inform this discussion, so
> if you could answer some of those questions in that first thread, I'd
> have a better chance of understanding what are the limitations of the
> parser and design/work around them.
>
> There is no packet for which all fields are valid.  This is why using
> "unset" values in those fields was suggested, seemed to be accepted in
> discussion, and implemented.

...

> Swinging fields in and out makes it very handy to use one message type
> for all of them and can save precious disk bandwidth, but the point was
> to normalize these messages.  Is that still realistic and necessary?  If
> so, we're trying to find a balance between message type explosion and
> disk bandwidth.
>
> We either need to make this fine-grained, ignore fields that aren't
> valid for that type, or swing fields in and out.  Or maybe I have missed
> something fundamental, such as the presence of subsequent fields depends
> on the values of previous fields?

I'm still trying to understand what purpose this record actually
serves, and what requirements may exist.  In an earlier thread
somewhere Steve mentioned some broad requirements around data
import/export, and I really wonder if the NETFILTER_PKT record
provides anything useful here when it really isn't connecting the
traffic to the sender/receiver without a lot of additional logging and
post-processing smarts.  If you were interested in data import/export
I think auditing the socket syscalls would provide a much more useful
set of records in the audit log.

Considering that one of the primary motivations for the audit
subsystem is to enable compliance with various security
specifications, let's get the ones we know about listed in this thread
and then figure out how best to meet those requirements.

-- 
paul moore
www.paul-moore.com
