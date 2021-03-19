Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAB8C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Mar 2021 14:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 866CA64F18
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Mar 2021 14:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhCSOAx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Mar 2021 10:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhCSOAd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Mar 2021 10:00:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 253F7C06174A
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Mar 2021 07:00:33 -0700 (PDT)
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 37EBD630B3;
        Fri, 19 Mar 2021 15:00:25 +0100 (CET)
Date:   Fri, 19 Mar 2021 15:00:26 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_conntrack] conntrack: Don't use ICMP attrs
 in decision to build repl tuple
Message-ID: <20210319140026.GA15031@salvia>
References: <20210318130138.GC22603@breakpoint.cc>
 <20210318195919.29620-1-luuk.paulussen@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210318195919.29620-1-luuk.paulussen@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 19, 2021 at 08:59:19AM +1300, Luuk Paulussen wrote:
> conntrack-tools doesn't set the REPL attributes by default for updates,
> so for ICMP flows, the update won't be sent as building the repl tuple
> will fail.

Applied, thanks.
