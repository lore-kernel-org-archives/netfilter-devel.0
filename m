Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F76C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 18:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB1ED2084B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 18:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfDCSK1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 14:10:27 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:42858 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfDCSK1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 14:10:27 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hBkLA-0002li-3T; Wed, 03 Apr 2019 20:10:26 +0200
Date:   Wed, 3 Apr 2019 20:10:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] xtables-legacy: add missing config.h include
Message-ID: <20190403181023.hksazdwfmusvto3u@salvia>
References: <20190308143709.27721-1-l.stach@pengutronix.de>
 <20190318154214.snghtdepv4h3e4k4@salvia>
 <1553008601.4806.7.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553008601.4806.7.camel@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 19, 2019 at 04:16:41PM +0100, Lucas Stach wrote:
> Hi Pablo,
> 
> Am Montag, den 18.03.2019, 16:42 +0100 schrieb Pablo Neira Ayuso:
> > Hi Lucas,
> > 
> > I can blindly take this, since I guess you're fixing a problem there.
> > 
> > I guess it's a compilation issue with some specific toolchain? Because
> > I cannot reproduce this here.
> 
> This fixes a IPv4 only build, where this file would have references to
> functions that aren't built in this case. I'm not sure how it ends up
> with ENABLE_IPV6 defined without the config.h include, but since this
> was clearly missing and fixed my issue, I didn't bother tracking down
> the chain.

Applied, thanks for explaining.
