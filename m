Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB65C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 16:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A3BB218AC
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 16:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfIHQXt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 12:23:49 -0400
Received: from correo.us.es ([193.147.175.20]:52902 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfIHQXt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 12:23:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7128DDA72B
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 18:23:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62C50DA72F
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 18:23:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 58352D2B1F; Sun,  8 Sep 2019 18:23:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A09ADA72F;
        Sun,  8 Sep 2019 18:23:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 08 Sep 2019 18:23:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3A2B54265A5A;
        Sun,  8 Sep 2019 18:23:43 +0200 (CEST)
Date:   Sun, 8 Sep 2019 18:23:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     wenxu@ucloud.cn
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_tables_offload: move indirect
 flow_block callback logic to core
Message-ID: <20190908162344.tnh5xeeniojmsni4@salvia>
References: <20190902211132.32200-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902211132.32200-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 02, 2019 at 11:11:31PM +0200, Pablo Neira Ayuso wrote:
> Add nft_offload_init() and nft_offload_exit() function to deal with the
> init and the exit path of the offload infrastructure.
> 
> Rename nft_indr_block_get_and_ing_cmd() to nft_indr_block_cb().

I have applied this patch.

I'm going to keep back 2/2, so you can use __nft_offload_get_chain()
to fix nft_indr_block_cb() in one go.
