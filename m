From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next 2/2] netfilter: nfnetlink_queue: only add CAP_LEN
 attr when needed
Date: Wed, 5 Jun 2013 12:43:57 +0200
Message-ID: <20130605104357.GA5812@localhost>
References: <1370420536-9626-1-git-send-email-fw@strlen.de>
 <1370420536-9626-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53185 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab3FEKoB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:44:01 -0400
Content-Disposition: inline
In-Reply-To: <1370420536-9626-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 05, 2013 at 10:22:16AM +0200, Florian Westphal wrote:
> CAP_LEN contains the size of the network packet we're queueing to
> userspace, i.e. normally it is the same as the NFQA_PAYLOAD attribute len.
> 
> Include it only in the unlikely case when NFQA_PAYLOAD is truncated due
> to copy_range limitations.

Also applied, thanks!
