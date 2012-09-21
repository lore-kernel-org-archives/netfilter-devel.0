From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] nat: remove obsolete rcu_read_unlock call
Date: Fri, 21 Sep 2012 12:14:41 +0200
Message-ID: <20120921101441.GD24612@1984>
References: <20120920135133.GA21538@uweber-WS>
 <1348150485.31352.87.camel@edumazet-glaptop>
 <505B2575.80502@sophos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
To: Ulrich Weber <ulrich.weber@sophos.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59372 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab2IUKOs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:14:48 -0400
Content-Disposition: inline
In-Reply-To: <505B2575.80502@sophos.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 20, 2012 at 04:17:25PM +0200, Ulrich Weber wrote:
> On 09/20/2012 04:14 PM, Eric Dumazet wrote:
> >This could explain the rcu_read_unlock() imbalance Stephen had
> >(lockdep splat with net-next) How old is this bug ?
>
> Bug was introduced with c7232c9979cba684c50b64c513c4a83c9aa70563

I've added this to the patch description, it's good for the record.

Thanks.
