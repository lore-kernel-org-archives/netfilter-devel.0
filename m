From: Willy Tarreau <w@1wt.eu>
Subject: Re: linux-2.4 CLASSIFY patch.
Date: Wed, 5 Mar 2008 17:58:30 +0100
Message-ID: <20080305165830.GA2668@1wt.eu>
References: <Pine.LNX.4.64.0803051139270.26467@cube> <47CE8033.9020404@trash.net> <Pine.LNX.4.64.0803051354270.28409@cube> <47CEAF23.3050002@trash.net> <Pine.LNX.4.64.0803051558220.30939@cube> <47CECE33.5030508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Unknown <borg@uu3.net>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 1wt.eu ([62.212.114.60]:2260 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760969AbYCEQ6k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:58:40 -0500
Content-Disposition: inline
In-Reply-To: <47CECE33.5030508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 05, 2008 at 05:45:39PM +0100, Patrick McHardy wrote:
> Unknown wrote:
> >CLASSIFY sources has been taken from:
> >https://svn.netfilter.org/netfilter/branches/patch-o-matic-ng/
> >linux-2.6.11/CLASSIFY
> >
> >On Wed, 5 Mar 2008, Patrick McHardy wrote:
> >>Unknown wrote:
> >>>On Wed, 5 Mar 2008, Patrick McHardy wrote:
> >>>>If you send a patch against 2.4 I can review and ACK it.
> >>>
> >>>Done.
> >>>
> >>>Patch created against latest stable 2.4 tree: 2.4.36.2
> >>>ftp://borg.uu3.net/home/borg/patch/linux-2.4-classify.patch
> >>
> >>
> >>Please send as attachment and CC netfilter-devel@vger.kernel.org
> >>and Willy Tareau.
> >>
> 
> 
> > diff -ubrN linux-2.4.36.2.orig/Documentation/Configure.help 
> linux-2.4.36.2/Documentation/Configure.help
> > --- linux-2.4.36.2.orig/Documentation/Configure.help	Sun Feb 24 
> 21:38:03 2008
> > +++ linux-2.4.36.2/Documentation/Configure.help	Wed Mar  5 13:48:19 
> 2008
> > ...
> 
> Looks OK to me. In case Willy really wants to include it:
> 
> Acked-by: Patrick McHardy <kaber@trash.net>

OK I'm fine with it, I'll merge it.

Thanks guys,
Willy

