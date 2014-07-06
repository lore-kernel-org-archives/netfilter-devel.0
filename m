From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] mnl: check for NLM_F_DUMP_INTR when dumping object
 lists
Date: Sun, 6 Jul 2014 10:54:57 +0200
Message-ID: <20140706085457.GA3766@localhost>
References: <1404469942-6263-1-git-send-email-pablo@netfilter.org>
 <8587ed64-b49a-4e3f-abd3-d274cfe0fce6@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34851 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaGFIzR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jul 2014 04:55:17 -0400
Content-Disposition: inline
In-Reply-To: <8587ed64-b49a-4e3f-abd3-d274cfe0fce6@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 05, 2014 at 07:18:51PM +0200, Patrick McHardy wrote:
> On 4. Juli 2014 12:32:22 MESZ, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >This flag allows to detect that an update has ocurred while dumping
> >any of the object lists.
> >
> ><cmdline>:1:1-17: Error: Could not receive rules from kernel:
> >Interrupted system call
> >list table filter
> >^^^^^^^^^^^^^^^^^
> >
> >Basically, the user has to retry to make sure that it saves the current
> >rule-set.
> 
> Shouldn't we automatically handle this? Transient failure is really
> bad for many reasons.

OK, I'm going to extend this so it indefinitely retries until it
fetches the entire rule-set. Thanks Patrick.
