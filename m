From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Mon, 13 Feb 2017 12:57:38 -0500
Message-ID: <3926301.2G9jBBrVEf@x2>
References: <20170117052551.GQ3087@madcap2.tricolour.ca> <10185842.hTv0ExFpgc@x2> <20170210225445.GS26850@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Paul Moore <paul@paul-moore.com>, Paul Moore <pmoore@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751935AbdBMR5g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Feb 2017 12:57:36 -0500
In-Reply-To: <20170210225445.GS26850@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday, February 10, 2017 5:54:45 PM EST Richard Guy Briggs wrote:
> On 2017-02-10 17:39, Steve Grubb wrote:
> > > The alternatives that I currently see are to drop packets for which
> > > there is no local process ownership, or to leave the ownership fields
> > > unset.> 
>
> > What ownership fields are we talking about?
> 
> The ones you want, auid, pid, ses.  Perhaps I'm using the wrong
> terminology.  What technical term is there for the collection of subject
> identifiers?

Subject attributes.

 
> > > > I don't think audit should worry about spoofing. Yes it can be done,
> > > > but we should accurately record what was presented to the system.
> > > > Other tools can be employed to watch for arp spoofing and source routed
> > > > packets. Its a bigger problem than just the audit logs.
> > > 
> > > I find this statement a bit surprising given we're trying to find out
> > > who's doing what where.
> > 
> > We're just recording what's presented to the system that meets the rules
> > programmed in.
> 
> I don't quite understand.  Are you saying only display the fields that
> were specifically used in the netfilter rule to trigger the target that
> records a packet?

No. I'm saying we shouldn't do any processing to figure out if we have a 
spoofed or source routed packet. There are other tools that do that kind of 
thing.


> I don't think that's what you want and it isn't easy
> to get without being more invasive in netfilter and swinging fields.
> I'd record the MAC header since it is part of the packet that tells us
> where it came from and where it's going.

Do we really need the MAC header for every event? I really don't think so.

-Steve
