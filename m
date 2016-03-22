From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests/shell: add chain validations tests
Date: Tue, 22 Mar 2016 20:20:19 +0100
Message-ID: <20160322192019.GA7551@salvia>
References: <145865193086.6118.9200431804176858644.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44867 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbcCVTUY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 15:20:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C1393C9EC2
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 20:20:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A8BCCDA38C
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 20:20:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 941C0CF8B6
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 20:20:20 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145865193086.6118.9200431804176858644.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 02:06:09PM +0100, Arturo Borrero Gonzalez wrote:
> Some basic test regarding chains: jumps and validations.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> NOTE: the testcases/chains/0009masquerade_jump_1 file fails, seems like a bug
> in the kernel validation. Needs more investigation.

I can see this there:

> +$NFT add chain t output {type nat hook output priority 0 \; }

We only support masquerade from postrouting.

static struct xt_target masquerade_tg_reg __read_mostly = {                      
        .name           = "MASQUERADE",                                          
        .family         = NFPROTO_IPV4,                                          
        .target         = masquerade_tg,                                         
        .targetsize     = sizeof(struct nf_nat_ipv4_multi_range_compat),         
        .table          = "nat",                                                 
        .hooks          = 1 << NF_INET_POST_ROUTING,   

BTW, it would be good to add more tests to exercise the chain loop
detection code.

Please, fix and resubmit, thanks.
