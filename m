Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EFDC43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 10:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4747220675
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 10:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfFTKUW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 06:20:22 -0400
Received: from mail.us.es ([193.147.175.20]:38800 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbfFTKUW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 06:20:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A0FE2EA47A
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 12:20:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B98EDA713
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 12:20:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6F096DA710; Thu, 20 Jun 2019 12:20:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E125DA704;
        Thu, 20 Jun 2019 12:20:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 12:20:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 12DDD4265A2F;
        Thu, 20 Jun 2019 12:20:16 +0200 (CEST)
Date:   Thu, 20 Jun 2019 12:20:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        wenxu <wenxu@ucloud.cn>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: synproxy: fix building syncookie calls
Message-ID: <20190620102015.gzanaci6aztfhv76@salvia>
References: <20190619125500.1054426-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619125500.1054426-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 19, 2019 at 02:54:36PM +0200, Arnd Bergmann wrote:
> When either CONFIG_IPV6 or CONFIG_SYN_COOKIES are disabled, the kernel
> fails to build:
> 
> include/linux/netfilter_ipv6.h:180:9: error: implicit declaration of function '__cookie_v6_init_sequence'
>       [-Werror,-Wimplicit-function-declaration]
>         return __cookie_v6_init_sequence(iph, th, mssp);
> include/linux/netfilter_ipv6.h:194:9: error: implicit declaration of function '__cookie_v6_check'
>       [-Werror,-Wimplicit-function-declaration]
>         return __cookie_v6_check(iph, th, cookie);
> net/ipv6/netfilter.c:237:26: error: use of undeclared identifier '__cookie_v6_init_sequence'; did you mean 'cookie_init_sequence'?
> net/ipv6/netfilter.c:238:21: error: use of undeclared identifier '__cookie_v6_check'; did you mean '__cookie_v4_check'?
> 
> Fix the IS_ENABLED() checks to match the function declaration
> and definitions for these.

Applied, thanks Arnd.
