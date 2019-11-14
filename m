Return-Path: <SRS0=/b89=ZG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E15FC43215
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 23:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 054C7206F0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 23:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKNXNk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Nov 2019 18:13:40 -0500
Received: from correo.us.es ([193.147.175.20]:50796 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfKNXNk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 18:13:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A55E191902
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 00:13:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CAC7B7FF9
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 00:13:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5229FB7FF6; Fri, 15 Nov 2019 00:13:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FA96B7FF2;
        Fri, 15 Nov 2019 00:13:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 00:13:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 07CAA426CCBA;
        Fri, 15 Nov 2019 00:13:32 +0100 (CET)
Date:   Fri, 15 Nov 2019 00:13:34 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 1/1] netfilter: nf_tables_offload: Fix dangling extack
 pointer
Message-ID: <20191114231334.kyynwmyyxysthzci@salvia>
References: <20191114220139.11138-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114220139.11138-1-saeedm@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Saeed,

Thanks for your patch.

On Thu, Nov 14, 2019 at 10:02:00PM +0000, Saeed Mahameed wrote:
> nft_flow_cls_offload_setup() will setup cls_flow->common->extack to point
> to a local extack object on its stack, this extack pointer is meant to
> be used on nft_setup_cb_call() driver's callbacks, which is called after
> nft_flow_cls_offload_setup() is terminated and thus will lead to a
> dangling pointer.

There's a fix for this in nf-next:

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=be193f5e21d0ec674badef9fde8eca71fb2d8546

Will send a pull request asap.
