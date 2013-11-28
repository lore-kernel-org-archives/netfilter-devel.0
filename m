From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC nftables kernel PATCH] netfilter: nf_tables: fix nft_meta_target
 module
Date: Thu, 28 Nov 2013 14:33:51 +0200
Message-ID: <5297382F.60707@linux.intel.com>
References: <20131128111557.6154.40370.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24675 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3K1Mdx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:33:53 -0500
In-Reply-To: <20131128111557.6154.40370.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

Minor stuff:

> + * @NFT_META_TARGET_MARK: to stablish packet mark (skb->mark)

to 'e'stablish

Why not reusing existing NFT_META_* keys?
It would just raise an error if not priority/mark/nftrace/secmark, as it 
does currently.
Worth to keep that as it is imho, no need to duplicate.

Besides that, any other name that would be more relevant than meta_target?
Target is already a critical in-use keyword in netfilter, so it's not 
clear enough.
All expression have a short, one-word based name, which is nice.


Anyway, doesn't it work already: if you create an immediate expression 
(to load the value you want, at default dreg 0 aka NFT_REG_VERDICT) and 
a meta expression without the NFTA_META_DREG set? (didn't try myself)

If not maybe there is a shorter way to fix this, instead of creating a 
full new expression. Looks like it was the original plan.


Tomasz
