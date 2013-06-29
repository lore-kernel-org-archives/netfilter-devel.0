From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: remove the duplicate
 NF_INET_LOCAL_OUT
Date: Sat, 29 Jun 2013 12:10:09 +0200
Message-ID: <20130629101009.GA5457@localhost>
References: <1372406246-13739-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43736 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab3F2KKN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 06:10:13 -0400
Content-Disposition: inline
In-Reply-To: <1372406246-13739-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 28, 2013 at 03:57:26AM -0400, Changli Gao wrote:
> The line for NF_INET_LOCAL_OUT is duplicated by mistake, so just remove it.

Alexander Primak already sent me a patch for this a week ago.

I have applied that one.

Thanks anyway Gao.
