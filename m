From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix log/queue expressions for
 NFPROTO_INET
Date: Thu, 6 Feb 2014 11:42:08 +0100
Message-ID: <20140206104208.GA6589@localhost>
References: <1391678261-15906-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43473 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbaBFKmT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:42:19 -0500
Content-Disposition: inline
In-Reply-To: <1391678261-15906-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 06, 2014 at 09:17:41AM +0000, Patrick McHardy wrote:
> The log and queue expressions both store the family during ->init() and
> use it to deliver packets. This is wrong when used in NFPROTO_INET since
> they should both deliver to the actual AF of the packet, not the dummy
> NFPROTO_INET.
> 
> Use the family from the hook ops to fix this.

Applied, thanks Patrick!
