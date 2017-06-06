From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] meta: permit meta nfproto ip in ip family
Date: Tue, 6 Jun 2017 18:09:03 +0200
Message-ID: <20170606160903.GA13625@salvia>
References: <20170529172538.27878-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36504 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbdFFQJM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 12:09:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B70B520990A
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:09:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A98FBFF6F0
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:09:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BAAE6FF2D9
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:09:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170529172538.27878-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 29, 2017 at 07:25:37PM +0200, Florian Westphal wrote:
> works:
> add rule ip filter input ct original saddr 1.2.3.4
> (family ctx init initialises network base to proto_ip).
> 
> fails to parse 1.2.3.4 address:
> add rule ip filter input meta nfproto ipv4 ct original saddr 1.2.3.4
> 
> ... because meta_expr_pctx_update() won't find a dependency
> from "ip" to "ip" and then overwrites the correct base with proto_unknown.
> 
> "meta nfproto ip" is useless in the ip family, as it will always match,
> i.e.  a better (but more compliated) fix would be to remove the statement
> during evaluation.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
