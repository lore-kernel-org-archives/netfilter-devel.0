From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] xtables: bootstrap xtables-eb for nftables
Date: Wed, 1 Oct 2014 21:20:11 +0200
Message-ID: <20141001192011.GA7652@salvia>
References: <1412174830-3620-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38992 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaJATTE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:19:04 -0400
Content-Disposition: inline
In-Reply-To: <1412174830-3620-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

On Wed, Oct 01, 2014 at 04:47:08PM +0200, Giuseppe Longo wrote:
> This patch bootstraps xtables-eb for the nftables compatibility layer

I have pushed these patches to this branch in iptables:

http://git.netfilter.org/iptables/log/?h=ebtables-compat-experimental

I have forward-ported the patchset to run on top of the recent
nft_xt_ctx changes.

There is still a good amount of work to be done to get this in good
shape:

1) The output of ebtables-compat -L should look the same like
   ebtables -L.

1) Fix segfaults. I detected one when you use -h, and another if you
   don't pass any target. Those should be easy to fix IMO.

2) Fix listing. If I add:

ebtables-compat -I INPUT --logical-in br0 -j ACCEPT

shows:

-d 62:72:30:0:0:0 --logical-in br0 -j ACCEPT

Note the -d seem incorrect.

3) I have added ebtables NAT table support. It's basically a filter
   table. I needed a small kernel patch though since the bridge filter
   chain type is not allowing to filter at prerouting and postrouting.

4) Add support for matches and targets.

I'll have a look at this later again, but it would be great if you can
send incremental patches to resolve the existing issues. Thanks.
