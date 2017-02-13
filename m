From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Mon, 13 Feb 2017 15:50:05 -0500
Message-ID: <20170213205005.GO26855@madcap2.tricolour.ca>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
 <10185842.hTv0ExFpgc@x2>
 <20170210225445.GS26850@madcap2.tricolour.ca>
 <3926301.2G9jBBrVEf@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752444AbdBMUuJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Feb 2017 15:50:09 -0500
Content-Disposition: inline
In-Reply-To: <3926301.2G9jBBrVEf@x2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-02-13 12:57, Steve Grubb wrote:
> On Friday, February 10, 2017 5:54:45 PM EST Richard Guy Briggs wrote:
> > On 2017-02-10 17:39, Steve Grubb wrote:
> > > > The alternatives that I currently see are to drop packets for which
> > > > there is no local process ownership, or to leave the ownership fields
> > > > unset.> 
> >
> > > What ownership fields are we talking about?
> > 
> > The ones you want, auid, pid, ses.  Perhaps I'm using the wrong
> > terminology.  What technical term is there for the collection of subject
> > identifiers?
> 
> Subject attributes.

Ah ok, I'll try to remember to use that term...

Now that you know what I'm talking about, can you go back and answer the
questions I had about packet "ownership" (which is really packet subject
attributes)?  If we have that information, how to we include it in the
message format?  And if we don't have it, do we ignore the packet, or do
we swing fields out, or do we set those fields to "unset" or do we use
an auxiliary record?

> > > > > I don't think audit should worry about spoofing. Yes it can be done,
> > > > > but we should accurately record what was presented to the system.
> > > > > Other tools can be employed to watch for arp spoofing and source routed
> > > > > packets. Its a bigger problem than just the audit logs.
> > > > 
> > > > I find this statement a bit surprising given we're trying to find out
> > > > who's doing what where.
> > > 
> > > We're just recording what's presented to the system that meets the rules
> > > programmed in.
> > 
> > I don't quite understand.  Are you saying only display the fields that
> > were specifically used in the netfilter rule to trigger the target that
> > records a packet?
> 
> No. I'm saying we shouldn't do any processing to figure out if we have a 
> spoofed or source routed packet. There are other tools that do that kind of 
> thing.

I never suggested that.  I only suggested including that information so
that some other tool actually has the information to work with.

> > I don't think that's what you want and it isn't easy
> > to get without being more invasive in netfilter and swinging fields.
> > I'd record the MAC header since it is part of the packet that tells us
> > where it came from and where it's going.
> 
> Do we really need the MAC header for every event? I really don't think so.

It certainly makes my job simpler to just ignore the MAC header and
avoid complicating things, but if I were a network admin and a packet
came in that I wasn't expecting because of other network rules that had
been set up to prevent it, I'd want more information to figure out why.

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
