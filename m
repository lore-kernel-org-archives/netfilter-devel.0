From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] data_reg: Fix conditional code in XML
 parsing functions
Date: Wed, 29 May 2013 14:12:20 +0200
Message-ID: <20130529121220.GC6099@localhost>
References: <20130528150631.5282.3020.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33532 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965800Ab3E2MM2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 08:12:28 -0400
Content-Disposition: inline
In-Reply-To: <20130528150631.5282.3020.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 28, 2013 at 05:06:31PM +0200, Arturo Borrero wrote:
> All the XML parsing chunk was conditional but the main function. I think is better to
> do the conditional compilation by function, returning -1 and setting errno = EOPNOTSUPP.

Those functions are static, thus not exported. It doesn't make sense
to me to use this approach in this case.
