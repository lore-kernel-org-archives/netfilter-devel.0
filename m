From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] rule: add flag to display rule handle as comment
Date: Fri, 31 May 2013 13:11:55 +0200
Message-ID: <20130531111155.GA4260@localhost>
References: <20130521135328.GA5301@localhost>
 <1369923766-15549-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57153 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab3EaLMA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 May 2013 07:12:00 -0400
Content-Disposition: inline
In-Reply-To: <1369923766-15549-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 30, 2013 at 04:22:46PM +0200, Eric Leblond wrote:
> Knowing the rule handle is necessary to be able to delete a single
> rule. It was not displayed till now in the output and it was thus
> impossible to remove a single rule.
> This patch modify the listing output to add a comment containing
> the handle when the -a/--handle flag is provided.

Applied, thanks Eric!
