From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/5] netfilter: nf_queue: move device refcount bump to
 extra function
Date: Sat, 27 Apr 2013 19:46:01 +0200
Message-ID: <20130427174601.GA4891@localhost>
References: <1366383507-16633-1-git-send-email-fw@strlen.de>
 <1366383507-16633-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38752 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab3D0RqG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 13:46:06 -0400
Content-Disposition: inline
In-Reply-To: <1366383507-16633-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 19, 2013 at 04:58:23PM +0200, Florian Westphal wrote:
> required by future patch that will need to duplicate the
> nf_queue_entry, bumping refcounts of the copy.

Applied, thanks Florian.
