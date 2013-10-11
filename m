From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [OOPS PATCH 1/1] netfilter: fix OOPS in flush_expectations()
Date: Fri, 11 Oct 2013 16:53:47 +0200
Message-ID: <20131011145347.GB3659@imap.eitzenberger.org>
References: <20131011140204.916097373@eitzenberger.org>
 <20131011140440.339579297@eitzenberger.org>
 <20131011143539.GA5276@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab3JKOxu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:53:50 -0400
Content-Disposition: inline
In-Reply-To: <20131011143539.GA5276@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> > Which is due to nf_conntrack_expect.lnode hlist entry not being reset
> > to NULL after being removed from the list in hlist_del(), but instead to
> > LIST_POISON1.  And because of this hlist_for_each_entry_safe() does
> > not terminate correctly.
> > 
> > Therefore change nf_ct_unlink_expect_report() to use __hlist_del()
> > instead.
> 
> We should be holding the conntrack lock here and in flush_expectations(),
> Not sure what I'm missing here, but if locking were used correctly, this
> shouldn't be happening.

My first impression was that it is something locking related, so I first
looked at usage of nf_conntrack_lock.  But I didn't find anything.  So
my understanding is that usage of nf_conntrack_lock is correct.

Still, I think that using hlist_del() together with those
loop iterators expecting NULL-ness is a dangerous thing to do.

