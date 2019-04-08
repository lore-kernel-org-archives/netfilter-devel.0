Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738D8C10F13
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 11:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F2D20663
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 11:28:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="kn1kvb4i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfDHL2a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 07:28:30 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51059 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfDHL2a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 07:28:30 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id F35A525B79A;
        Mon,  8 Apr 2019 21:28:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1554722908; bh=ELFn10csOfkOxLa8NlZjWfMZI3eYPYawqW6PeeErEaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kn1kvb4ikuDowf51tNkrROv1HEnKkKGREZ+F6y5Eg902n2vuepWgWrHvFQQUfXOLN
         FGvfAQ/dv4KmfhZpkmkycu5VLIvhNrxmoKZP4iJ6R7UA1qhIfH9tr2qRUUEd6ynARB
         qDeZFyJ2BQ93p2e/a3BYmJoMfDdixbw6oUFCmVJY=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 2238194069B; Mon,  8 Apr 2019 13:28:26 +0200 (CEST)
Date:   Mon, 8 Apr 2019 13:28:26 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCH net-next 3/3] ipvs: strip udp tunnel headers from icmp
 errors
Message-ID: <20190408112825.mwba6nmjxtfaclb6@verge.net.au>
References: <20190331102621.7460-1-ja@ssi.bg>
 <20190331102621.7460-4-ja@ssi.bg>
 <20190403081511.ltjmuudpxdz3xxmf@verge.net.au>
 <alpine.LFD.2.21.1904032352530.3584@ja.home.ssi.bg>
 <20190404101421.izk7atydes3c53at@verge.net.au>
 <alpine.LFD.2.21.1904061255490.4492@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1904061255490.4492@ja.home.ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 06, 2019 at 01:07:34PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 4 Apr 2019, Simon Horman wrote:
> 
> > On Thu, Apr 04, 2019 at 12:18:08AM +0300, Julian Anastasov wrote:
> > > 
> > > 	We can easily add simple FOU in ipvs_udp_decap() by
> > > returning 0 and correct *proto. Or you prefer to use common
> > > code from other files to parse the headers? Currently, there
> > > is no any GUE func that can be used for this.
> > 
> > My feeling is that using common code, even new common code, would
> > be better.
> 
> 	Let me know If you prefer to add GUE code that we can use
> in this patchset, I can test it easily. I'll delay with v2 to
> incorporate any needed changes.

Thanks Julian,

yes, I would prefer that.
