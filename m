From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: connlimit: move lock array out of struct
 connlimit_data
Date: Mon, 24 Mar 2014 12:09:49 +0100
Message-ID: <20140324110949.GB5074@localhost>
References: <1395312819-18608-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44043 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbaCXLJz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:09:55 -0400
Content-Disposition: inline
In-Reply-To: <1395312819-18608-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 20, 2014 at 11:53:39AM +0100, Florian Westphal wrote:
> Eric points out that the locks can be global.
> Moreover, both Jesper and Eric note that using only 32 locks increases
> false sharing as only two cache lines are used.
> 
> This increases locks to 256 (16 cache lines assuming 64byte cacheline and
> 4 bytes per spinlock).

Applied, thanks Florian.
