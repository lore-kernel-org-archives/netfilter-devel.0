From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/4] netfilter: move generic TEE code from
 xtables to nf_tee_ipv{4,6} modules
Date: Tue, 16 Jun 2015 18:33:46 +0200
Message-ID: <20150616163346.GA8671@salvia>
References: <1434110378-6284-1-git-send-email-pablo@netfilter.org>
 <1434110378-6284-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36850 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbbFPQ21 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 12:28:27 -0400
Content-Disposition: inline
In-Reply-To: <1434110378-6284-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

I'd appreciate your feedback on some small design issue on TEE for
nftables.

Basically, the initial patcheset allows this:

        nft add rule ... tee gateway 1.2.3.4

and
        nft add rule ... tee oifname eth0 gateway 1.2.3.4

then, internally, this takes a NFTA_TEE_GATEWAY attribute that
contains the inet address.

The question is if it's worth passing a register instead to indicate
the gateway, ie. NFTA_TEE_GATEWAY_SREG. Thus, we can use maps to set
this, eg.

    nft add rule ... tee gateway ip saddr map { 4.3.2.1 : 1.2.3.4 }

Then, we have interfaces, but we actually need to subscribe to netdev
events to make sure the pointer to net_device is still valid.

Do you think it's worth the effort? I've been spinning on this when I
remember about nft_queue and I think it would be good to get support
done so we can use maps there too.

Let me know, thanks!
