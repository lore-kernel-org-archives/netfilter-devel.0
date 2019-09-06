Return-Path: <SRS0=fPey=XB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B732C43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 00:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A5B1206DE
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 00:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389986AbfIFA2E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 20:28:04 -0400
Received: from correo.us.es ([193.147.175.20]:34008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730587AbfIFA2E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 20:28:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 77C6ADA38A
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2019 02:27:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B119DA840
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2019 02:27:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60BA4DA72F; Fri,  6 Sep 2019 02:27:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3737DDA72F;
        Fri,  6 Sep 2019 02:27:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Sep 2019 02:27:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 15ADA4265A5A;
        Fri,  6 Sep 2019 02:27:53 +0200 (CEST)
Date:   Fri, 6 Sep 2019 02:27:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 0/4] netfilter: nf_tables_offload: clean
 offload things when the device unregister
Message-ID: <20190906002754.34ge3qjx3qtu7ao5@salvia>
References: <1567656019-6881-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567656019-6881-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 05, 2019 at 12:00:15PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This series clean the offload things for both chain and rules when the
> related device unregister
> 
> This version add a nft_offload_netdev_iterate common function
> 
> wenxu (4):
>   netfilter: nf_tables_offload: refactor the nft_flow_offload_chain
>     function
>   netfilter: nf_tables_offload: refactor the nft_flow_offload_rule
>     function

1/4 and 2/4 are not required anymore after adding the registration
logic to nf_tables_offload.

>   netfilter: nf_tables_offload: add nft_offload_netdev_iterate function
>   netfilter: nf_tables_offload: clean offload things when the device
>     unregister
> 
>  include/net/netfilter/nf_tables_offload.h |   2 +-
>  net/netfilter/nf_tables_api.c             |   9 ++-
>  net/netfilter/nf_tables_offload.c         | 122 ++++++++++++++++++++++++------
>  3 files changed, 105 insertions(+), 28 deletions(-)
> 
> -- 
> 1.8.3.1
> 
