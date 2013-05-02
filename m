From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/6] netfilter: ipset: Fix sparse warnings due to missing
 rcu annotations
Date: Thu, 2 May 2013 12:08:42 +0200
Message-ID: <20130502100842.GC3432@localhost>
References: <1367487442-3571-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1367487442-3571-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34092 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3EBKIr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 May 2013 06:08:47 -0400
Content-Disposition: inline
In-Reply-To: <1367487442-3571-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 02, 2013 at 11:37:19AM +0200, Jozsef Kadlecsik wrote:
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Would be good if we include the sparse warning this is fixing in the
changelog.
