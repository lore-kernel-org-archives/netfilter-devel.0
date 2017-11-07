From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH nf-next] netfilter: nf_defrag_ipv4: Add sysctl to disable
 per interface
Date: Tue, 07 Nov 2017 11:58:40 -0700
Message-ID: <8c74f85d5f668516766ed208cb8eb415@codeaurora.org>
References: <1509762520-17873-1-git-send-email-subashab@codeaurora.org>
 <20171107103013.GA5512@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, steffen.klassert@secunet.com,
        pablo@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50774 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751930AbdKGS6l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2017 13:58:41 -0500
In-Reply-To: <20171107103013.GA5512@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> This breaks connection tracking for packets coming in via such
> interfaces.
> 
> Nowadays we only enable defrag in a network namespace if the 
> ip/nftables
> ruleset requires it, so this setting would be counter-productive.

Hi Florian

This usecase is run on an Android based device, so there will be only
the init namespace. While the specific rmnet interfaces for wifi calling 
do
not require conntrack / iptables, some other scenarios like NAT on other
interfaces may trigger the load of the defrag module. Hence, we needed
this interface specific way of preventing defrag.

>> An example of this usage is for fixing wifi calling on networks
>> where certain routers are configured to drop fragments explicitly.
> 
> Yay...  does that happen for all frags or is this related to df bit
> somehow?

Based on our observations, the routers usually drop all fragmented
packets possibly for security reasons.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
