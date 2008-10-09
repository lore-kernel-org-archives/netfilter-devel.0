From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [PATCH] Helper modules load-on-demand support for
 ctnetlink
Date: Thu, 09 Oct 2008 15:43:54 +0200
Message-ID: <48EE0A9A.7010706@trash.net>
References: <20081009083339.9824.24056.stgit@Decadence> <20081009083422.9824.35589.stgit@Decadence> <48EE085E.2020701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51569 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYJINn5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:43:57 -0400
In-Reply-To: <48EE085E.2020701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> This one doesn't apply:
> 
> patching file include/net/netfilter/nf_conntrack_helper.h
> patching file net/netfilter/nf_conntrack_core.c
> Hunk #1 FAILED at 581.
> Hunk #2 succeeded at 753 (offset -5 lines).
> Hunk #3 succeeded at 764 (offset -5 lines).
> 1 out of 3 hunks FAILED -- saving rejects to file 
> net/netfilter/nf_conntrack_core.c.rej
> patching file net/netfilter/nf_conntrack_helper.c
> patching file net/netfilter/nf_conntrack_netlink.c
> Hunk #2 succeeded at 1131 with fuzz 1.
> patching file net/netfilter/nfnetlink.c

Oops, I think I didn't refresh my tree, so it didn't include any
of the netfilter patches I sent to Dave :)

The remaining issues, especially the nfnl_lock think, should be
fixed though.
