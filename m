From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] ip(6)tables-restore: make sure argv is NULL
 terminated
Date: Mon, 14 May 2012 10:41:12 +0200
Message-ID: <20120514084112.GF9577@1984>
References: <1336664567-4593-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44901 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab2ENIlP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 May 2012 04:41:15 -0400
Content-Disposition: inline
In-Reply-To: <1336664567-4593-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 10, 2012 at 05:42:47PM +0200, Florian Westphal wrote:
> Else, argv[argc] may point to free'd memory.
> 
> Some extensions, e.g. rateest, may fail to parse valid input
> because argv[optind] (with optind == argc) is not NULL.

Applied, thanks Florian.
