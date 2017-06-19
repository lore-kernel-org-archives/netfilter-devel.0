From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] nf_tables: reduce chain type table size
Date: Mon, 19 Jun 2017 19:20:18 +0200
Message-ID: <20170619172018.GA5807@salvia>
References: <20170614095129.5705-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32918 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750780AbdFSRU1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 13:20:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 542AB2E7843
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:20:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48265ADC7
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:20:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5572C1FFCB
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:20:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170614095129.5705-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 14, 2017 at 11:51:29AM +0200, Florian Westphal wrote:
>        text  data  bss     dec    hex filename
> old: 151590  2240 1152  154982  25d66 net/netfilter/nf_tables_api.o
> new: 151666  2240  416  154322  25ad2 net/netfilter/nf_tables_api.o

Applied, thanks Florian.
