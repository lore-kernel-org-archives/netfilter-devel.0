Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B523EC282CE
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 12:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8655E20848
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 12:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfDMM52 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 08:57:28 -0400
Received: from mail.us.es ([193.147.175.20]:51642 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbfDMM52 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 08:57:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91D92DC9BC
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 14:57:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EBE1DA713
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 14:57:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6F2BCDA70C; Sat, 13 Apr 2019 14:57:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6EDA6DA703;
        Sat, 13 Apr 2019 14:57:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 13 Apr 2019 14:57:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4D9FF4265A31;
        Sat, 13 Apr 2019 14:57:24 +0200 (CEST)
Date:   Sat, 13 Apr 2019 14:57:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alexander Potapenko <glider@google.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        linux-kernel@vger.kernel.org, dvyukov@google.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: initialize ct->timeout
Message-ID: <20190413125723.qtbtwyhy6o5srla3@salvia>
References: <20190328094720.25399-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328094720.25399-1-glider@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 28, 2019 at 10:47:20AM +0100, Alexander Potapenko wrote:
> KMSAN started reporting an error when accessing ct->timeout for the
> first time without initialization:
> 
>  BUG: KMSAN: uninit-value in __nf_ct_refresh_acct+0x1ae/0x470 net/netfilter/nf_conntrack_core.c:1765

Applied, thanks.
