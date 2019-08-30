Return-Path: <SRS0=JGmF=W2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96229C3A59B
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 20:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75BBA23429
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 20:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfH3U6K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 16:58:10 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:58896 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728067AbfH3U6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 16:58:10 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i3ny6-0006SE-KB; Fri, 30 Aug 2019 22:58:02 +0200
Date:   Fri, 30 Aug 2019 22:58:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 1/2] netfilter: Terminate rule eval if protocol=IPv6
 and ipv6 module is disabled
Message-ID: <20190830205802.GS20113@breakpoint.cc>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
 <20190830181354.26279-2-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830181354.26279-2-leonardo@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Leonardo Bras <leonardo@linux.ibm.com> wrote:
> If IPv6 is disabled on boot (ipv6.disable=1), but nft_fib_inet ends up
> dealing with a IPv6 packet, it causes a kernel panic in
> fib6_node_lookup_1(), crashing in bad_page_fault.
> 
> The panic is caused by trying to deference a very low address (0x38
> in ppc64le), due to ipv6.fib6_main_tbl = NULL.
> BUG: Kernel NULL pointer dereference at 0x00000038
> 
> The kernel panic was reproduced in a host that disabled IPv6 on boot and
> have to process guest packets (coming from a bridge) using it's ip6tables.
> 
> Terminate rule evaluation when packet protocol is IPv6 but the ipv6 module
> is not loaded.
> 
> Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>

Acked-by: Florian Westphal <fw@strlen.de>
