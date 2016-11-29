From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] nft_ipv{4,6}_xlate: Respect prefix lengths
Date: Tue, 29 Nov 2016 23:01:17 +0100
Message-ID: <20161129220117.GC29033@salvia>
References: <20161125175255.11878-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46672 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756843AbcK2WBW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 17:01:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BFE31174D13
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:01:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1253DA390
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:01:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E85ADA388
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:01:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161125175255.11878-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 25, 2016 at 06:52:55PM +0100, Phil Sutter wrote:
> This was an annoying bug in the translator since it silently dropped
> crucial information which is easily overlooked:
> 
> | $ iptables-translate -A INPUT -s 192.168.0.0/24 -j ACCEPT
> | nft add rule ip filter INPUT ip saddr 192.168.0.0 counter accept
> | $ ip6tables-translate -A INPUT -s feed:babe::/64 -j ACCEPT
> | nft add rule ip6 filter INPUT ip6 saddr feed:babe:: counter accept
> 
> To my surprise, this fix works really well in all kinds of situations:
> 
> | $ iptables-translate -A INPUT -s 1.2.3.4/0 -j ACCEPT
> | nft add rule ip filter INPUT counter accept
> |
> | $ iptables-translate -A INPUT -s 1.2.3.4/23 -j ACCEPT
> | nft add rule ip filter INPUT ip saddr 1.2.2.0/23 counter accept
> |
> | $ iptables-translate -A INPUT -s 1.2.3.4/24 -j ACCEPT
> | nft add rule ip filter INPUT ip saddr 1.2.3.0/24 counter accept
> |
> | $ iptables-translate -A INPUT -s 1.2.3.4/32 -j ACCEPT
> | nft add rule ip filter INPUT ip saddr 1.2.3.4 counter accept
> |
> | $ iptables-translate -A INPUT -s 1.2.3.4/255.255.0.0 -j ACCEPT
> | nft add rule ip filter INPUT ip saddr 1.2.0.0/16 counter accept
> 
> Ditto for IPv6.

Applied, thanks!
