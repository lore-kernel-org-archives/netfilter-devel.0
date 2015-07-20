From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nf_conntrack: add efficient
 mark to zone mapping
Date: Mon, 20 Jul 2015 19:03:27 +0200
Message-ID: <20150720170327.GA22681@salvia>
References: <cover.1436574843.git.daniel@iogearbox.net>
 <8b1e8907e8dd9a51f2e40b39cd5f5c2b0eae94fd.1436574843.git.daniel@iogearbox.net>
 <20150715175056.GA7436@salvia>
 <55A6BCD8.2010905@iogearbox.net>
 <55AD1F6F.1090607@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59562 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbbGTQ5n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 12:57:43 -0400
Content-Disposition: inline
In-Reply-To: <55AD1F6F.1090607@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 20, 2015 at 06:18:55PM +0200, Daniel Borkmann wrote:
[...]
> The current approach implemented here that I found so far most appealing
> and having the least complexity, was to just have a /single/ template and to
> overwrite the zone->id with skb->mark on the ptr we have sitting on the stack.
> It avoids all the issues mentioned. But perhaps you mean something entirely
> different and I just seem to misinterpret your answer, hmm.

You mean something that from command line would look like:

        iptables -A PREROUTING -t raw -j CT --zone mark

So we set the zone ID in the CT target based on the existing mark,
right?
