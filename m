From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH v3 1/2] iptables-nftables: function nft_chain_zero_counters
 added.
Date: Mon, 17 Jun 2013 13:13:08 +0300
Message-ID: <51BEE134.5010406@linux.intel.com>
References: <20130617092600.2814.15883.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41085 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277Ab3FQKNX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:13:23 -0400
In-Reply-To: <20130617092600.2814.15883.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

Minor comments below.

> +
> +		nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,

This line seems to have more than 80 characters.

There is a script in linux kernel sources that might help you before 
sending any patches: scripts/checkpatch.pl
Run it against your patches, it will tell you about such style issues. 
At least at the beginning, at some point code style becomes a reflex.


> +						NLM_F_ACK, h->seq);
> +
> +		nft_chain_nlmsg_build_payload(nlh, c);
> +
> +		ret = mnl_talk(h, nlh, NULL, NULL);
> +		if (ret < 0)
> +			perror("mnl_talk:nft_chain_zero_counters");

I guess you don't want to continue looping after you found your chain. 
On success, make it break.

And on error your function should return the error code.


Tomasz
