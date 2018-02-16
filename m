From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Fri, 16 Feb 2018 17:32:15 -0500 (EST)
Message-ID: <20180216.173215.1339573591278597275.davem@davemloft.net>
References: <20180216134023.15536-1-daniel@iogearbox.net>
        <20180216145727.GC32618@breakpoint.cc>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: daniel@iogearbox.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, alexei.starovoitov@gmail.com
To: fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:59966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbeBPWcT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 17:32:19 -0500
In-Reply-To: <20180216145727.GC32618@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>
Date: Fri, 16 Feb 2018 15:57:27 +0100

> 4. Do you plan to reimplement connection tracking in userspace?
> If no, how will the bpf program interact with it?

The natural way to handle this, as with anything BPF related, is with
appropriate BPF helpers which would be added for this purpose.
