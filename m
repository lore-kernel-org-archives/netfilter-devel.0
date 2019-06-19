Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138CCC31E5B
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 17:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E05422084E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 17:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbfFSRfp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 13:35:45 -0400
Received: from mail.us.es ([193.147.175.20]:38312 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfFSRfp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 13:35:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 32A13C1D52
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 19:35:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23159DA707
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 19:35:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 18A3BDA705; Wed, 19 Jun 2019 19:35:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0CCBDA70A;
        Wed, 19 Jun 2019 19:35:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 19:35:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CEBD74265A2F;
        Wed, 19 Jun 2019 19:35:40 +0200 (CEST)
Date:   Wed, 19 Jun 2019 19:35:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3] src: prefer meta protocol as bridge l3 dependency
Message-ID: <20190619173540.hafxdeb4jnjhoq6z@salvia>
References: <20190618184359.29760-1-fw@strlen.de>
 <20190618184359.29760-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618184359.29760-4-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 08:43:59PM +0200, Florian Westphal wrote:
> On families other than 'ip', the rule
> 
> ip protocol icmp
> 
> needs a dependency on the ip protocol so we do not treat e.g. an ipv6
> header as ip.
> 
> Bridge currently uses eth_hdr.type for this, but that will cause the
> rule above to not match in case the ip packet is within a VLAN tagged
> frame -- ether.type will appear as ETH_P_8021Q.
> 
> Due to vlan tag stripping, skb->protocol will be ETH_P_IP -- so prefer
> to use this instead.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
