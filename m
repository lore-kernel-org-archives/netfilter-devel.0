From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH][libnetfilter_conntrack] snprintf: print conntrack
 helper name, too
Date: Sun, 20 May 2012 22:20:58 +0200
Message-ID: <20120520202058.GB2750@1984>
References: <1337340959-15183-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38555 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab2ETUVU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 May 2012 16:21:20 -0400
Content-Disposition: inline
In-Reply-To: <1337340959-15183-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 18, 2012 at 01:35:59PM +0200, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian.

I've mangled this to move the helper=%s before id=%d and use=%d.

This breaks the output for applications parsing our text-based output.

Still, we provide XML output that remains consistent along updates.
And, if people don't like XML (I would not blame them), they can still
contribute some more easy to parse extension in CSKV format, or even
some output in JSON format.
