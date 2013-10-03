From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] netlink: use build_id to lower message size
Date: Thu, 3 Oct 2013 18:25:48 +0200
Message-ID: <20131003162548.GA6896@localhost>
References: <1380755553.6862.32.camel@tiger2>
 <1380755793-18011-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49190 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab3JCQZ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:25:59 -0400
Content-Disposition: inline
In-Reply-To: <1380755793-18011-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 03, 2013 at 01:16:33AM +0200, Eric Leblond wrote:
> THis patch makes use of the new nft_rule_nlmsg_build_id function
> from libnftables for the delete operation. This lower the size
> of the netlink message sent to kernel when flushing the rules.

I think we can simplify the flush operation with a small change in
nf_tables_delrule. The idea is to delete all rule if no chain is
specified.

The current approach is pretty time consuming, as we have to fetch the
ruleset from the kernel, iterate over it and build the message to
delete them.

Would you send me patches to follow this approach?
