From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v4] tests: tests for libnftables
Date: Wed, 20 Nov 2013 23:59:02 +0100
Message-ID: <20131120225902.GB17786@localhost>
References: <1384946592-6109-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46407 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab3KTW7L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:59:11 -0500
Content-Disposition: inline
In-Reply-To: <1384946592-6109-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 20, 2013 at 12:23:12PM +0100, Ana Rey wrote:
> Makefile and tests files for libnftables.
> 
> In this patch, I create a initial object 'a' and I set a testing values. Then,
> I convert this object in a Netlink message.
> 
> From this Netlink message, I parse that (through nft_table_nlmsg_parse
> function) in 'b' objetc.
> 
> Thus, we make sure that object transformations are correct.

I have renamed the 'die' functions to 'print_err' as your tests don't
seem to die anymore if we hit a problem, no problem it was fast :).

Applied, good job Ana.
