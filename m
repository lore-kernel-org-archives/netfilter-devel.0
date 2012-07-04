From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] Timeout fixing bug broke SET target special
 timeout value, fixed
Date: Wed, 4 Jul 2012 23:18:54 +0200
Message-ID: <20120704211854.GA23868@1984>
References: <1340998948-29672-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1340998948-29672-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40041 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab2GDVTC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jul 2012 17:19:02 -0400
Content-Disposition: inline
In-Reply-To: <1340998948-29672-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 29, 2012 at 09:42:28PM +0200, Jozsef Kadlecsik wrote:
> The patch "Fix timeout value overflow bug at large timeout parameters"
> broke the SET target when no timeout was specified (reported by
> Jean-Philippe Menil).
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

I've enqueued this for 3.5-rc, thanks Jozsef.

I'll pass this to -stable 3.4 once this hit Linus tree.
