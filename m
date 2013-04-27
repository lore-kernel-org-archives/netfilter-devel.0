From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/13] ipset patches for nf-next
Date: Sat, 27 Apr 2013 19:42:08 +0200
Message-ID: <20130427174208.GA4848@localhost>
References: <1367067045-960-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38562 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab3D0RmM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 13:42:12 -0400
Content-Disposition: inline
In-Reply-To: <1367067045-960-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 27, 2013 at 02:50:32PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please consider applying the next patches against your nf-next tree.
> 
> The patches introduce the new extensions infrastructure in ipset and
> add packet/byte counters as a new extension besides timeouts. The set
> match is extended by the functionality to match the counters too.
> 
> Best regards,
> Jozsef
> 
> The following changes since commit 37fe0660981d7a1577409226f77554c2c5123e27:
>   Vlad Yasevich (1):
>         net: fix address check in rtnl_fdb_del
> 
> are available in the git repository at:
> 
>   git://blackhole.kfki.hu/nf-next master

Pulled, thanks Jozsef.
