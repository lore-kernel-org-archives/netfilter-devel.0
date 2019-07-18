Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C99C7618F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 18:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16CEA21019
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 18:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391161AbfGRSaQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 14:30:16 -0400
Received: from mail.us.es ([193.147.175.20]:39424 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391151AbfGRSaQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 14:30:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5052DB5AB0
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 20:30:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40BA51150CE
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 20:30:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 22609FF6CC; Thu, 18 Jul 2019 20:30:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7281C202D2;
        Thu, 18 Jul 2019 20:30:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 18 Jul 2019 20:30:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 49BF44265A31;
        Thu, 18 Jul 2019 20:30:11 +0200 (CEST)
Date:   Thu, 18 Jul 2019 20:30:10 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kadlec@netfilter.org, fw@strlen.de,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        wenxu@ucloud.cn, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nft_meta: Fix build error
Message-ID: <20190718183010.s243aiunyycpz3np@salvia>
References: <20190709070126.29972-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709070126.29972-1-yuehaibing@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 09, 2019 at 03:01:26PM +0800, YueHaibing wrote:
> If NFT_BRIDGE_META is y and NF_TABLES is m, building fails:
> 
> net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_get_init':
> nft_meta_bridge.c:(.text+0xd0): undefined reference to `nft_parse_register'
> nft_meta_bridge.c:(.text+0xec): undefined reference to `nft_validate_register_store'

I took this one from Arnd instead:

https://patchwork.ozlabs.org/patch/1130262/

Thanks.
