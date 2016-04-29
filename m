From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: fix IS_ERR_VALUE usage
Date: Fri, 29 Apr 2016 11:30:10 +0200
Message-ID: <20160429093010.GA14734@salvia>
References: <1461920038-6795-1-git-send-email-pablo@netfilter.org>
 <20160429091754.GN17538@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, a.hajda@samsung.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59537 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbcD2JaU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 05:30:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C9EFAE5A49
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:30:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AA1C8100A5F
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:30:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 98900FEFBF
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:30:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160429091754.GN17538@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 29, 2016 at 11:17:54AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This is a forward-ported original patch from Andrzej Hajda, he said:
> > 
> > "IS_ERR_VALUE should be used only with unsigned long type.
> > Otherwise it can work incorrectly. To achieve this function
> > xt_percpu_counter_alloc is modified to return unsigned long,
> > and its result is assigned to temporary variable to perform
> > error checking, before assigning to .pcnt field.
> > 
> > The patch follows conclusion from discussion on LKML [1][2].
> > 
> > [1]: http://permalink.gmane.org/gmane.linux.kernel/2120927
> > [2]: http://permalink.gmane.org/gmane.linux.kernel/2150581"
> > 
> > Original patch from Andrzej is here:
> > 
> > http://patchwork.ozlabs.org/patch/582970/
> > 
> > This patch has clashed with input validation fixes for x_tables.
> 
> AFAICS this isn't a bug fix so I'm fine with this going into nf-next.

This seems to affect 32-bits arch, we could qualify this as nf. But
this has been there for a while without nobody noticing in runtime
kernels, this problem got uncovered by analysis I think.
