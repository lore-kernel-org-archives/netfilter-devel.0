From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: ctnetlink: deliver labels to userspace
Date: Fri, 18 Jan 2013 00:38:06 +0100
Message-ID: <20130117233806.GB15996@1984>
References: <1357921846-29650-1-git-send-email-fw@strlen.de>
 <1357921846-29650-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35536 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3AQXiK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:38:10 -0500
Content-Disposition: inline
In-Reply-To: <1357921846-29650-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 11, 2013 at 05:30:45PM +0100, Florian Westphal wrote:
> Introduce CTA_LABELS attribute to send a bit-vector of currently active labels
> to userspace.
> 
> Future patch will permit userspace to also set/delete active labels.

Applied, thanks.
