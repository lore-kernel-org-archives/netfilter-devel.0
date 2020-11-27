Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5F1C64E7A
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Nov 2020 09:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2A0422226
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Nov 2020 09:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgK0JzO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Nov 2020 04:55:14 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36520 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgK0JzO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Nov 2020 04:55:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BAB2F20561;
        Fri, 27 Nov 2020 10:55:12 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lPCOVodai2_I; Fri, 27 Nov 2020 10:55:12 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 42A312026E;
        Fri, 27 Nov 2020 10:55:12 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 27 Nov 2020 10:55:12 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 27 Nov
 2020 10:55:11 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 6E97F31805CB;
 Fri, 27 Nov 2020 10:55:11 +0100 (CET)
Date:   Fri, 27 Nov 2020 10:55:11 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Phil Sutter <phil@nwl.cc>, <linux-crypto@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: Re: XFRM interface and NF_INET_LOCAL_OUT hook
Message-ID: <20201127095511.GD9390@gauss3.secunet.de>
References: <20201125112342.GA11766@orbyte.nwl.cc>
 <20201126094021.GK8805@gauss3.secunet.de>
 <20201126131200.GH4647@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201126131200.GH4647@orbyte.nwl.cc>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 26, 2020 at 02:12:00PM +0100, Phil Sutter wrote:
> > > 
> > > Is this a bug or an expected quirk when using XFRM interface?
> > 
> > This is expected behaviour. The xfrm interfaces are plaintext devices,
> > the plaintext packets are routed to the xfrm interface which guarantees
> > transformation. So the lookup that assigns skb_dst(skb)->xfrm
> > happens 'behind' the interface. After transformation,
> > skb_dst(skb)->xfrm will be cleared. So this assignment exists just
> > inside xfrm in that case.
> 
> OK, thanks for the clarification.
> 
> > Does netfilter match against skb_dst(skb)->xfrm? What is the exact case
> > that does not work?
> 
> The reported use-case is a match against tunnel data in output hook:
> 
> | table t {
> |     chain c {
> |         type filter hook output priority filter
> |         oifname eth0 ipsec out ip daddr 192.168.1.2
> |     }
> | }
> 
> The ipsec expression tries to extract that data from skb_dst(skb)->xfrm
> if present. In xt_policy (for iptables), code is equivalent. The above
> works when not using xfrm_interface. Initially I assumed one just needs
> to adjust the oifname match, but even dropping it doesn't help.

Yes, this does not work with xfrm interfaces. As said, they are plaintext
devices that guarantee transformation.

Maybe you can try to match after transformation by using the secpath,
but not sure if that is what you need.
