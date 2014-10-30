From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 1/3] netfilter: log: protect nf_log_register against
 double registering
Date: Thu, 30 Oct 2014 17:31:39 +0100
Message-ID: <20141030163139.GC2270@salvia>
References: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34207 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933539AbaJ3QaA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:30:00 -0400
Content-Disposition: inline
In-Reply-To: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 29, 2014 at 10:51:13AM -0200, Marcelo Ricardo Leitner wrote:
> Currently, despite the comment right before the function,
> nf_log_register allows registering two loggers on with the same type and
> end up overwriting the previous register.
> 
> Not a real issue today as current tree doesn't have two loggers for the
> same type but it's better to get this protected.
> 
> Also make sure that all of its callers do error checking.

Also applied, thanks.
