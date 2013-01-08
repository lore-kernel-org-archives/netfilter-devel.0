From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Possible arptables bug.
Date: Tue, 8 Jan 2013 17:30:16 +0100
Message-ID: <20130108163016.GA5062@1984>
References: <201301081032.53926.steven@springl.ukfsn.org>
 <20130108105048.GA14926@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Steven Jan Springl <steven@springl.ukfsn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58065 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab3AHQas (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:30:48 -0500
Content-Disposition: inline
In-Reply-To: <20130108105048.GA14926@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 08, 2013 at 11:50:48AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 08, 2013 at 10:32:53AM +0000, Steven Jan Springl wrote:
> > Hello
> > 
> > arptables-save tries to convert any IP addresses to DNS names.
> > Is this the expected behaviour?
> > 
> > If it is the expected behaviour, is there any way that it can be disabled as
> > arptables-save hangs until the DNS lookup times out if DNS is not available?
> 
> Like iptables, use -n together with -L.

Sorry, I misread your email. You were talking about arptables-save,
not arptables itself.

commit 0d0d618038aa1137d6f373db8ab201f03234959f
Author: Bart De Schuymer <bdschuym@pandora.be>
Date:   Sun Oct 10 17:30:38 2010 +0000

    - use -n so that IP addresses are resolved (similar to iptables'
      behaviour)

It seems that change is already in the git tree.

Upgrade to current git snapshot or wait for that release that Bart
promised.
