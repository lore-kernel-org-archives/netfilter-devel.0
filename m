Return-Path: <SRS0=uHYT=BB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060A8C433E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 06:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E266020771
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 06:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgGVGDs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jul 2020 02:03:48 -0400
Received: from ja.ssi.bg ([178.16.129.10]:51892 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727084AbgGVGDs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 02:03:48 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 06M631l3002786;
        Wed, 22 Jul 2020 09:03:01 +0300
Date:   Wed, 22 Jul 2020 09:03:01 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Andrew Sy Kim <kim.andrewsy@gmail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] ipvs: add missing struct name in ip_vs_enqueue_expire_nodest_conns
 when CONFIG_SYSCTL is disabled
In-Reply-To: <20200721232007.GA6367@salvia>
Message-ID: <alpine.LFD.2.23.451.2007220901320.2433@ja.home.ssi.bg>
References: <20200717162450.1049-1-kim.andrewsy@gmail.com> <alpine.LFD.2.23.451.2007172032370.4536@ja.home.ssi.bg> <20200721232007.GA6367@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Wed, 22 Jul 2020, Pablo Neira Ayuso wrote:

> On Fri, Jul 17, 2020 at 08:36:36PM +0300, Julian Anastasov wrote:
> > 
> > On Fri, 17 Jul 2020, Andrew Sy Kim wrote:
> > 
> > > Adds missing "*ipvs" to ip_vs_enqueue_expire_nodest_conns when
> > > CONFIG_SYSCTL is disabled
> > > 
> > > Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
> > 
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> > 
> > 	Pablo, please apply this too.
> 
> I have squashed this fix and "ipvs: ensure RCU read unlock when
> connection flushing and ipvs is disabled" into the original patch:
> 
> "ipvs: queue delayed work to expire no destination connections if
> expire_nodest_conn=1"

	Very good, thanks!

Regards

--
Julian Anastasov <ja@ssi.bg>
