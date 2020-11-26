Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DBDC63777
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Nov 2020 09:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA937206D8
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Nov 2020 09:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733196AbgKZJkZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Nov 2020 04:40:25 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:42868 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733102AbgKZJkZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Nov 2020 04:40:25 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A75A7204EF;
        Thu, 26 Nov 2020 10:40:23 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bG_lvu7VLkd6; Thu, 26 Nov 2020 10:40:23 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 34E32204B4;
        Thu, 26 Nov 2020 10:40:23 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 26 Nov 2020 10:40:22 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 26 Nov
 2020 10:40:22 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E21C731804CE;
 Thu, 26 Nov 2020 10:40:21 +0100 (CET)
Date:   Thu, 26 Nov 2020 10:40:21 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Phil Sutter <phil@nwl.cc>, <linux-crypto@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: Re: XFRM interface and NF_INET_LOCAL_OUT hook
Message-ID: <20201126094021.GK8805@gauss3.secunet.de>
References: <20201125112342.GA11766@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201125112342.GA11766@orbyte.nwl.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, Nov 25, 2020 at 12:23:42PM +0100, Phil Sutter wrote:
> Hi Steffen,
> 
> I am working on a ticket complaining about netfilter policy match
> missing packets in OUTPUT chain if XFRM interface is being used.
> 
> I don't fully overlook the relevant code path, but it seems like
> skb_dest(skb)->xfrm is not yet assigned when the skb is routed towards
> XFRM interface and already cleared again (by xfrm_output_one?) before it
> makes its way towards the real output interface. NF_INET_POST_ROUTING
> hook works though.
> 
> Is this a bug or an expected quirk when using XFRM interface?

This is expected behaviour. The xfrm interfaces are plaintext devices,
the plaintext packets are routed to the xfrm interface which guarantees
transformation. So the lookup that assigns skb_dst(skb)->xfrm
happens 'behind' the interface. After transformation,
skb_dst(skb)->xfrm will be cleared. So this assignment exists just
inside xfrm in that case.

Does netfilter match against skb_dst(skb)->xfrm? What is the exact case
that does not work?
