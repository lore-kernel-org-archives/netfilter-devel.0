From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_ah: Fix translation of plain '-m ah'
Date: Tue, 29 Nov 2016 23:00:50 +0100
Message-ID: <20161129220050.GA29033@salvia>
References: <20161125163239.6448-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46576 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753993AbcK2WA4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 17:00:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2194C174D1F
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:00:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10DF0DA390
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:00:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E0EDDA388
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:00:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161125163239.6448-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 25, 2016 at 05:32:39PM +0100, Phil Sutter wrote:
> This is actually a limitation of ip6tables:
> 
> | # ip6tables -A INPUT -p ah -j ACCEPT
> | Warning: never matched protocol: ah. use extension match instead.
> 
> The working alternative is like so:
> 
> | # ip6tables -A INPUT -m ah -j ACCEPT
> 
> But upon translating, this statement gets ignored:
> 
> | $ ip6tables-translate -A INPUT -m ah -j ACCEPT
> | nft add rule ip6 filter INPUT  counter accept
> 
> This patch (ab)uses the 'space' variable to check if a parameter to the
> 'ah' match was present and if not translates the match into an extension
> header check:
> 
> | $ ip6tables-translate -A INPUT -m ah -j ACCEPT
> | add rule ip6 filter INPUT meta l4proto ah counter accept

Applied, thanks Phil.
