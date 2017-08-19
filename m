From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/4] netfilter: nftables: tcp mss mangling support
Date: Sat, 19 Aug 2017 14:05:59 +0200
Message-ID: <20170819120559.GA4872@salvia>
References: <20170808131530.29194-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:39096 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751655AbdHSMGY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 08:06:24 -0400
Content-Disposition: inline
In-Reply-To: <20170808131530.29194-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 08, 2017 at 03:15:26PM +0200, Florian Westphal wrote:
> This series adds the needed kernel parts to support tcp mss mangling.
> First two patches rework exthdr so we don't have to copy-paste too much,
> patch 3 adds tcp option mangling support.
> 
> Last patch allows to retrieve path tcpmss via rt expression, this is so we
> can support iptables TCPMSS --clamp-to-pmtu by combining the two, i.e.:
> 
> nft add rule inet mangle forward tcp option mss set rt mss

Series applied, thanks Florian.

Please, post your userspace patchset.
