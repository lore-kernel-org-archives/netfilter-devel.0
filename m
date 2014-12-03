From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 01/14] netfilter: ipset: Support updating extensions when
 the set is full
Date: Wed, 3 Dec 2014 12:56:23 +0100
Message-ID: <20141203115623.GA14834@salvia>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1417373825-3734-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20141202184644.GF4504@salvia>
 <20141202185043.GA5074@salvia>
 <alpine.DEB.2.10.1412031226040.21739@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57789 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaLCLyK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:54:10 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1412031226040.21739@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 03, 2014 at 12:26:52PM +0100, Jozsef Kadlecsik wrote:
> On Tue, 2 Dec 2014, Pablo Neira Ayuso wrote:
> 
> > On Tue, Dec 02, 2014 at 07:46:44PM +0100, Pablo Neira Ayuso wrote:
> > > On Sun, Nov 30, 2014 at 07:56:52PM +0100, Jozsef Kadlecsik wrote:
> > > > When the set was full (hash type and maxelem reached), it was not
> > > > possible to update the extension part of already existing elements.
> > > > The patch removes this limitation. (Fixes netfilter bugzilla id 880.)
> > > 
> > > Could you please add this:
> > > 
> > > https://bugzilla.netfilter.org/show_bug.cgi?id=880
> > > 
> > > for quick browsing. Thanks.
> > 
> > I can fix this here.
> > 
> > Actually, I can manually apply from 1 to 6 in the next batch I'm going
> > to send to David.
> > 
> > I would like to make sure at least those get to him in time, -rc7 is
> > already out so we merge window may close by this weekend / beginning
> > next week (just predicting).
> 
> Thanks, Pablo indeed! Then I'll focus on the second part of the patches.

Thanks Jozsef. Applied from 1-6.

I'm going to prepare a batch for David. Please, focus on your rcu
patches, I'll do my best to get this in this merge window.
