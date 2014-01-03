From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: remove dead code
Date: Fri, 3 Jan 2014 23:53:25 +0100
Message-ID: <20140103225325.GC18357@localhost>
References: <20131230171608.211bac4f@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37817 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbaACWx3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:53:29 -0500
Content-Disposition: inline
In-Reply-To: <20131230171608.211bac4f@nehalam.linuxnetplumber.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 30, 2013 at 05:16:08PM -0800, Stephen Hemminger wrote:
> The following code is not used in current upstream code.
> Some of this seems to be old hooks, other might be used by some
> out of tree module (which I don't care about breaking), and
> the need_ipv4_conntrack was used by old NAT code but no longer
> called.

Also applied, thanks.
