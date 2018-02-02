From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: xt_hashlimit: do not allow empty names
Date: Fri, 2 Feb 2018 13:17:23 +0100
Message-ID: <20180202121723.47wr5qosugbdse76@salvia>
References: <1517154099.3715.77.camel@gmail.com>
 <1517162045.3715.78.camel@gmail.com>
 <20180202114938.jxsaun6w3hnfedfz@salvia>
 <20180202115522.bmuukhfib4harcoy@salvia>
 <alpine.LSU.2.20.1802021306530.14157@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53756 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751709AbeBBMR1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Feb 2018 07:17:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 354938D0502
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 13:17:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23A83DA78C
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 13:17:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1802021306530.14157@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 02, 2018 at 01:12:08PM +0100, Jan Engelhardt wrote:
> On Friday 2018-02-02 12:55, Pablo Neira Ayuso wrote:
> 
> >On Fri, Feb 02, 2018 at 12:49:38PM +0100, Pablo Neira Ayuso wrote:
> >[...]
> >> bool net_valid_name(const char *name, size_t len)
> >> {
> >>         ...
> >> }
> >
> >Am I missing anything in all these tricky string handling? Thanks!
> 
> One will have to watch out for calls like
> 
> 	net_valid_name(NLA_DATA(some_ifla_name), IFNAMSIZ)
> 
> because quite some nlattrs (IFLA_NAME, IFLA_IFNAME to boot) are NLA_STRINGs
> (rather than NLA_NUL_STRINGs) and they are not \0-terminated.

As long as we use nla_str*() helpers, we're all good.
