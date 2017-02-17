From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Thu, 16 Feb 2017 21:24:56 -0500
Message-ID: <20170217022456.GA9515@madcap2.tricolour.ca>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
 <10185842.hTv0ExFpgc@x2>
 <20170210225445.GS26850@madcap2.tricolour.ca>
 <3926301.2G9jBBrVEf@x2>
 <20170213205005.GO26855@madcap2.tricolour.ca>
 <CAHC9VhTGJMtg6z-WjW+PYCrEAKdrrKhfJdi3j4DB=91r8XYH4Q@mail.gmail.com>
 <20170214002452.GT26850@madcap2.tricolour.ca>
 <CAHC9VhTZZN8u1CmVVSn_tmirvY+nGjry1PEcQFM+a-DhcLgoBg@mail.gmail.com>
 <20170216223612.GM21519@madcap2.tricolour.ca>
 <CAHC9VhSZ9AkD5OUKg3JX9R83Aq6Afa8EUXFVuNPT+QLPgf3G5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Paul Moore <paul@paul-moore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753968AbdBQCZA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 21:25:00 -0500
Content-Disposition: inline
In-Reply-To: <CAHC9VhSZ9AkD5OUKg3JX9R83Aq6Afa8EUXFVuNPT+QLPgf3G5Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-02-16 20:57, Paul Moore wrote:
> [NOTE: I'll respond back to the other part of your email later but I'm
> running out of time in the day and this was a quick but important
> response]
> 
> On Thu, Feb 16, 2017 at 5:36 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > Steve has requested the subject attributes which prefixes 7 fields.
> 
> I already commented on this earlier in this thread - or some other
> related thread, I've lost track, but both you and Steve were on the
> To/CC line - last time I checked, you can't reliably link packets to
> the sender/subject in the netfilter hooks (I'll be shocked if this has
> changed).  The best you can do in some cases is to link the packet to
> the socket, and that isn't going to help you.

Ok, thanks for this clarification.  Maybe I'm mis-remembering what user
information is available in software interrupts rather than user
context.  This will need more investigation...

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
