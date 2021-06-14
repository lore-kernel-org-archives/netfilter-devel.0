Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF44C48BE6
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 17:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55B1F61209
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 17:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbhFNRTT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 13:19:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42018 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhFNRTS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 13:19:18 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9B1C464231;
        Mon, 14 Jun 2021 19:15:57 +0200 (CEST)
Date:   Mon, 14 Jun 2021 19:17:12 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH nf] MAINTAINERS: netfilter: add irc channel
Message-ID: <20210614171712.GA28746@salvia>
References: <20210528084849.19058-1-nicolas.dichtel@6wind.com>
 <9b60107e-dcd4-3ca0-f83d-0e51ccf5d67c@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b60107e-dcd4-3ca0-f83d-0e51ccf5d67c@6wind.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 14, 2021 at 03:18:00PM +0200, Nicolas Dichtel wrote:
> Le 28/05/2021 à 10:48, Nicolas Dichtel a écrit :
> > The community #netfilter IRC channel is now live on the libera.chat network
> > (https://libera.chat/).
> > 
> > CC: Arturo Borrero Gonzalez <arturo@netfilter.org>
> > Link: https://marc.info/?l=netfilter&m=162210948632717
> > Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> I have no feedback on this. Is there a problem to add the irc channel in the
> MAINTAINERS file?

*Problem*? Nah.

I'll add this patch to the nf queue.
