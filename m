Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6334C43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 11:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA29121670
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 11:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfD3Lsx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 07:48:53 -0400
Received: from mail.us.es ([193.147.175.20]:50032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbfD3Lsw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 58DDA96EC9
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 13:48:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 446C5DA720
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 13:48:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 41D92DA716; Tue, 30 Apr 2019 13:48:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33442DA720;
        Tue, 30 Apr 2019 13:48:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Apr 2019 13:48:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EF8D940705C0;
        Tue, 30 Apr 2019 13:48:47 +0200 (CEST)
Date:   Tue, 30 Apr 2019 13:48:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2 0/3] netfilter: nf_flow_table: fix several
 flowtable bugs
Message-ID: <20190430114847.4s7cn2xhigufk2e7@salvia>
References: <20190429165506.1202-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429165506.1202-1-ap420073@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 30, 2019 at 01:55:06AM +0900, Taehee Yoo wrote:
> This patch set fixes several bugs in the flowtable modules.
> 
> First patch fixes netdev refcnt leak bug.
> The flow offload routine allocates a dst_entry and that has 1 refcnt.
> So the dst_release() should be called.
> This patch just adds missing dst_release() in the end of
> nft_flow_offload_eval().
> 
> Second patch adds ttl value check routine.
> Flow offload data-path routine decreases ttl value. but it doesn't check
> ttl value.
> This patch just adds ttl value check routine.
> If ttl value is under 1, the packet will be passed up to the L3.
> 
> Third patch adds CT condition check routine into flow offload routines.
> a flow offloaded CT can be deleted by masquerade notifier. if so,
> the flow offload shouldn't be used in flow offload data-path and
> the GC should delete that.

Series applied, thanks.
