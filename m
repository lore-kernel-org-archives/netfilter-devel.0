From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 13:31:22 +0100
Message-ID: <20080227123122.GA22353@rere.qmqm.pl>
References: <20080225094951.5bd89c9c@extreme> <47C54F14.4010709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([86.63.132.164]:39363 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbYB0MiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:38:03 -0500
Content-Disposition: inline
In-Reply-To: <47C54F14.4010709@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 27, 2008 at 12:52:52PM +0100, Patrick McHardy wrote:
> Stephen Hemminger wrote:
> >Is there any strong reason why checking the status of iptables is 
> >restricted?
> >
> >Vyatta makes a distribution for routers. In our case, we use a non-root 
> >account
> >for operator commands, and some of the commands are about querying 
> >iptables status.
> >It seems to be less risky to just fix the kernel to allow non-root user to 
> >query rules
> >than the current script that uses sudo. Another alternative would be 
> >building a special
> >restricted command that could be setuid root, but just changing the kernel 
> >seems easiest.
> I always thought of it as a privacy thing, similar to restricting
> /proc/net/nf_conntrack. But since iptables rules usually don't
> allow you to determine active connections just from the packet
> counters that might be overkill. So I don't see any real harm
> in allowing users to list the ruleset.

At least for iptables, reading of iptables status can be done by making
iptables-save setuid-root. So I think no kernel patching is necessary.

 -- Michal Miroslaw
