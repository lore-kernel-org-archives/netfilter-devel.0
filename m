From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: xtables_ipmask_to_numeric incorrect with
 non-CIDR masks
Date: Fri, 27 Sep 2013 16:30:52 +0200
Message-ID: <20130927143052.GA14714@localhost>
References: <20130926160658.GA12333@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47139 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab3I0ObA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:31:00 -0400
Content-Disposition: inline
In-Reply-To: <20130926160658.GA12333@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 26, 2013 at 09:06:58AM -0700, Phil Oester wrote:
> As pointed out by Peter Hoelsken, rules created with non-standard masks such as
> 0.255.0.0, 0.0.255.0, etc. are displayed when output with iptables -L in CIDR
> notation as -1.  This is because the cidr variable in xtables_ipmask_to_numeric
> is unsigned, and the return value of -1 from xtables_ipmask_to_cidr is therefore
> converted to 4294967295.  Add a cast to workaround the issue.
> 
> This closes netfilter bugzilla #854.

Applied, thanks Phil!
