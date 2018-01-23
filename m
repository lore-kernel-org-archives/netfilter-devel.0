From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: question about UNDEFINE/REDEFINE
Date: Tue, 23 Jan 2018 12:07:28 +0100
Message-ID: <20180123110728.i7hujeyz6224atd2@salvia>
References: <3622208.jy4NlOniyd@voxel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: David Fabian <david.fabian@cldn.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbeAWLHd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 06:07:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C89921EC2C8
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 12:07:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6873DA3A0
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 12:07:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <3622208.jy4NlOniyd@voxel>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi David,

On Mon, Jan 22, 2018 at 02:53:09PM +0100, David Fabian wrote:
> Hello,
> 
> we have a firewall written in bash (using iptables) that is organized by 
> customer VLANs. Each VLAN has its own set of bash variables holding things 
> like uplink iface names, gateway IPs, etc. We want to rewrite the firewall to 
> nftables but are stuck on the fact that nft variables cannot be overridden in 
> the same scope. We have each VLAN configuration in a separate file containing 
> pre/post-routing, input, output and forward rules,and we include those files to 
> a master firewall configuration. One solution is to rename all the variables 
> with some VLAN specific (pre/su)ffix. But that is cumbersome.
> 
> I have made a small patch to nft which adds two new keywords - undefine and 
> redefine. undefine simply undefines a variable from the current scope. redefine 
> allows one to change a variable definition. The patch works against the latest 
> fedora nft (version 0.7) but I believe it should work against master as well. 
> I don't know how to properly send the patch to the project so I am attaching 
> it here. I would like to know your opinion.

Thanks for sending us this patch.

Question here: If we allow to pass variable definitions via -D option
from the command line, would that work for you too?

I'm asking here because I would need to understand better how you've
structured your scripts, if you could explain a bit more, we would
appreciate.

Thanks!
