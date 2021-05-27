Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D26C47089
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 18:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0F5260FF2
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 18:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbhE0SJX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 14:09:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38114 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhE0SJX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 14:09:23 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D5FEE6441E;
        Thu, 27 May 2021 20:06:46 +0200 (CEST)
Date:   Thu, 27 May 2021 20:07:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [ulogd2 PATCH] ulogd: printpkt: print pkt mark like kernel
Message-ID: <20210527180745.GA8767@salvia>
References: <20210524205913.18411-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210524205913.18411-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 25, 2021 at 08:59:13AM +1200, Cole Dishington wrote:
> Print the pkt mark in hex with a preceding '0x', like the kernel prints
> pkts logged by netfilter.

Applied, thanks.
