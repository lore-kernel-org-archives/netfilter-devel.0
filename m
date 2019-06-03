Return-Path: <SRS0=Me6e=UC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CDBC04AB6
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jun 2019 09:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD77D27FC5
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jun 2019 09:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfFCJVe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jun 2019 05:21:34 -0400
Received: from mail.us.es ([193.147.175.20]:48822 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbfFCJVd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jun 2019 05:21:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 02E93C3286
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jun 2019 11:21:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9D40DA716
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jun 2019 11:21:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DF009DA714; Mon,  3 Jun 2019 11:21:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA05ADA708;
        Mon,  3 Jun 2019 11:21:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 03 Jun 2019 11:21:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6F1214265A5B;
        Mon,  3 Jun 2019 11:21:29 +0200 (CEST)
Date:   Mon, 3 Jun 2019 11:21:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] netfilter: ipv6: Fix undefined symbol
 nf_ct_frag6_gather
Message-ID: <20190603092128.47omjnvbqxzealst@salvia>
References: <1559483366-12371-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559483366-12371-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 02, 2019 at 09:49:26PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> CONFIG_NETFILTER=m and CONFIG_NF_DEFRAG_IPV6 is not set
> 
> ERROR: "nf_ct_frag6_gather" [net/ipv6/ipv6.ko] undefined!
> 
> Fixes: c9bb6165a16e ("netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!
