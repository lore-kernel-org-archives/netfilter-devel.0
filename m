From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables and iptables nat coexistence
Date: Thu, 19 Oct 2017 13:30:33 +0200
Message-ID: <20171019113033.GA3537@salvia>
References: <20171018135650.GA16796@breakpoint.cc>
 <20171019101529.GA2224@salvia>
 <20171019111812.GC16796@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752000AbdJSLai (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 07:30:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7041F52300
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 13:30:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40C09DA38F
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 13:30:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171019111812.GC16796@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 19, 2017 at 01:18:12PM +0200, Florian Westphal wrote:
> Registering implicit nat hook, making iptables_nat and nftables nat
> at the same time impossible (reject from kernel) etc. is more
> convenient as we cannot break existing setups and only prevent
> configuring a non-working/broken state rather than allowing things
> that do not work at the moment.

Yes, let's tighten things now, we can relax them later.
