From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: Can't fail and free after table replacement
Date: Sat, 5 Apr 2014 17:47:01 +0200
Message-ID: <20140405154701.GA3747@localhost>
References: <b6e7d146668a1f60c3aa9b34538a04bafaf1e433.1396626959.git.tgraf@suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bart.de.schuymer@pandora.be, kaber@trash.net,
	kadlec@blackhole.kfki.hu, stephen@networkplumber.org,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33329 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbaDEPrI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2014 11:47:08 -0400
Content-Disposition: inline
In-Reply-To: <b6e7d146668a1f60c3aa9b34538a04bafaf1e433.1396626959.git.tgraf@suug.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 04, 2014 at 05:57:45PM +0200, Thomas Graf wrote:
> All xtables variants suffer from the defect that the copy_to_user()
> to copy the counters to user memory may fail after the table has
> already been exchanged and thus exposed. Return an error at this
> point will result in freeing the already exposed table. Any
> subsequent packet processing will result in a kernel panic.
> 
> We can't copy the counters before exposing the new tables as we
> want provide the counter state after the old table has been
> unhooked. Therefore convert this into a silent error.

Applied, thanks Thomas.
