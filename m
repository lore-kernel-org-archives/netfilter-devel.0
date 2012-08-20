From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: nf_conntrack: remove unnecessary RTNL
 locking
Date: Mon, 20 Aug 2012 16:53:31 +0200
Message-ID: <20120820145331.GD18676@1984>
References: <1345407370-30009-1-git-send-email-kaber@trash.net>
 <1345407370-30009-4-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52924 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809Ab2HTOxe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:53:34 -0400
Content-Disposition: inline
In-Reply-To: <1345407370-30009-4-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 19, 2012 at 10:16:10PM +0200, Patrick McHardy wrote:
> Locking the rtnl was added to nf_conntrack_l{3,4}_proto_unregister()
> for walking the network namespace list. This is not done anymore since
> we have proper namespace support in the protocols now, so we don't
> need to take the RTNL anymore.

Applied, thanks. Also enqueued to net-next.
