From: Patrick McHardy <kaber@trash.net>
Subject: Re: [OOPS PATCH 0/1] netfilter/sip: fix OOPS in flush_expectations()
Date: Sat, 12 Oct 2013 09:55:24 +0100
Message-ID: <20131012085215.GB28765@macbook.localnet>
References: <20131011140204.916097373@eitzenberger.org>
 <20131011203749.GA20502@localhost>
 <20131012055807.GI13405@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52313 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3JLIz3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Oct 2013 04:55:29 -0400
Content-Disposition: inline
In-Reply-To: <20131012055807.GI13405@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 12, 2013 at 07:58:07AM +0200, Holger Eitzenberger wrote:
> 
> > > My proposed fix is therefore to change nf_ct_unlink_expect_report()
> > > so that it uses __hlist_del() instead, so that the loop cursor in
> > > hlist_for_each_entry_safe() terminates correctly at the end of the
> > > list.
> > > 
> > > Patch is reported to have fixed the issue at the customers site.
> > 
> > Do your 3.3 kernels include this patch?
> > 
> > 3f509c6 netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation
> > 
> > It fixes a double insertion of an expectation, I think it may manifest
> > the way that oops look like.
> 
> The 3.3 kernel does not include it.  So I'll queue it up, thanks!
> 
> However, the other identical report is for v3.8, which already includes
> it.  So I think the issue I see in unrelated to the patch.

I've reviewed the code and all I could find wrt. missing locking is the
call to nf_ct_remove_expectations() in process_urq() (H.323). Is the
H.323 helper used on the machine where you're experiencing the crash?
