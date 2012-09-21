From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] nat: remove obsolete rcu_read_unlock call
Date: Fri, 21 Sep 2012 12:14:14 +0200
Message-ID: <20120921101414.GC24612@1984>
References: <20120920135133.GA21538@uweber-WS>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ulrich Weber <ulrich.weber@sophos.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59284 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab2IUKO1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:14:27 -0400
Content-Disposition: inline
In-Reply-To: <20120920135133.GA21538@uweber-WS>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 20, 2012 at 03:52:04PM +0200, Ulrich Weber wrote:
> hlist walk in find_appropriate_src() is not protected anymore by rcu_read_lock(),
> so rcu_read_unlock() is unnecessary if in_range() matches.

Applied, thanks Ulrich.
