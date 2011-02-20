From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] netfilter: ctnetlink: fix (really) race condition
 between dump_table and destroy
Date: Sun, 20 Feb 2011 12:48:14 -0800
Message-ID: <20110220124814.2e89da91@nehalam>
References: <20110123231602.3383.31480.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, stable@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>, Greg KH <greg@kroah.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:60479 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab1BTUvo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:51:44 -0500
In-Reply-To: <20110123231602.3383.31480.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 24 Jan 2011 00:16:02 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> In 13ee6ac579574a2a95e982b19920fd2495dce8cd, we recovered spinlocks
> to protect the dump of the conntrack table according to reports from
> Stephen and acknowledgments on the issue from Eric.
> 
> However, Stephen removed the refcount bump in that patch that allows
> to keep a reference to the current ct object we are interating over.
> That code avoids race conditions between ct object destruction and
> the iteration itself. This patch reintroduces these lines since the
> ct object may vanish between two recvmgs() invocations.
> 
> This patch fixes ocasional crashes while dumping the conntrack table
> intensively.
> 
> Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

These two patches should have been submitted to the stable kernel.
