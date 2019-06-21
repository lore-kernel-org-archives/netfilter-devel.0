Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DEEC43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 15:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EAB3206B7
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 15:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfFUPVF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 11:21:05 -0400
Received: from mail.us.es ([193.147.175.20]:47048 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfFUPVE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 11:21:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18DADEDB04
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 17:21:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 088DBDA70C
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 17:21:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F214FDA707; Fri, 21 Jun 2019 17:21:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0692FDA704;
        Fri, 21 Jun 2019 17:21:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Jun 2019 17:21:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D9A184265A2F;
        Fri, 21 Jun 2019 17:21:00 +0200 (CEST)
Date:   Fri, 21 Jun 2019 17:21:00 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>, wenxu <wenxu@ucloud.cn>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: fix nf_conntrack_bridge/ipv6 link
 error
Message-ID: <20190621152100.ljm25njdzaq2ek7i@salvia>
References: <20190617131515.2334941-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617131515.2334941-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 03:15:04PM +0200, Arnd Bergmann wrote:
> When CONFIG_IPV6 is disabled, the bridge netfilter code
> produces a link error:
> 
> ERROR: "br_ip6_fragment" [net/bridge/netfilter/nf_conntrack_bridge.ko] undefined!
> ERROR: "nf_ct_frag6_gather" [net/bridge/netfilter/nf_conntrack_bridge.ko] undefined!
> 
> The problem is that it assumes that whenever IPV6 is not a loadable
> module, we can call the functions direction. This is clearly
> not true when IPV6 is disabled.
> 
> There are two other functions defined like this in linux/netfilter_ipv6.h,
> so change them all the same way.

Applied, thanks Arnd.
