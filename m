From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] conntrackd: fix compiler warnings
Date: Wed, 5 Jun 2013 04:41:31 +0200
Message-ID: <20130605024131.GA14962@localhost>
References: <1370251105-12450-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57700 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab3FEClk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:41:40 -0400
Content-Disposition: inline
In-Reply-To: <1370251105-12450-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 03, 2013 at 11:18:24AM +0200, Florian Westphal wrote:
> main.c:359:6: warning: ignoring return value of 'nice' [..]
> main.c:395:7: warning: ignoring return value of 'chdir' [..]
> run.c:43:17: warning: declaration of 'signal' shadows a global declaration

Applied, thanks.
