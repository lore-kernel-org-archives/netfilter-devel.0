Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1426EC282DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 11:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E28F520872
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 11:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731995AbfDQLu2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 07:50:28 -0400
Received: from drutsystem.com ([84.10.39.251]:33177 "EHLO drutsystem.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729522AbfDQLu2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 07:50:28 -0400
Subject: Re: [PATCH nf] netfilter: never get/set skb->tstamp
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
References: <9cf8e521-8aa6-c022-e491-d3e6cfe0aca6@ziu.info>
 <20190417001723.17912-1-fw@strlen.de>
From:   Michal Soltys <soltys@ziu.info>
Message-ID: <ad00ec6c-8599-994e-ca58-bee84b0a96b0@ziu.info>
Date:   Wed, 17 Apr 2019 13:50:21 +0200
MIME-Version: 1.0
In-Reply-To: <20190417001723.17912-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-MailScanner-ID: F36AC7014E5.A00EB
X-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: soltys@ziu.info
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/17/19 2:17 AM, Florian Westphal wrote:
> setting net.netfilter.nf_conntrack_timestamp=1 breaks xmit with fq
> scheduler.  skb->tstamp might be "refreshed" using ktime_get_real(),
> but fq expects CLOCK_MONOTONIC.
> 
> This patch removes all places in netfilter that check/set skb->tstamp:
> 
> 1. To fix the bogus "start" time seen with conntrack timestamping for
>     outgoing packets, never use skb->tstamp and always use current time.
> 2. In nfqueue and nflog, only use skb->tstamp for incoming packets,
>     as determined by current hook (prerouting, input, forward).
> 3. xt_time has to use system clock as well rather than skb->tstamp.
>     We could still use skb->tstamp for prerouting/input/foward, but
>     I see no advantage to make this conditional.
> 
> Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
> Cc: Eric Dumazet <edumazet@google.com>
> Reported-by: Michal Soltys <soltys@ziu.info>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Thanks for quick patch.

Applied it on top of 5.0.8 - wanted to confirm everything seems to be 
working fine (and timestamps are correct).
