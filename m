From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,RFC v4] netfilter: nf_flow_table: add hardware
 offload support
Date: Mon, 29 Jan 2018 11:37:21 +0100
Message-ID: <20180129103721.mbumauzre4whnc2k@salvia>
References: <20180125000941.2763-1-pablo@netfilter.org>
 <20180124173136.5ec57ba7@cakuba.netronome.com>
 <20180125112858.s27mtfv3cikqfiny@salvia>
 <20180125143846.6bb5290f@cakuba.netronome.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, ronye@mellanox.com,
        simon.horman@netronome.com, jiri@mellanox.com, nbd@nbd.name,
        john@phrozen.org, fw@strlen.de
To: Jakub Kicinski <kubakici@wp.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbeA2Kh1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jan 2018 05:37:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F053A1B6941
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2018 11:37:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFDF8BAAB5
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2018 11:37:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180125143846.6bb5290f@cakuba.netronome.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jakub,

On Thu, Jan 25, 2018 at 02:38:46PM -0800, Jakub Kicinski wrote:
> On Thu, 25 Jan 2018 12:28:58 +0100, Pablo Neira Ayuso wrote:
[...]
> Ah, I must be misunderstanding.  I meant when device is removed, not
> the flow_table_hw module.  Does the nf_flow_table_hw_module_exit() run
> when device is removed?  I was expecting that, for example something
> like nft_flow_offload_iterate_cleanup() would queue up all the flow
> remove calls and then call flush_work() (not cancel_work). 

Oh right indeed, I need some code there to release all hw resources on
module removal.

Will revamp and send v5.

Thanks for reviewing!
