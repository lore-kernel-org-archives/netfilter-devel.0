From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [OOPS PATCH 0/1] netfilter/sip: fix OOPS in flush_expectations()
Date: Sat, 12 Oct 2013 07:58:07 +0200
Message-ID: <20131012055807.GI13405@imap.eitzenberger.org>
References: <20131011140204.916097373@eitzenberger.org>
 <20131011203749.GA20502@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:65440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3JLF6S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Oct 2013 01:58:18 -0400
Content-Disposition: inline
In-Reply-To: <20131011203749.GA20502@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> > My proposed fix is therefore to change nf_ct_unlink_expect_report()
> > so that it uses __hlist_del() instead, so that the loop cursor in
> > hlist_for_each_entry_safe() terminates correctly at the end of the
> > list.
> > 
> > Patch is reported to have fixed the issue at the customers site.
> 
> Do your 3.3 kernels include this patch?
> 
> 3f509c6 netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation
> 
> It fixes a double insertion of an expectation, I think it may manifest
> the way that oops look like.

The 3.3 kernel does not include it.  So I'll queue it up, thanks!

However, the other identical report is for v3.8, which already includes
it.  So I think the issue I see in unrelated to the patch.

  /Holger

