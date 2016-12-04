From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 nf-next] netfilter: allow disabling
 conntrack-on-by-default
Date: Sun, 4 Dec 2016 21:12:22 +0100
Message-ID: <20161204201222.GA32511@salvia>
References: <1479242205-21675-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60904 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbcLDUMb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 15:12:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93D77B6C6F
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:12:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 845FEDA851
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:12:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 966E5DA851
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:12:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479242205-21675-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 15, 2016 at 09:36:38PM +0100, Florian Westphal wrote:
> Historically all the netfilter hooks got registered on module load time.
> 
> When net namespace support was added, hooks were registered in each
> namespace (and new net namespaces inherit already-registered hooks from
> global list).
> 
> This means that once nf_conntrack_ipv4/6.ko is loaded, all
> existing and future net namespaces do connection tracking.
> 
> This series adds a new sysctl, nf_conntrack_default_on, that can be set
> to 0 to disable this behaviour.
> 
> Once its set to 0, conntrack hooks are not registered in newly created
> net namespaces, and new l3 protocol trackers are not registered with any
> existing namespaces either.
> 
> The setting does NOT disable already-active connection tracking
> in existing namespaces.
> 
> connection tracking is enabled via packet filter ruleset, regardless of
> the sysctl setting, once a rule that needs conntrack functionality is
> added (e.g. iptables -m conntrack, targets like SNAT/DNAT or nftables
> equivalents make sure the hooks get registered, and deleted, as needed).
> 
> It is currently NOT possible to disable connection tracking inside a
> net namespace that had its hooks registered implicitly due to
> nf_conntrack_default_on=1 (except unloading the l3 tracker module).

Series applied, thanks Florian.
