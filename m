Return-Path: <SRS0=QQeY=TB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C901C43219
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 13:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E17DC20866
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 13:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfEANhq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 May 2019 09:37:46 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:59552 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfEANhq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 May 2019 09:37:46 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id A60C525AF53;
        Wed,  1 May 2019 23:37:43 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id B98A0940333; Wed,  1 May 2019 15:37:41 +0200 (CEST)
Date:   Wed, 1 May 2019 15:37:41 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCH net-next 3/3] ipvs: strip udp tunnel headers from icmp
 errors
Message-ID: <20190501133741.u5v3kva4shbudvfj@verge.net.au>
References: <20190331102621.7460-1-ja@ssi.bg>
 <20190331102621.7460-4-ja@ssi.bg>
 <20190403081511.ltjmuudpxdz3xxmf@verge.net.au>
 <alpine.LFD.2.21.1904032352530.3584@ja.home.ssi.bg>
 <20190404101421.izk7atydes3c53at@verge.net.au>
 <alpine.LFD.2.21.1904061255490.4492@ja.home.ssi.bg>
 <20190408112825.mwba6nmjxtfaclb6@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408112825.mwba6nmjxtfaclb6@verge.net.au>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 08, 2019 at 01:28:26PM +0200, Simon Horman wrote:
> On Sat, Apr 06, 2019 at 01:07:34PM +0300, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Thu, 4 Apr 2019, Simon Horman wrote:
> > 
> > > On Thu, Apr 04, 2019 at 12:18:08AM +0300, Julian Anastasov wrote:
> > > > 
> > > > 	We can easily add simple FOU in ipvs_udp_decap() by
> > > > returning 0 and correct *proto. Or you prefer to use common
> > > > code from other files to parse the headers? Currently, there
> > > > is no any GUE func that can be used for this.
> > > 
> > > My feeling is that using common code, even new common code, would
> > > be better.
> > 
> > 	Let me know If you prefer to add GUE code that we can use
> > in this patchset, I can test it easily. I'll delay with v2 to
> > incorporate any needed changes.
> 
> Thanks Julian,
> 
> yes, I would prefer that.

Thanks again Julian,

is a v2 of this series pending or am I mistaken somehow?
