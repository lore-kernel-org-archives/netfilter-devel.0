Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E13FC04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 22:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BAB32075C
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 22:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbfE1WFZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 18:05:25 -0400
Received: from ja.ssi.bg ([178.16.129.10]:55672 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726576AbfE1WFZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 18:05:25 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x4SM4E6G010937;
        Wed, 29 May 2019 01:04:14 +0300
Date:   Wed, 29 May 2019 01:04:14 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Jacky Hu <hengqing.hu@gmail.com>
cc:     jacky.hu@walmart.com, jason.niesz@walmart.com,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v2] ipvs: add checksum support for gue encapsulation
In-Reply-To: <20190526064819.16420-1-hengqing.hu@gmail.com>
Message-ID: <alpine.LFD.2.21.1905290059380.4284@ja.home.ssi.bg>
References: <20190526064819.16420-1-hengqing.hu@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Sun, 26 May 2019, Jacky Hu wrote:

> +/* Tunnel encapsulation flags */
> +#define IP_VS_TUNNEL_ENCAP_FLAG_NOCSUM		(0)
> +#define IP_VS_TUNNEL_ENCAP_FLAG_CSUM		(1<<0)
> +#define IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM		(1<<1)

	scripts/checkpatch.pl --strict file.patch
reports for some issues you should resolve for v3.
Otherwise, the patch looks good to me.

Regards

--
Julian Anastasov <ja@ssi.bg>
