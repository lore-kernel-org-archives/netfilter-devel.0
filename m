From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables - PATCH 1/2] nft: Optimize chain listing if
 only one is looked for
Date: Thu, 18 Jul 2013 14:10:51 +0300
Message-ID: <51E7CD3B.9020400@linux.intel.com>
References: <1374046455-19234-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1374046455-19234-2-git-send-email-tomasz.bursztyka@linux.intel.com> <20130717134004.GA7893@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4619 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758640Ab3GRLLM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:11:12 -0400
In-Reply-To: <20130717134004.GA7893@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> +		if (chain && strcmp(chain, chain_name) != 0)
> This should be == 0. There's the same checking above __nft_rule_list.
>
> I noticed that we don't need to strcmp(chain, chain_name) again,
> checking for chain is sufficient.

Indeed, was not really awaken. Thanks for fixing further.

Tomasz

