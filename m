From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: rpfilter: depend on raw or mangle table
Date: Fri, 19 Apr 2013 00:17:27 +0200
Message-ID: <20130418221727.GA13141@localhost>
References: <1366274725-16286-1-git-send-email-fw@strlen.de>
 <1366274725-16286-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44811 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab3DRWRe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:17:34 -0400
Content-Disposition: inline
In-Reply-To: <1366274725-16286-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 18, 2013 at 10:45:25AM +0200, Florian Westphal wrote:
> rpfilter is only valid in raw/mangle PREROUTING, i.e.
> RPFILTER=y|m is useless without raw or mangle table support.

Applied to nf-next, thanks Florian.
