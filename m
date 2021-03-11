Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A09C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 15:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 941E164FE0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 15:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhCKPw1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 10:52:27 -0500
Received: from linux.microsoft.com ([13.77.154.182]:46944 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbhCKPvr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 10:51:47 -0500
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4FA5120B39C5;
        Thu, 11 Mar 2021 07:51:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4FA5120B39C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1615477906;
        bh=LJfQJ/icbAeUVvT27wr79VOCQwsfPDKj2VzkZBi/gSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eQR/3MfMgttOZ1JLQPvpNUpJrKMLwROpypDosCfhM9M526Rp9luZUktDRFHlxM4qD
         hYW/bQKopgxrnPW8Q52DI9XJfJs8oLO+s4Agi88oSnDpUlUqWpDr4vfj5jE7qYzA81
         YdoLhhJ4Cm2EBC0wnUfePVXNZZJG2Nwox5QlJ9zg=
Date:   Thu, 11 Mar 2021 09:51:25 -0600
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        subashab@codeaurora.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Don't use RCU for x_tables synchronization
Message-ID: <20210311155125.GA4374@sequoia>
References: <20210308012413.14383-1-mark.tomlinson@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308012413.14383-1-mark.tomlinson@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-03-08 14:24:10, Mark Tomlinson wrote:
> The patches to change to using RCU synchronization in x_tables cause
> updating tables to be slowed down by an order of magnitude. This has
> been tried before, see https://lore.kernel.org/patchwork/patch/151796/
> and ultimately was rejected. As mentioned in the patch description, a
> different method can be used to ensure ordering of reads/writes. This
> can simply be done by changing from smp_wmb() to smp_mb().

I came across these patches while trying to root-cause a significant boot time
regression we were seeing when comparing 5.4 to 5.10. The RCU changes were
where I had started to investigate but hadn't yet made it to the point that
Mark had reached when he sent out these fixes.

Mark's description of the problem and fix looks correct to me.

To touch on why the performance regression is a problem for us, we have
three services that load various firewall rules during boot up. Here are
the total run times that `systemd-analyze blame` reported for each one
to run to completion:

5.4.88:

 129ms fw-1.service
 56ms  fw-2.service
 38ms  fw-3.service

5.10.19:
                                                                                            
 586ms fw-1.service
 847ms fw-2.service
 193ms fw-3.service

5.10.19 + these fixes:

 98ms fw-1.service
 25ms fw-2.service
 54ms fw-3.service

You can see that the performance regression from 5.4.88 -> 5.10.19
considerably increased our boot time.

I cannot explain why '5.10.19 + these fixes' shows improvements over
5.4.88 for two of the three services but I suspect it is due to systemd
taking different code paths, units executing at different times,
unrelated kernel performance improvements, etc.

For all three patches,

 Tested-by: Tyler Hicks <tyhicks@linux.microsoft.com>
 Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Tyler

> 
> changes in v2:
> - Update commit messages only
> 
> Mark Tomlinson (3):
>   Revert "netfilter: x_tables: Update remaining dereference to RCU"
>   Revert "netfilter: x_tables: Switch synchronization to RCU"
>   netfilter: x_tables: Use correct memory barriers.
> 
>  include/linux/netfilter/x_tables.h |  7 ++---
>  net/ipv4/netfilter/arp_tables.c    | 16 +++++-----
>  net/ipv4/netfilter/ip_tables.c     | 16 +++++-----
>  net/ipv6/netfilter/ip6_tables.c    | 16 +++++-----
>  net/netfilter/x_tables.c           | 49 +++++++++++++++++++++---------
>  5 files changed, 60 insertions(+), 44 deletions(-)
> 
> -- 
> 2.30.1
> 
