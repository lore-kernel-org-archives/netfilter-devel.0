From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Wed, 10 May 2017 13:38:55 +0200
Message-ID: <20170510113855.GD29824@salvia>
References: <20170510105510.891-1-phil@nwl.cc>
 <20170510112724.GD16263@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35702 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751593AbdEJLjH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2017 07:39:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18602DFE37
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2017 13:38:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A68C6E7A9
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2017 13:38:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6E5A100791
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2017 13:38:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170510112724.GD16263@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 10, 2017 at 01:27:24PM +0200, Florian Westphal wrote:
> nlmsg_pid is the netlink portid.

Right.

> While most programs set it to their process id there is no guarantee.
> Its just a (unique) 32 bit identifier.

It's actually the kernel that decides what portID the socket gets
IIRC. For the first socket it uses the process ID, then for follow up
sockets, it just looks for a spare ID in the negative range of the 32
bit, if my memory serves well.

> Afaics one has to use /proc/net/netlink to map the portid to the inode
> and then walk /proc/*/fd/* to find the socket with that inode.
> 
> Perhaps there is a simpler way, maybe you can check what ss is doing
> and what info can be obtained via netlink diag.

I wouldn't be surprise if we need more kernel infrastructure to deal
with this. Parsing /proc for a netlink thing is definitely not ideal.
