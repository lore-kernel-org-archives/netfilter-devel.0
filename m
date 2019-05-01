Return-Path: <SRS0=QQeY=TB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCD6C43219
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 14:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CDFA20866
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 14:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfEAOH3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 May 2019 10:07:29 -0400
Received: from ja.ssi.bg ([178.16.129.10]:49588 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbfEAOH3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 May 2019 10:07:29 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x41E7GF9014465;
        Wed, 1 May 2019 17:07:16 +0300
Date:   Wed, 1 May 2019 17:07:16 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCH net-next 3/3] ipvs: strip udp tunnel headers from icmp
 errors
In-Reply-To: <20190501133741.u5v3kva4shbudvfj@verge.net.au>
Message-ID: <alpine.LFD.2.21.1905011701580.8180@ja.home.ssi.bg>
References: <20190331102621.7460-1-ja@ssi.bg> <20190331102621.7460-4-ja@ssi.bg> <20190403081511.ltjmuudpxdz3xxmf@verge.net.au> <alpine.LFD.2.21.1904032352530.3584@ja.home.ssi.bg> <20190404101421.izk7atydes3c53at@verge.net.au> <alpine.LFD.2.21.1904061255490.4492@ja.home.ssi.bg>
 <20190408112825.mwba6nmjxtfaclb6@verge.net.au> <20190501133741.u5v3kva4shbudvfj@verge.net.au>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Wed, 1 May 2019, Simon Horman wrote:

> > > > > 	We can easily add simple FOU in ipvs_udp_decap() by
> > > > > returning 0 and correct *proto. Or you prefer to use common
> > > > > code from other files to parse the headers? Currently, there
> > > > > is no any GUE func that can be used for this.
> > > > 
> > > > My feeling is that using common code, even new common code, would
> > > > be better.
> > > 
> > > 	Let me know If you prefer to add GUE code that we can use
> > > in this patchset, I can test it easily. I'll delay with v2 to
> > > incorporate any needed changes.
> > 
> > Thanks Julian,
> > 
> > yes, I would prefer that.
> 
> Thanks again Julian,
> 
> is a v2 of this series pending or am I mistaken somehow?

	I thought you will have some separate patch that adds
code to be used in v2 but if you prefer I can release v2, so
that you can add followup patch[es] based on that.

Regards

--
Julian Anastasov <ja@ssi.bg>
