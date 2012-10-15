From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter : fix hooks for SNAT and DNAT targets
Date: Mon, 15 Oct 2012 23:14:19 +0200
Message-ID: <20121015211419.GA32259@1984>
References: <1350297888-3363-1-git-send-email-elison.niven@cyberoam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	sanket.shah@cyberoam.com
To: Elison Niven <elison.niven@cyberoam.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33022 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab2JOVOY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:14:24 -0400
Content-Disposition: inline
In-Reply-To: <1350297888-3363-1-git-send-email-elison.niven@cyberoam.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 15, 2012 at 04:14:48PM +0530, Elison Niven wrote:
> Correct hooks for SNAT and DNAT targets in xt_nat.c :
> SNAT hooks should be POST_ROUTING and LOCAL_IN.
> DNAT hooks should be PRE_ROUTING and LOCAL_OUT.

Good catch. Applied, thanks.
