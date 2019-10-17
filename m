Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E938AFA372A
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 10:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC5C32082C
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 10:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732916AbfJQKUr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 06:20:47 -0400
Received: from correo.us.es ([193.147.175.20]:34872 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfJQKUr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 06:20:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 334EB11EB8E
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 12:20:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23C84DA801
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 12:20:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 19402B8007; Thu, 17 Oct 2019 12:20:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D258B7FF6;
        Thu, 17 Oct 2019 12:20:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 12:20:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0B95441E4800;
        Thu, 17 Oct 2019 12:20:40 +0200 (CEST)
Date:   Thu, 17 Oct 2019 12:20:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Edward Cree <ecree@solarflare.com>
Subject: Re: [PATCH v2 nf-next] netfilter: add and use nf_hook_slow_list()
Message-ID: <20191017102042.emoxv5oesxov4oxv@salvia>
References: <20191010223037.10811-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010223037.10811-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 11, 2019 at 12:30:37AM +0200, Florian Westphal wrote:
> At this time, NF_HOOK_LIST() macro will iterate the list and then calls
> nf_hook() for each individual skb.
> 
> This makes it so the entire list is passed into the netfilter core.
> The advantage is that we only need to fetch the rule blob once per list
> instead of per-skb.
> 
> NF_HOOK_LIST now only works for ipv4 and ipv6, as those are the only
> callers.
> 
> v2: use skb_list_del_init() instead of list_del (Edward Cree)
> 
> Cc: Edward Cree <ecree@solarflare.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied.
