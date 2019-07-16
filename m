Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D14C7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 18:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C693E2145D
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 18:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388107AbfGPS1n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 14:27:43 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:58694 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387488AbfGPS1n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 14:27:43 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hnSAt-0006cc-RP; Tue, 16 Jul 2019 20:27:39 +0200
Date:   Tue, 16 Jul 2019 20:27:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        charles@ccxtechnologies.com
Subject: Re: [PATCH nft] evaluate: bogus error when refering to existing
 non-base chain
Message-ID: <20190716182739.5b637icvzsdovfh5@breakpoint.cc>
References: <20190716115120.21710-1-pablo@netfilter.org>
 <20190716164711.GF1628@orbyte.nwl.cc>
 <63707D89-2251-4B96-BE53-880E12FF0F6A@riseup.net>
 <20190716180004.dwueos7c4yn75udi@breakpoint.cc>
 <20190716181253.dtmvpgqiykgx563m@salvia>
 <20190716182607.wdqq2de7nz2s5gce@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716182607.wdqq2de7nz2s5gce@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Having said this, if you want a test for this specific case, I really
> don't mind :-)

Fair enough, Fernando, if you think you have more important things to
work on then just ignore this.

