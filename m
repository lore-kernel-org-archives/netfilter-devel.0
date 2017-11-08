From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_defrag_ipv4: Add sysctl to disable
 per interface
Date: Wed, 8 Nov 2017 05:34:51 +0100
Message-ID: <20171108043451.GC1530@salvia>
References: <1509762520-17873-1-git-send-email-subashab@codeaurora.org>
 <20171107103013.GA5512@breakpoint.cc>
 <8c74f85d5f668516766ed208cb8eb415@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        steffen.klassert@secunet.com
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47274 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751015AbdKHEfE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2017 23:35:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A1B2C0B3E
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2017 05:35:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BC87DA840
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2017 05:35:02 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <8c74f85d5f668516766ed208cb8eb415@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 07, 2017 at 11:58:40AM -0700, Subash Abhinov Kasiviswanathan wrote:
> >This breaks connection tracking for packets coming in via such
> >interfaces.
> >
> >Nowadays we only enable defrag in a network namespace if the ip/nftables
> >ruleset requires it, so this setting would be counter-productive.
[...]
> This usecase is run on an Android based device, so there will be only
> the init namespace. While the specific rmnet interfaces for wifi calling do
> not require conntrack / iptables, some other scenarios like NAT on other
> interfaces may trigger the load of the defrag module. Hence, we needed
> this interface specific way of preventing defrag.

We can probably skip defrag if explicit notrack is requested via rule.
