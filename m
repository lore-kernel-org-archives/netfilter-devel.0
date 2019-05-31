Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8448C28CC3
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 09:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0BE526691
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 09:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfEaJRF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 05:17:05 -0400
Received: from mail.us.es ([193.147.175.20]:35530 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfEaJRF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 05:17:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4153910FB0A
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 11:17:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 319FCDA729
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 11:17:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 27252DA718; Fri, 31 May 2019 11:17:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE6BFDA706;
        Fri, 31 May 2019 11:17:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 11:17:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 87ECF40705C3;
        Fri, 31 May 2019 11:17:00 +0200 (CEST)
Date:   Fri, 31 May 2019 11:17:00 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, wenxu@ucloud.cn,
        sfr@canb.auug.org.au, yuehaibing@huawei.com, lkp@intel.com
Subject: Re: [PATCH] netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y
Message-ID: <20190531091700.3frlkppqifphvnby@salvia>
References: <20190531091124.26822-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531091124.26822-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 31, 2019 at 11:11:24AM +0200, Pablo Neira Ayuso wrote:
> This patch fixes a few problems with CONFIG_IPV6=y and
> CONFIG_NF_CONNTRACK_BRIDGE=m:
> 
> In file included from net/netfilter/utils.c:5:
> include/linux/netfilter_ipv6.h: In function 'nf_ipv6_br_defrag':
> include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of function 'nf_ct_frag6_gather'; did you mean 'nf_ct_attach'? [-Werror=implicit-function-declaration]
> 
> And these too:
> 
> net/ipv6/netfilter.c:242:2: error: unknown field 'br_defrag' specified in initializer
> net/ipv6/netfilter.c:243:2: error: unknown field 'br_fragment' specified in initializer
> 
> This patch includes an original chunk from wenxu.

Oops, sending v2. Missing net-next tag. Sorry.
