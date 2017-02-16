From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Thu, 16 Feb 2017 16:24:23 -0500
Message-ID: <20170216212423.GL21519@madcap2.tricolour.ca>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
 <3926301.2G9jBBrVEf@x2>
 <20170213205005.GO26855@madcap2.tricolour.ca>
 <3292833.iEpdVtO8mH@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932975AbdBPVY1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 16:24:27 -0500
Content-Disposition: inline
In-Reply-To: <3292833.iEpdVtO8mH@x2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-02-14 16:31, Steve Grubb wrote:
> On Monday, February 13, 2017 3:50:05 PM EST Richard Guy Briggs wrote:
> > > > > > The alternatives that I currently see are to drop packets for which
> > > > > > there is no local process ownership, or to leave the ownership
> > > > > > fields unset.
> > > > > 
> > > > > What ownership fields are we talking about?
> > > > 
> > > > The ones you want, auid, pid, ses.  Perhaps I'm using the wrong
> > > > terminology.  What technical term is there for the collection of subject
> > > > identifiers?
> > > 
> > > Subject attributes.
> > 
> > Ah ok, I'll try to remember to use that term...
> > 
> > Now that you know what I'm talking about, can you go back and answer the
> > questions I had about packet "ownership" (which is really packet subject
> > attributes)? 
> 
> The format for subject attributes would be:
> pid, uid, auid, ses, subj, comm, exe, ...then whatever else you want to add
> 
> This also goes for the netfilter_cfg events.

Ok, this I can deal with.  Thank you.

> > If we have that information, how to we include it in the
> > message format?  And if we don't have it, do we ignore the packet, or do
> > we swing fields out, or do we set those fields to "unset" or do we use
> > an auxiliary record?
> 
> If you have this for the majority of events, I'd say leave it unset when you 
> don't. We really don't care about packets that simply transit through the 
> system. Also, I suppose it depends on what kind of packet it is. For example, 
> a icmp echo sent to the machine that is blocked is obviously not going to have 
> an owner. But one originating in the machine heading out should.

I'll add them to the message format and leave them unset if we have no
information.

The way that the AUDIT target is used by users is going to determine
what is the majority of events.  The user has complete freedom to set up
rules such that all of them only log packets transiting the system, but
this is clearly not the intent of this record.

This sounds like it deserves a blog post to clarify the intent and the
limitations and/or an update to the xt_AUDIT manpage.

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
