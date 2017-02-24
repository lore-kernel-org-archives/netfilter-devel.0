From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH V2] audit: normalize NETFILTER_PKT
Date: Fri, 24 Feb 2017 00:56:04 -0500
Message-ID: <CAHC9VhQK72isWRGcxm6LzobDZ+ovDJq4woO0rQV9eSXacMCZYg@mail.gmail.com>
References: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>
 <20170223052015.GE11144@breakpoint.cc> <20170223155156.GL18258@madcap2.tricolour.ca>
 <CAHC9VhQwSH-CjWeaPJZhBpK2+vh8YqfG6kVaMCis--WrZCopEQ@mail.gmail.com>
 <20170223170431.GM18258@madcap2.tricolour.ca> <20170223170647.GA5277@breakpoint.cc>
 <20170223172030.GO18258@madcap2.tricolour.ca> <20170224015928.GB5277@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:35014 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbdBXF4G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Feb 2017 00:56:06 -0500
Received: by mail-ua0-f179.google.com with SMTP id 40so7557543uau.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 21:56:05 -0800 (PST)
In-Reply-To: <20170224015928.GB5277@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 23, 2017 at 8:59 PM, Florian Westphal <fw@strlen.de> wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
>> > Not following, sorry, are you saying users can/should use -j MARK
>> > somehow?
>>
>> Part of the discussed design and rationale for stripping many of the
>> vanishing fields is that when setting up netfilter rules to invoke the
>> AUDIT target, an accompanying nf mark should be used to indicate which
>> rule caught that packet, since the chain name and rule number aren't
>> available to the audit target.  We would use the nf mark similarly to
>> the way we use a rule key in the audit rules (see man auditctl).
>
> I see.  While this works, nfmark might already be used for other
> purposes such as policy routing, so you might need an extra cookie
> that can be passed to the AUDIT target instead.

Yes, we discussed the idea that the nfmark field already serves many
purposes, most of which are related to labeling traffic flows.  I
agree that using the nfmark may complicate some configurations, but
using it in this manner seems to be in keeping with the ideas behind
nfmark (from what I can tell).  As for the configuration complexity, I
think it is safe to say that any users of the NETFILTER_PKT record
already have a sufficiently complex system configuration and the added
complexity here may not be significant; in fact, the existing nfmark
configuration may be helpful in identifying traffic categories such
that no changes need to be made.

-- 
paul moore
www.paul-moore.com
