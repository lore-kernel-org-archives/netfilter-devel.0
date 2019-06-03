Return-Path: <SRS0=Me6e=UC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE31C04AB5
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jun 2019 14:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72A9124C39
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jun 2019 14:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbfFCOOE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jun 2019 10:14:04 -0400
Received: from mail.us.es ([193.147.175.20]:40088 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbfFCOOD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jun 2019 10:14:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 56563FC418
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jun 2019 16:14:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 358B4DA712
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jun 2019 16:14:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2B049DA710; Mon,  3 Jun 2019 16:14:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08453DA702;
        Mon,  3 Jun 2019 16:13:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 03 Jun 2019 16:13:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DCAC44265A2F;
        Mon,  3 Jun 2019 16:13:57 +0200 (CEST)
Date:   Mon, 3 Jun 2019 16:13:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     davem@davemloft.net
Cc:     wenxu@ucloud.cn, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] netfilter: ipv6: Fix undefined symbol
 nf_ct_frag6_gather
Message-ID: <20190603141357.3pf6y55sf3elw654@salvia>
References: <1559483366-12371-1-git-send-email-wenxu@ucloud.cn>
 <20190603092128.47omjnvbqxzealst@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603092128.47omjnvbqxzealst@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 03, 2019 at 11:21:28AM +0200, Pablo Neira Ayuso wrote:
> On Sun, Jun 02, 2019 at 09:49:26PM +0800, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > CONFIG_NETFILTER=m and CONFIG_NF_DEFRAG_IPV6 is not set

Just noted that this should be:

CONFIG_IPV6=m

> > ERROR: "nf_ct_frag6_gather" [net/ipv6/ipv6.ko] undefined!
> > 
> > Fixes: c9bb6165a16e ("netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y")
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

nf-next is already in sync with net-next, so I can apply this patch
here, as an alternative path.
