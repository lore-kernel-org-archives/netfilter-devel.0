From: Patrick McHardy <kaber@trash.net>
Subject: Re: [OOPS PATCH 1/1] netfilter: fix OOPS in flush_expectations()
Date: Fri, 11 Oct 2013 16:09:26 +0100
Message-ID: <20131011150923.GA12533@macbook.localnet>
References: <20131011140204.916097373@eitzenberger.org>
 <20131011140440.339579297@eitzenberger.org>
 <20131011143539.GA5276@macbook.localnet>
 <20131011145347.GB3659@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45952 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3JKPJl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:09:41 -0400
Received: from macbook.localnet (unknown [127.0.0.1])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTPS id DE6689D2DE
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2013 17:09:37 +0200 (MEST)
Content-Disposition: inline
In-Reply-To: <20131011145347.GB3659@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 11, 2013 at 04:53:47PM +0200, Holger Eitzenberger wrote:
> 
> > > Which is due to nf_conntrack_expect.lnode hlist entry not being reset
> > > to NULL after being removed from the list in hlist_del(), but instead to
> > > LIST_POISON1.  And because of this hlist_for_each_entry_safe() does
> > > not terminate correctly.
> > > 
> > > Therefore change nf_ct_unlink_expect_report() to use __hlist_del()
> > > instead.
> > 
> > We should be holding the conntrack lock here and in flush_expectations(),
> > Not sure what I'm missing here, but if locking were used correctly, this
> > shouldn't be happening.
> 
> My first impression was that it is something locking related, so I first
> looked at usage of nf_conntrack_lock.  But I didn't find anything.  So
> my understanding is that usage of nf_conntrack_lock is correct.

Well, it has to be, otherwise we couldn't be hitting the seeing
the element in flush_expectations() with LIST_POISON1.

> Still, I think that using hlist_del() together with those
> loop iterators expecting NULL-ness is a dangerous thing to do.

I disagree, its perfectly fine if done correctly. This is just papering
over the underlying issue, which is apparently missing in something 
invoking nf_ct_unlink_expect_report().
