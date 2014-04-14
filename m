From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] netfilter: nf_tables: Add meta expression key for
 bridge interface name
Date: Mon, 14 Apr 2014 13:55:42 +0200
Message-ID: <20140414115542.GA21503@localhost>
References: <1396956324-17803-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1396956324-17803-4-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20140414113657.GA21331@localhost>
 <534BCB1B.8040907@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33565 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbaDNL4B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:56:01 -0400
Content-Disposition: inline
In-Reply-To: <534BCB1B.8040907@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 14, 2014 at 02:48:43PM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >I think you can remove the trailing _bridge, it's obvious that we're
> >already in the bridge directory.
> 
> All family-tight nftables modules seem to follow this rule, reason
> why I did so.
> (cf. reject, chain nat, etc...)

Right, otherwise module will clash before of similar name, so forget
my comment on that.

> Anyway, will resend a new version applying your Kconfig comment.

Thanks.
