From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] meta: add prandom matching
Date: Tue, 16 Feb 2016 12:45:23 +0100
Message-ID: <20160216114523.GA2502@salvia>
References: <1454368741-16368-1-git-send-email-fw@strlen.de>
 <1454368741-16368-3-git-send-email-fw@strlen.de>
 <DB5D81F9-A143-4DE6-A315-465B72EA84B3@trash.net>
 <20160204144646.GA25780@breakpoint.cc>
 <20160204152711.GA3853@macbook.localdomain>
 <20160204153240.GB25780@breakpoint.cc>
 <20160204160937.GA13973@breakpoint.cc>
 <20160204164243.GB13973@breakpoint.cc>
 <20160204174029.GB13157@macbook.localdomain>
 <20160215125446.GA23168@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56691 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbcBPLpc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 06:45:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 81F6E342
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 12:45:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6B5B2330DB
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 12:45:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D0A58330D1
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 12:45:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160215125446.GA23168@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 15, 2016 at 01:54:46PM +0100, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> 
> Hi Patrick
> 
> > On 04.02, Florian Westphal wrote:
> > > In fact, doing the scaling via precision_type seems to
> > > be a lot simpler as then its applied only in this one case of the
> > > prandom META_TEMPLATE while keeping this detail limited to meta.c.
> > 
> > Yes, on second thought I agree, sorry. Maybe the work is not lost though,
> > what does seem to make sense is to use a float basetype and derive your
> > probability type from that.
> 
> I can do this.
> However, I don't currently see any other type that could be derived from
> that.  Would you be OK with leaving things as-is and adding a float
> type later on once a use case presents itself?

I also think you can add a new TYPE_FLOAT.

Then, from the evaluation step make sure that META_PRANDOM is under
the valid limits (0, 1].

These TYPE_* will be part of the public API of the high level library
at some point, they describe the datatype that are used in set
definitions in the kernel (through the NFTA_SET_DATATYPE netlink
attribute and the new NFTA_SET_USERDATA through TLVs).
