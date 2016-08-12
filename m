From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 0/7] A bunch of covscan detected fixes
Date: Fri, 12 Aug 2016 10:40:40 +0200
Message-ID: <20160812084040.GB1440@salvia>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
 <20160811235817.GA11124@salvia>
 <20160812000554.GA11290@salvia>
 <20160812004746.GG10197@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55390 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbcHLIks (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 04:40:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D71EFD162B
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 10:40:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C8ECC1B3334
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 10:40:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7519A1B3336
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 10:40:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160812004746.GG10197@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 02:47:46AM +0200, Phil Sutter wrote:
> On Fri, Aug 12, 2016 at 02:05:54AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Aug 12, 2016 at 01:58:17AM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Aug 12, 2016 at 01:33:32AM +0200, Phil Sutter wrote:
> > > > The following series aims at fixing a number of issues identified by
> > > > Coverity tool. Due to limited familiarity with the whole code layout, I
> > > > am not sure all of them are really valid, but I tried my best to verify
> > > > the concerns are legitimate and worth fixing.
> > > 
> > > Applied, 1/7, 3/7, 4/7, 5/7, 7/7.
> > > 
> > > Kept back 2/7 and 6/7.
> > 
> > Sorry, I mean I kept back 5/7.
> 
> Actually, you didn't. Patch 5/7 slipped through (d26feca2c9c19). Feel
> free to revert if it's useless.

Done.
