From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: clusterip: make sure arp hooks are
 available
Date: Thu, 11 Jan 2018 13:12:43 +0100
Message-ID: <20180111121243.sd64efdvl4qb6a4u@salvia>
References: <20180111082129.18782-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753695AbeAKMMy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 07:12:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3BAAF44382A
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2018 13:12:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E752BAABC
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2018 13:12:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180111082129.18782-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 11, 2018 at 09:21:29AM +0100, Florian Westphal wrote:
> The clusterip target needs to register an arp mangling hook,
> so make sure NF_ARP hooks are available.

Applied, thanks Florian.
