From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH] nft: refactoring parse operations for
 more genericity
Date: Mon, 02 Sep 2013 12:26:08 +0300
Message-ID: <522459B0.2080109@linux.intel.com>
References: <1377869753-9093-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62630 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758202Ab3IBJ0M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:26:12 -0400
In-Reply-To: <1377869753-9093-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

>   	case NFT_GOTO:
> -		ops = nft_family_ops_lookup(family);
> -		ops->parse_immediate(cs);
> +		nft_goto = true;
> +		break;

You added a bogus "break" here: it should fall to NFT_JUMP to set the 
chain as the jumpto.
That's the bug Pablo has found.

Tomasz
