From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: mark expected switch fall-throughs
Date: Mon, 13 Nov 2017 13:46:18 +0100
Message-ID: <20171113124618.GA7833@salvia>
References: <20171107073045.Horde.fHvUlYL1jmnkY_bpuXRFqCR@gator4166.hostgator.com>
 <20171107141929.GA24483@embeddedor.com>
 <20171113075950.csqwxld3i42updiz@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41564 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752653AbdKMMqX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 07:46:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65CF0392E0C
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:46:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4DFA7BAC53
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:46:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171113075950.csqwxld3i42updiz@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 13, 2017 at 08:59:50AM +0100, Simon Horman wrote:
> On Tue, Nov 07, 2017 at 08:19:29AM -0600, Gustavo A. R. Silva wrote:
> > In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> > where we are expecting to fall through.
> > 
> > Addresses-Coverity-ID: 1128839
> > Addresses-Coverity-ID: 1128840
> > Addresses-Coverity-ID: 115120
> > Addresses-Coverity-ID: 115121
> > Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Pablo, could you take this one directly?

Applied, thanks!
