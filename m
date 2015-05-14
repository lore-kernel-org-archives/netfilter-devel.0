From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: bridge: free nf_bridge info on xmit
Date: Thu, 14 May 2015 12:52:41 +0200
Message-ID: <20150514105241.GB4832@salvia>
References: <1430683567-29185-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35756 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561AbbENKrx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 May 2015 06:47:53 -0400
Content-Disposition: inline
In-Reply-To: <1430683567-29185-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 03, 2015 at 10:06:07PM +0200, Florian Westphal wrote:
> nf_bridge information is only needed for -m physdev, so we can always free
> it after POST_ROUTING.  This has the advantage that allocation and free will
> typically happen on the same cpu.

Also applied, thanks Florian.
