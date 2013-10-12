From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [OOPS PATCH 0/1] netfilter/sip: fix OOPS in flush_expectations()
Date: Sat, 12 Oct 2013 12:11:21 +0200
Message-ID: <20131012101121.GJ13405@imap.eitzenberger.org>
References: <20131011140204.916097373@eitzenberger.org>
 <20131011203749.GA20502@localhost>
 <20131012055807.GI13405@imap.eitzenberger.org>
 <20131012085215.GB28765@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3JLKLZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Oct 2013 06:11:25 -0400
Content-Disposition: inline
In-Reply-To: <20131012085215.GB28765@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> > > Do your 3.3 kernels include this patch?
> > > 
> > > 3f509c6 netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation
> > > 
> > > It fixes a double insertion of an expectation, I think it may manifest
> > > the way that oops look like.
> > 
> > The 3.3 kernel does not include it.  So I'll queue it up, thanks!
> > 
> > However, the other identical report is for v3.8, which already includes
> > it.  So I think the issue I see in unrelated to the patch.
> 
> I've reviewed the code and all I could find wrt. missing locking is the
> call to nf_ct_remove_expectations() in process_urq() (H.323). Is the
> H.323 helper used on the machine where you're experiencing the crash?

I can check on Monday.

Thanks!
