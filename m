From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] datatype: Replace getaddrinfo() by internal lookup
 table
Date: Mon, 6 Feb 2017 22:13:13 +0100
Message-ID: <20170206211313.GA17256@salvia>
References: <20170206155339.GA9984@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60204 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752325AbdBFVNT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 16:13:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66B34180190
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 22:13:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E199DA7FA
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 22:13:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 114A4DA725
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 22:13:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170206155339.GA9984@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 06, 2017 at 01:53:40PM -0200, Elise Lennion wrote:
> Nftables uses a internal service table to print service names. This
> very table should be used when parsing new rules, to avoid conflicts
> between nft service table and the local /etc/services, when loading
> an exported ruleset.
> 
> Complements the commit:
> (ccc5da4: datatype: Replace getnameinfo() by internal lookup table)
> 
> Fixes(Bug 1118 - nft: nft -f and nft list ruleset use different sets of
> service -> port mappings)

Applied, thanks Elise.
