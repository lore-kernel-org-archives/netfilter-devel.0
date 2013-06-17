From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 1/2] iptables-nftables: function
 nft_chain_zero_counters added.
Date: Mon, 17 Jun 2013 13:29:17 +0200
Message-ID: <20130617112917.GA3734@localhost>
References: <20130617092600.2814.15883.stgit@localhost>
 <51BEE134.5010406@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36672 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab3FQL3W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:29:22 -0400
Content-Disposition: inline
In-Reply-To: <51BEE134.5010406@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 17, 2013 at 01:13:08PM +0300, Tomasz Bursztyka wrote:
> Hi Giuseppe,
> 
> Minor comments below.
> 
> >+
> >+		nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
> 
> This line seems to have more than 80 characters.
> 
> There is a script in linux kernel sources that might help you before
> sending any patches: scripts/checkpatch.pl
> Run it against your patches, it will tell you about such style
> issues. At least at the beginning, at some point code style becomes
> a reflex.
> 
> 
> >+						NLM_F_ACK, h->seq);
> >+
> >+		nft_chain_nlmsg_build_payload(nlh, c);
> >+
> >+		ret = mnl_talk(h, nlh, NULL, NULL);
> >+		if (ret < 0)
> >+			perror("mnl_talk:nft_chain_zero_counters");
> 
> I guess you don't want to continue looping after you found your
> chain. On success, make it break.
> 
> And on error your function should return the error code.

While at it, please also merge patch 1/2 and 2/2, we need that the
repository remains consistent across updates. Thanks.
