From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: x_tables: xt_free_table_info() cleanup
Date: Wed, 25 Jun 2014 14:55:27 +0200
Message-ID: <20140625125527.GA8315@localhost>
References: <1403601335.3796.2.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51957 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbaFYMzl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:55:41 -0400
Content-Disposition: inline
In-Reply-To: <1403601335.3796.2.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 24, 2014 at 02:15:35AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> kvfree() helper can make xt_free_table_info() much cleaner.

Applied, thanks Eric.
