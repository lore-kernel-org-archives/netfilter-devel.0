From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: x_tables: allow to use default cgroup match
Date: Tue, 19 Aug 2014 21:39:55 +0200
Message-ID: <20140819193955.GA4289@salvia>
References: <1408369588-12363-1-git-send-email-dborkman@redhat.com>
 <53F33476.8070904@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Daniel Borkmann <dborkman@redhat.com>
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33572 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbaHSTjT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2014 15:39:19 -0400
Content-Disposition: inline
In-Reply-To: <53F33476.8070904@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 19, 2014 at 03:26:46PM +0400, Alexey Perevalov wrote:
> On 08/18/2014 05:46 PM, Daniel Borkmann wrote:
> >There's actually no good reason why we cannot use cgroup id 0,
> >so lets just remove this artificial barrier.
> >
> >Reported-by: Alexey Perevalov <a.perevalov@samsung.com>
> >Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> >---
> >  net/netfilter/xt_cgroup.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >
> Thank you, Daniel, I tested it on my environment, patch is fine.
> 
> Tested-by: Alexey Perevalov <a.perevalov@samsung.com>

Applied, thanks.
