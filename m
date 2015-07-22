From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: heads up, rebasing nf (was Re: [PATCH nf] netfilter: nf_conntrack:
 silent warning when adding) extensions to templates
Date: Wed, 22 Jul 2015 21:55:25 +0200
Message-ID: <20150722195525.GA4217@salvia>
References: <1437382197-3515-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42390 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbbGVTtk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jul 2015 15:49:40 -0400
Content-Disposition: inline
In-Reply-To: <1437382197-3515-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 20, 2015 at 10:49:57AM +0200, Pablo Neira Ayuso wrote:
> [   12.602995] ------------[ cut here ]------------
> [   12.604390] WARNING: CPU: 0 PID: 1 at net/netfilter/nf_conntrack_extend.c:80 __nf_ct_ext_add_length+0x2a/0x230()
> 
> Templates need to be unconfirmed when adding extensions to avoid this warning.
> 
> Fixes: 579502f10880 ("netfilter: fix netns dependencies with conntrack templates")
> Reported-by: kernel test robot <ying.huang@intel.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

JFYI: I'm going to collapse this patch to 579502f10880 so it becomes
easier to pass this one to -stable without major dependencies.

So I'm rebasing the nf tree here, sorry for the inconvenience.
