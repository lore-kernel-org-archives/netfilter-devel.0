Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CC8C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 23:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiAZXIz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 18:08:55 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58524 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiAZXIz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 18:08:55 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 32D8560676;
        Thu, 27 Jan 2022 00:05:50 +0100 (CET)
Date:   Thu, 27 Jan 2022 00:08:49 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        "Jose M . Guisado Gomez" <guigom@riseup.net>
Subject: Re: [nf PATCH] netfilter: nft_reject_bridge: Fix for missing reply
 from prerouting
Message-ID: <YfHUgfqkytOXCX7F@salvia>
References: <20220125190603.20182-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220125190603.20182-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 08:06:03PM +0100, Phil Sutter wrote:
> Prior to commit fa538f7cf05aa ("netfilter: nf_reject: add reject skbuff
> creation helpers"), nft_reject_bridge did not assign to nskb->dev before
> passing nskb on to br_forward(). The shared skbuff creation helpers
> introduced in above commit do which seems to confuse br_forward() as
> reject statements in prerouting hook won't emit a packet anymore.
> 
> Fix this by simply passing NULL instead of 'dev' to the helpers - they
> use the pointer for just that assignment, nothing else.

Applied, thanks
