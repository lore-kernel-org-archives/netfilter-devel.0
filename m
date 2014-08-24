From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] uapi: netfilter_arp: use __u8 instead of u_int8_t
Date: Sun, 24 Aug 2014 14:54:25 +0200
Message-ID: <20140824125425.GA7864@salvia>
References: <1407142241-1790-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59617 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbaHXMxl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Aug 2014 08:53:41 -0400
Content-Disposition: inline
In-Reply-To: <1407142241-1790-1-git-send-email-vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 04, 2014 at 04:50:41AM -0400, Mike Frysinger wrote:
> Similarly, the u_int8_t type is non-standard and not defined.  Change
> it to use __u8 like the rest of the netfilter headers.

Applied, thanks.

