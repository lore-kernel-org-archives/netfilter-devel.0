Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DE8C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 21:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4C9D20870
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 21:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfIBVMU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 17:12:20 -0400
Received: from correo.us.es ([193.147.175.20]:47340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfIBVMU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 17:12:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C1B1B172C74
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2019 23:12:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B363D10219C
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2019 23:12:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A8B4E10079B; Mon,  2 Sep 2019 23:12:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F109CA0F3;
        Mon,  2 Sep 2019 23:12:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Sep 2019 23:12:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1E1944265A5A;
        Mon,  2 Sep 2019 23:12:14 +0200 (CEST)
Date:   Mon, 2 Sep 2019 23:12:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: nf_table_offload: Fix the
 incorrect rcu usage in nft_indr_block_get_and_ing_cmd
Message-ID: <20190902211215.5wyw7esdtecmr3hn@salvia>
References: <1566220952-27225-1-git-send-email-wenxu@ucloud.cn>
 <f8951093-2874-847e-4a3c-0e4cc69b6f6f@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8951093-2874-847e-4a3c-0e4cc69b6f6f@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 02, 2019 at 02:14:54PM +0800, wenxu wrote:
> Hi pablo,
> 
> any other questions about this patch?

Please, rebase:

https://patchwork.ozlabs.org/patch/1156728/
https://patchwork.ozlabs.org/patch/1156729/
