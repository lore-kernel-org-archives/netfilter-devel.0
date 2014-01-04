From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCHv2] Add support for queue target
Date: Sat, 4 Jan 2014 01:09:24 +0100
Message-ID: <20140104000924.GA28468@localhost>
References: <1385809076-20160-1-git-send-email-eric@regit.org>
 <1388341690-15377-1-git-send-email-eric@regit.org>
 <1388341690-15377-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41238 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbaADAJ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:09:29 -0500
Content-Disposition: inline
In-Reply-To: <1388341690-15377-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 29, 2013 at 07:28:10PM +0100, Eric Leblond wrote:
> This patch adds support for the queue target. It is now possible
> to specify rule sending packet to a given queue and using
> load balancing:
>
>   nft add rule filter output queue num 3 total 2 options fanout

Enqueued this to 3.14, thanks Eric!
