From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [FIX 1/1] sip: add missing RCU reader lock
Date: Fri, 20 Sep 2013 22:20:42 +0200
Message-ID: <20130920202042.GA3659@imap.eitzenberger.org>
References: <20130920155217.281613399@eitzenberger.org>
 <20130920155817.660882995@eitzenberger.org>
 <20130920165539.GA27970@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:58514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab3ITUY7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:24:59 -0400
Content-Disposition: inline
In-Reply-To: <20130920165539.GA27970@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> > I chose to not just extend the first RCU protected area but putting
> > the rcu_read_unlock() down, because there is a 'return' in between.
> 
> I'd suggest to do that since your patch still doesn't cover the
> direct_rtp nf_nat_sdp_port_hook dereference. Actually with your patch
> we have unbalanced RCU locking since the direct_rtp case contains
> a "goto err1".

Sure, I'll send a 2nd patch in a new thread.

 /Holger

