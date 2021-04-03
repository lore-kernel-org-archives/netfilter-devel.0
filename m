Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77C3C433B4
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 18:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CFF86124C
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 18:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbhDCSWK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Apr 2021 14:22:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57182 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbhDCSWK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Apr 2021 14:22:10 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 56A4563E42;
        Sat,  3 Apr 2021 20:21:49 +0200 (CEST)
Date:   Sat, 3 Apr 2021 20:22:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Firo Yang <firo.yang@suse.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] ebtables: processing '--concurrent' beofore other
 arguments
Message-ID: <20210403182204.GA5182@salvia>
References: <20210401040741.15672-1-firo.yang@suse.com>
 <20210401040741.15672-2-firo.yang@suse.com>
 <20210403181517.GA4624@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210403181517.GA4624@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 03, 2021 at 08:15:17PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Thu, Apr 01, 2021 at 12:07:40PM +0800, Firo Yang wrote:
> > Our customer reported a following issue:
> > If '--concurrent' was passed to ebtables command behind other arguments,
> > '--concurrent' will not take effect sometimes; for a simple example,
> > ebtables -L --concurrent. This is becuase the handling of '--concurrent'
> > is implemented in a passing-order-dependent way.
> > 
> > So we can fix this problem by processing it before other arguments.
> 
> Would you instead make a patch to spew an error if --concurrent is the
> first argument?

Wrong wording:

Would you instead make a patch to spew an error if --concurrent is
_not_ the first argument?

> --concurrent has never worked unless you place it in first place
> anyway.
