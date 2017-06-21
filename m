From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnf-queue] src: prepare for new release
Date: Wed, 21 Jun 2017 18:37:00 +0200
Message-ID: <20170621163700.GA6437@salvia>
References: <20170620222852.19879-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37256 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752824AbdFUQhP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2017 12:37:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 971354D652
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2017 18:36:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A4D7D190F
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2017 18:36:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8469D190F
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2017 18:36:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170620222852.19879-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 21, 2017 at 12:28:52AM +0200, Florian Westphal wrote:
> diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
> index 211a8ba75d79..69db0e02fc5b 100644
> --- a/src/libnetfilter_queue.c
> +++ b/src/libnetfilter_queue.c
> @@ -658,6 +658,7 @@ EXPORT_SYMBOL(nfq_set_mode);
>   * - NFQA_CFG_F_GSO (requires Linux kernel >= 3.10): the kernel will
>   *   not normalize offload packets, i.e. your application will need to
>   *   be able to handle packets larger than the mtu (up to 64k).
> + *   Normalization is expensive, so this flag should always be set.

With this on, I see more chances to hit the netlink attribute
limitation, so packets on the 64k will be truncated?

Probably good to document this too.
