From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [v2 PATCH 1/2] NETFILTER module xt_hmark new target for HASH
 based fw
Date: Sun, 13 Nov 2011 18:05:28 +0100
Message-ID: <20111113170528.GB16851@1984>
References: <0hivdsb.f18682ec9367f08c76301d993553f1b8@obelix.schillstrom.com>
 <20111108105110.GA15798@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hans Schillstrom <hans.schillstrom@ericsson.com>, kaber@trash.net,
	jengelh@medozas.de, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44872 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab1KMRFj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Nov 2011 12:05:39 -0500
Content-Disposition: inline
In-Reply-To: <20111108105110.GA15798@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

BTW, I think you should split xt_HMARK to ipt_HMARK and ip6t_HMARK
(see recent Florian Westphal patches regarding reserve lookup for
instance).

The IPv4 and IPv6 parts for HMARK look so different that I don't think
it makes sense to keep them into one single xt_HMARK thing with all
those conditional ifdefs for IPV6.
