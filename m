From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables RFC v3 PATCH 11/16] nft: Refactor firewall
 printing so it reuses already parsed cs struct
Date: Mon, 12 Aug 2013 10:54:27 +0300
Message-ID: <520894B3.50209@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1376055090-26551-12-git-send-email-tomasz.bursztyka@linux.intel.com> <20130809215145.GB7102@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:44457 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab3HLHy3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:54:29 -0400
In-Reply-To: <20130809215145.GB7102@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I like patches from 11 to 13, that refactorization save us quite some
> code and the result in one single parsing and we also work with the
> command structure.
>
> Please, can you send me these three patches in first place?

Not impossible but means a big rebase of this patchset.
(it currently needs translation stuff, or then it would require some 
work to handle target/matches properly as original code does not in 
nft_rule_to_iptables_command_state, without solving pure-nft expressed 
extensions of course)

Could you recheck in detail patches 3/16 and 4/16?
If there is no flaws in the translation engine, we might just go for it 
at it is.

Thanks,

Tomasz
