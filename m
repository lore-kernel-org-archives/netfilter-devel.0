Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A842C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Mar 2022 22:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244282AbiCSWbm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Mar 2022 18:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiCSWbm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Mar 2022 18:31:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C261844A39
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Mar 2022 15:30:20 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8529460743;
        Sat, 19 Mar 2022 23:27:43 +0100 (CET)
Date:   Sat, 19 Mar 2022 23:30:15 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Karel Rericha <karel@maxtel.cz>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: revisit gc autotuning
Message-ID: <YjZZdylcRT41hFaf@salvia>
References: <20220216154305.30455-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220216154305.30455-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 16, 2022 at 04:43:05PM +0100, Florian Westphal wrote:
> as of commit 4608fdfc07e1
> ("netfilter: conntrack: collect all entries in one cycle")
> conntrack gc was changed to run every 2 minutes.
> 
> On systems where conntrack hash table is set to large value, most evictions
> happen from gc worker rather than the packet path due to hash table
> distribution.
> 
> This causes netlink event overflows when events are collected.
> 
> This change collects average expiry of scanned entries and
> reschedules to the average remaining value, within 1 to 60 second interval.
> 
> To avoid event overflows, reschedule after each bucket and add a
> limit for both run time and number of evictions per run.
> 
> If more entries have to be evicted, reschedule and restart 1 jiffy
> into the future.

Applied, thanks.
