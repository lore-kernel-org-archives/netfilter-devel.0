From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: lower timeout to RETRANS
 seconds if window is 0
Date: Mon, 20 Nov 2017 13:30:07 +0100
Message-ID: <20171120123007.GA17331@salvia>
References: <20171119202728.13756-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56162 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdKTMaN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2017 07:30:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CDF0F54D5F2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 13:30:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB0B8BAABF
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 13:30:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171119202728.13756-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 19, 2017 at 09:27:28PM +0100, Florian Westphal wrote:
> When zero window is announced we can get into a situation where
> connection stays around forever:
> 
> 1. One side announces zero window.
> 2. Other side closes.
> 
> In this case, no FIN is sent (stuck in send queue).
> 
> Unless other side opens the window up again conntrack
> stays in ESTABLISHED state for a very long time.
> 
> Lets alleviate this by lowering the timeout to RETRANS (5 minutes),
> the other end should be sending zero window probes to keep the
> connection established as long as a socket still exists.

Applied, thanks!
