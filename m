Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33ABC282E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 08:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7837F20656
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 08:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfDVIiD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 04:38:03 -0400
Received: from mail.us.es ([193.147.175.20]:43138 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfDVIiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 04:38:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 375C427F8CF
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 10:38:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26EA4DA729
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 10:38:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2518DDA71F; Mon, 22 Apr 2019 10:38:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D97A0DA70F;
        Mon, 22 Apr 2019 10:37:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 10:37:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B009D4265A31;
        Mon, 22 Apr 2019 10:37:58 +0200 (CEST)
Date:   Mon, 22 Apr 2019 10:37:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Michal Soltys <soltys@ziu.info>
Subject: Re: [PATCH nf] netfilter: never get/set skb->tstamp
Message-ID: <20190422083758.azexcuepqmqw5zc3@salvia>
References: <9cf8e521-8aa6-c022-e491-d3e6cfe0aca6@ziu.info>
 <20190417001723.17912-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417001723.17912-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 17, 2019 at 02:17:23AM +0200, Florian Westphal wrote:
> setting net.netfilter.nf_conntrack_timestamp=1 breaks xmit with fq
> scheduler.  skb->tstamp might be "refreshed" using ktime_get_real(),
> but fq expects CLOCK_MONOTONIC.
> 
> This patch removes all places in netfilter that check/set skb->tstamp:
> 
> 1. To fix the bogus "start" time seen with conntrack timestamping for
>    outgoing packets, never use skb->tstamp and always use current time.
> 2. In nfqueue and nflog, only use skb->tstamp for incoming packets,
>    as determined by current hook (prerouting, input, forward).
> 3. xt_time has to use system clock as well rather than skb->tstamp.
>    We could still use skb->tstamp for prerouting/input/foward, but
>    I see no advantage to make this conditional.

Applied, thanks Florian.
