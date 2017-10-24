From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] doc: nft.8 simplify initial SYNOPSIS line
Date: Tue, 24 Oct 2017 18:08:11 +0200
Message-ID: <20171024160811.GA17950@salvia>
References: <20171020112915.5859-1-duncan_roe@optusnet.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Duncan Roe <duncan_roe@optusnet.com.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59054 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751465AbdJXQIQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 12:08:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC940E9781
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:08:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD0E1DA872
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:08:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171020112915.5859-1-duncan_roe@optusnet.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 20, 2017 at 10:29:15PM +1100, Duncan Roe wrote:
> In the style of tcpdump.8: where options have short and long forms, only show
> short form in synopsis but mention long form in description.
> Re-order option descriptions to match order in synopsis (move -N to just after -n).

Applied, thanks Duncan.
