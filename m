Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F7EC282DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 11:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CB1D2073F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 11:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbfDQLbA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 07:31:00 -0400
Received: from mail.us.es ([193.147.175.20]:49006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731659AbfDQLbA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 07:31:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B2FA211EB28
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2019 13:30:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9ADEBDA711
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2019 13:30:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 985E3DA70C; Wed, 17 Apr 2019 13:30:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81E05DA709;
        Wed, 17 Apr 2019 13:30:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 17 Apr 2019 13:30:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6101D4265A31;
        Wed, 17 Apr 2019 13:30:55 +0200 (CEST)
Date:   Wed, 17 Apr 2019 13:30:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xiaozhou Liu <liuxiaozhou@bytedance.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        zhangyongsu@bytedance.com, wenxudong@bytedance.com
Subject: Re: RFC: NAT's default behavior of forwarding un-NATed packets
Message-ID: <20190417113054.nc3fetyoy2duywyg@salvia>
References: <20190417080242.jas4vongrv5fivzx@bytedancedeMacBook-Air.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417080242.jas4vongrv5fivzx@bytedancedeMacBook-Air.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 17, 2019 at 04:02:44PM +0800, Xiaozhou Liu wrote:
> Hi,
> 
> We find that our SNAT sometimes forwards un-NATed packets out as-is. This
> behavior confused us for a while until we saw this in
> net/netfilter/nf_nat_core.c:
> 
>        ct = nf_ct_get(skb, &ctinfo);
>        /* Can't track?  It's not due to stress, or conntrack would
>         * have dropped it.  Hence it's the user's responsibilty to
>         * packet filter it out, or implement conntrack/NAT for that
>         * protocol. 8) --RR
>         */
>        if (!ct)
>               return NF_ACCEPT;
> 
> The code and comment are very clear. So it is not kernel's responsibility,
> at least in RR's point of view. We added filtering shortly afterwards.
> 
> But as normal users, we really want a NAT server which can work out of box as
> expected from users' point of view. That said, if any packet that is bad (in
> our case, orphaned SYN-ACK and FIN packets going out without getting a chance
> to setup conntrack), it's better to drop them in kernel by default.
> 
> Is there any possibility to change this default behavior?

You can just drop invalid traffic via policy.
