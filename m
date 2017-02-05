From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables] statement: fix print of ip dnat address
Date: Sun, 5 Feb 2017 21:45:25 +0100
Message-ID: <20170205204525.GA12703@salvia>
References: <20170203142545.13724-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbdBEUpe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Feb 2017 15:45:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BA6CB131CAF
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:45:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADAE5DA809
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:45:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C31A5DA807
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:45:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170203142545.13724-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 03, 2017 at 03:25:45PM +0100, Florian Westphal wrote:
> the change causes non-ipv6 addresses to not be printed at all in case
> a nfproto was given.
> 
> Also add a test case to catch this.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1117
> Fixes: 5ab0e10fc6e2c22363a ("src: support for RFC2732 IPv6 address format with brackets")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for fixing up this one.
