From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: Allow to list ruleset without stateful
 information
Date: Mon, 16 Jan 2017 11:30:15 +0100
Message-ID: <20170116103015.GA5482@salvia>
References: <20170113145058.GA8030@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38058 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750849AbdAPKab (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 05:30:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB092E7B92
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:30:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C59EFA7BEC
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:30:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4827C3536
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:30:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170113145058.GA8030@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 13, 2017 at 12:50:58PM -0200, Elise Lennion wrote:
> Currently only counter and quota have stateful information.
> 
> Standard list ruleset:
> 
> table ip x {
> 	chain y {
> 		type filter hook output priority 0; policy accept;
> 		tcp dport https counter packets 149 bytes 10085
> 		tcp dport https quota 1025 mbytes used 9 kbytes
> 	}
> }
> 
> With stateless option, -s:
> 
> table ip x {
> 	chain y {
> 		type filter hook output priority 0; policy accept;
> 		tcp dport https counter
> 		tcp dport https quota 1025 mbytes
> 	}
> }

This looks fine.

But you also have to update obj_print_data().

Stateful objects is a new thing, so please make sure you run a fresh
kernel, latest libnftnl and nft. You have examples here:

http://marc.info/?l=netfilter-devel&m=148029128323837&w=2

Note: For stateful counter with a name, at this stage, probably best
thing is to display 0 both for packets and bytes instead of removing
them, ie.

 # nft list counters
 table ip filter {
       counter http-traffic {
             packets 0 bytes 0
       }
 }

Thanks.
