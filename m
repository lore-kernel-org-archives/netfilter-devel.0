From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] [PATCH] extensions: libxt_statistic: Add
 translation to nft
Date: Tue, 1 Mar 2016 20:00:05 +0100
Message-ID: <20160301190005.GA1532@salvia>
References: <20160229212216.GA29706@sonyv>
 <CAKHNQQH2sE3A_jV0kuwBaTQZS1Z90RwuRoL+dvhPyCOV=Ev=9w@mail.gmail.com>
 <20160301101331.GA2714@salvia>
 <20160301155657.GB3838@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shivani Bhardwaj <shivanib134@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Laura Garcia <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36610 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbcCATAM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 14:00:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9D1296DFC9
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:00:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8D284DA8F9
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:00:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 218E5DA390
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:00:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160301155657.GB3838@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 01, 2016 at 04:56:59PM +0100, Laura Garcia wrote:
> On Tue, Mar 01, 2016 at 11:13:31AM +0100, Pablo Neira Ayuso wrote:
> > 
> > I would like to have them merged upstream, no need to wait to fully
> > support every extension, we can document these limitations in the wiki
> > and the commit log.
> > 
> > IIRC, if the .xlate indirection returns 0, then it means no
> > translation is available. We can use that for things that we don't
> > support yet.
> >
> 
> Hi Pablo, should I have to include this in the patch?

Yes please.

Address Shivani's feedback and send a v2. Thanks Laura.
