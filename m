From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH][conntrack-tools] conntrack: flush stdout for each
 expectation event, too
Date: Sun, 20 May 2012 22:21:11 +0200
Message-ID: <20120520202111.GC2750@1984>
References: <1337341009-15287-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38470 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab2ETUVS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 May 2012 16:21:18 -0400
Content-Disposition: inline
In-Reply-To: <1337341009-15287-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 18, 2012 at 01:36:49PM +0200, Florian Westphal wrote:
> else, piping "conntrack -E expect" output will be buffered/delayed,
> which is not what users expect. Normal conntrack events are already
> flushed.

applied, thanks Florian.
