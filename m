From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] rule: display rule handle as comment
Date: Tue, 21 May 2013 15:53:28 +0200
Message-ID: <20130521135328.GA5301@localhost>
References: <1369091340-29211-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48522 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3EUNxd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 May 2013 09:53:33 -0400
Content-Disposition: inline
In-Reply-To: <1369091340-29211-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Tue, May 21, 2013 at 01:09:00AM +0200, Eric Leblond wrote:
> Knowing the rule handle is necessary to be able to delete a single
> rule. It was not displayed till now in the output and it was thus
> impossible to remove a single rule.
> This patch modify the listing output to add a comment containing
> the handle.

Thanks for the patch.

Could you add some option, eg. -a/--handle, so the handle is shown
only if we invoke:

nft -a list table filter

We also support:

nft list table filter > rule-set-file
nft -f rule-set-file

And the handle number will not be of any use there.
