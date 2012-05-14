From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libxt_hashlimit: add support for byte-based operation
Date: Mon, 14 May 2012 10:33:50 +0200
Message-ID: <20120514083350.GD9577@1984>
References: <1336483012-12169-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42239 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab2ENIed (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 May 2012 04:34:33 -0400
Content-Disposition: inline
In-Reply-To: <1336483012-12169-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 08, 2012 at 03:16:52PM +0200, Florian Westphal wrote:
> allows --hashlimit-(upto|above) Xb/s [ --hashlimit-burst Yb ]
> to make hashlimit match when X bytes/second are exceeded;
> optionally, Y bytes will not be matched (i.e. bursted).

I have put this in a branch (see iptables git tree).

I'll merge it once we reach with 3.5-rc1.
