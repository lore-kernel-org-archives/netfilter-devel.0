Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5202AC43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 13:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 315B120675
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 13:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfFTN5I convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 09:57:08 -0400
Received: from mail.us.es ([193.147.175.20]:43666 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbfFTN5H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 09:57:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0449AC1B70
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 15:57:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA3CEDA70E
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 15:57:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DF99EDA70A; Thu, 20 Jun 2019 15:57:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 957AEDA706;
        Thu, 20 Jun 2019 15:57:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 15:57:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6F6FD4265A2F;
        Thu, 20 Jun 2019 15:57:03 +0200 (CEST)
Date:   Thu, 20 Jun 2019 15:57:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: linux-next: build failure after merge of the netfilter-next tree
Message-ID: <20190620135703.aiv62n6fhzf6wjwv@salvia>
References: <20190620234743.42e9d3e8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190620234743.42e9d3e8@canb.auug.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 20, 2019 at 11:47:43PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the netfilter-next tree, today's linux-next build
> (arm imx_v4_v5_defconfig and several others) failed like this:
> 
> In file included from net/netfilter/core.c:19:0:
> include/linux/netfilter_ipv6.h: In function 'nf_ipv6_cookie_init_sequence':
> include/linux/netfilter_ipv6.h:174:2: error: implicit declaration of function '__cookie_v6_init_sequence' [-Werror=implicit-function-declaration]
> include/linux/netfilter_ipv6.h: In function 'nf_cookie_v6_check':
> include/linux/netfilter_ipv6.h:189:2: error: implicit declaration of function '__cookie_v6_check' [-Werror=implicit-function-declaration]
> 
> Caused by commit
> 
>   3006a5224f15 ("netfilter: synproxy: remove module dependency on IPv6 SYNPROXY")
> 
> This has been happening for a few days, sorry.
> 
> # CONFIG_IPV6 is not set

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=8527fa6cc68a489f735823e61b31ec6cb266274a
