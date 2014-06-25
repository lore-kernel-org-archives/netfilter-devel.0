From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] net/netfilter/nf_conntrack_netlink.c: remove null
 test before kfree
Date: Wed, 25 Jun 2014 14:56:20 +0200
Message-ID: <20140625125620.GA10374@localhost>
References: <1403296738-6213-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52213 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaFYM4d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:56:33 -0400
Content-Disposition: inline
In-Reply-To: <1403296738-6213-1-git-send-email-fabf@skynet.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 20, 2014 at 10:38:58PM +0200, Fabian Frederick wrote:
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required

Applied, thanks.
