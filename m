From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: check the validation of
 queues_total and queuenum
Date: Fri, 9 Sep 2016 16:04:34 +0200
Message-ID: <20160909140434.GA25982@salvia>
References: <1473172417-8311-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40458 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbcIIOEo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 10:04:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC4FA2273E8
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 16:04:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADD1B114D68
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 16:04:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D91B11150C7
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 16:04:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473172417-8311-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 06, 2016 at 10:33:37PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Although the validation of queues_total and queuenum is checked in nft
> utility, but user can add nft rules via nfnetlink, so it is necessary
> to check the validation at the nft_queue expr init routine too.

Applied, thanks.

More comments on things I see on nft_queue at this stage:

1) Another issue, I can see nfqueue_hash() depends on
CONFIG_IP6_NF_IPTABLES, this is not good since nft_queue
infrastructure should not depend on iptables. Probably making this
dependent of CONFIG_IPV6 is enough, unless you find anything better.

2) It would be good if nft_queue takes a _SREG_FROM and _SREG_TO to
select the queue numbers, in a similar fashion to nft_nat. The idea is
that we allow plugging nft_queue into nftables mapping, currently this
is not working given that the queue number is passed as an attribute
that contains the value.

3) It would be good to add py tests with larger range. I remember that
the range 1-65535 currently doesn't work in both nft_queue and
xt_NFQUEUE because the queue_total arithmetics are not right.

It would be great if you can have a look into this.

Thanks!
