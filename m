From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH nft] src: add xt compat support
Date: Mon, 01 Jul 2013 10:09:54 +0300
Message-ID: <51D12B42.40806@linux.intel.com>
References: <1372608125-28734-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, eric@regit.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39926 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3GAHJ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:09:58 -0400
In-Reply-To: <1372608125-28734-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Are you sure you want this feature?
iptables-nftables has been planned to provide full compat with iptables, 
so it hides the nft commands.

But, little by little, the point is to move on with nft tool only, when 
people will realize it brings cooler stuff.
And I am afraid that, with such patch, we are going to maintain legacy 
stuff also in nft.

To me I see iptables-nftables being the only entry point for legacy 
commands, and nowhere else.

Being able to list partially match/target (type and names) would be 
fine. But manipulating those should be only through iptables-nftables imho.

Br,

Tomasz


