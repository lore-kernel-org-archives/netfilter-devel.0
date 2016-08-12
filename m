From: Phil Sutter <phil@nwl.cc>
Subject: Re: [libnftnl PATCH 0/7] A bunch of covscan detected fixes
Date: Fri, 12 Aug 2016 02:47:46 +0200
Message-ID: <20160812004746.GG10197@orbyte.nwl.cc>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
 <20160811235817.GA11124@salvia>
 <20160812000554.GA11290@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58610 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbcHLArr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 20:47:47 -0400
Content-Disposition: inline
In-Reply-To: <20160812000554.GA11290@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 02:05:54AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 12, 2016 at 01:58:17AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Aug 12, 2016 at 01:33:32AM +0200, Phil Sutter wrote:
> > > The following series aims at fixing a number of issues identified by
> > > Coverity tool. Due to limited familiarity with the whole code layout, I
> > > am not sure all of them are really valid, but I tried my best to verify
> > > the concerns are legitimate and worth fixing.
> > 
> > Applied, 1/7, 3/7, 4/7, 5/7, 7/7.
> > 
> > Kept back 2/7 and 6/7.
> 
> Sorry, I mean I kept back 5/7.

Actually, you didn't. Patch 5/7 slipped through (d26feca2c9c19). Feel
free to revert if it's useless.

Thanks, Phil
