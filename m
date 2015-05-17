From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: cthelper's and default QueueLen -- bug?
Date: Sun, 17 May 2015 17:24:22 +0200
Message-ID: <20150517152422.GA4501@salvia>
References: <1431009715.6436.2.camel@REM-DF8MK12.vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Chas Williams III <Charles.Williams@brocade.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39889 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbbEQPTa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2015 11:19:30 -0400
Content-Disposition: inline
In-Reply-To: <1431009715.6436.2.camel@REM-DF8MK12.vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 07, 2015 at 08:41:55AM -0600, Chas Williams III wrote:
> conntracked.conf states that the default QueueLen is 1024.
> 
> 	# Maximum number of packets waiting in the queue to receive
> 	# a verdict from user-space. Default is 1024.
> 
> However, if the config file doesn't specify a queue length, the
> default length is zero (due to the calloc() allocation).  The
> queue always seems to be pushed up to the kernel regardless
> in cthelper_nfqueue_setup() so the kernel default is overwritten.

Would you send a patch that I can apply via git am to fix this?

Thanks for reporting.
