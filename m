From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 0/7] A bunch of covscan detected fixes
Date: Fri, 12 Aug 2016 02:05:54 +0200
Message-ID: <20160812000554.GA11290@salvia>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
 <20160811235817.GA11124@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54268 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbcHLAF7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 20:05:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CA7551878BF
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 02:05:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BCACFDA7E7
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 02:05:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CC66FDA7E7
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 02:05:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160811235817.GA11124@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 01:58:17AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 12, 2016 at 01:33:32AM +0200, Phil Sutter wrote:
> > The following series aims at fixing a number of issues identified by
> > Coverity tool. Due to limited familiarity with the whole code layout, I
> > am not sure all of them are really valid, but I tried my best to verify
> > the concerns are legitimate and worth fixing.
> 
> Applied, 1/7, 3/7, 4/7, 5/7, 7/7.
> 
> Kept back 2/7 and 6/7.

Sorry, I mean I kept back 5/7.

> I think 2/7 you can send a new version.
> 
> Thanks Phil.
