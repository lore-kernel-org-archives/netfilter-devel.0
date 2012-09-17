From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Allocating and destroying connection-related data
Date: Mon, 17 Sep 2012 14:31:43 +0200
Message-ID: <20120917123143.GA7240@1984>
References: <50570C51.2080104@cats-muvva.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Nicole <nicole@cats-muvva.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37554 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179Ab2IQMbs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:31:48 -0400
Content-Disposition: inline
In-Reply-To: <50570C51.2080104@cats-muvva.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 17, 2012 at 12:41:05PM +0100, Nicole wrote:
> Dear All,
> 
> Do you have a tutorial (or example) for how to write a module that
> allocates and destroys its own small amount of data that can be
> associated with any connection, including those for which a connection
> tracker is already used?

There is not, sorry. You'll have to read source code. Check:

net/netfilter/nf_conntrack_extend.c

and for instance on how to create a conntrack extension:

net/netfilter/nf_conntrack_acct.c
