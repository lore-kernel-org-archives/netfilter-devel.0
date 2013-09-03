From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH v2] nft: refactoring parse operations
 for more genericity
Date: Tue, 03 Sep 2013 10:38:55 +0300
Message-ID: <5225920F.8040507@linux.intel.com>
References: <1378128246-7593-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:60394 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab3ICHjQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:39:16 -0400
In-Reply-To: <1378128246-7593-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

> -	cs->target = target;
> +
> +	ops = nft_family_ops_lookup(family);
> +	ops->parse_target(data, target);

Did not catch that one. Easy to spot.

Tomasz
