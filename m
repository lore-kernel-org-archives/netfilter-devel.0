From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 0/4] netfilter: handle race w. module removal
 and nfqueue
Date: Mon, 31 Jul 2017 19:10:16 +0200
Message-ID: <20170731171016.GA4855@salvia>
References: <20170725220234.29354-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751571AbdGaRKt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 13:10:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A639D3025A0
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:10:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADF41CE39D
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:10:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0098D1CAF
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:10:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170725220234.29354-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 26, 2017 at 12:02:30AM +0200, Florian Westphal wrote:
> There is a long-standing race that occurs with module removal
> (such as helpers) nfqueue, and unconfirmed (not in hash table) conntracks.
> 
> The main issue is that
> a). unconfirmed conntracks can't safely be mangled from other cpu (we assume
>     exclusive access to grow/alter the extension area) and
> b). nfqueued skbs leave RCU protection
> 
> This series address this by making the queue event similar to a
> confirm event:
> 
> Just as we do not commit 'dying' conntracks to the main table, refuse to
> queue dying and unconfirmed conntracks to userspace.
> 
> Combined with a 'drop queued skbs' when a module exit path calls the
> ct_iterate_destroy function this closes the hole, see patch #4 for details.
> 
> The only change since v1 is a build error that occured in patch 4 when
> nfqueue is enabled but conntrack is not, as reported by kbuild test robot.

Series applied.
