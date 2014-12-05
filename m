From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2] payload: fix endianess issue in
 payload_expr_pctx_update()
Date: Fri, 5 Dec 2014 11:44:44 +0100
Message-ID: <20141205104444.GC3746@salvia>
References: <1417700189-11337-1-git-send-email-pablo@netfilter.org>
 <5481531B.9090105@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35696 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaLEKm0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:42:26 -0500
Content-Disposition: inline
In-Reply-To: <5481531B.9090105@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 05, 2014 at 07:39:23AM +0100, leroy christophe wrote:
> Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>

Applied, thanks for reporting and testing.
