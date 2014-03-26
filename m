From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH] netfilter: nf_tables: Add meta expression key for bridge
 interface name
Date: Wed, 26 Mar 2014 09:15:31 +0200
Message-ID: <53327E93.3040601@linux.intel.com>
References: <1395765587-5399-1-git-send-email-tomasz.bursztyka@linux.intel.com> <20140325204331.GA3491@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58869 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaCZHPw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:15:52 -0400
In-Reply-To: <20140325204331.GA3491@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I really think we have to use Patrick's new infrastructure that allows
> us to add new expression flavours per family.

I actually used this, look at the end of the patch.
However, since I did not wanted to rewrite a specific 
nft_meta_select_ops, I used this trick.
Makes it messy anyway yes, I will change that.

>   It should just need a
> couple of exported symbols in nft_meta.c that you can use from the new
> net/bridge/netfilter/nft_meta.c file. We should avoid these ifdef
> games.

I agree, looks ugly.

Will prepare a proper patch

Tomasz
