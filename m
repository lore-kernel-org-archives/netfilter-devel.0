From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v2 2/2] xtables-compat: add rule cache
Date: Tue, 23 Aug 2016 13:59:30 +0200
Message-ID: <20160823115930.GA27034@salvia>
References: <20160822151119.16165-1-pablombg@gmail.com>
 <20160822151119.16165-2-pablombg@gmail.com>
 <20160823115814.GB26961@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38732 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758007AbcHWL7y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 07:59:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 481D1B6C85
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 13:59:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 398341021A1
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 13:59:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C4AEDA7F7
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 13:59:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160823115814.GB26961@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 23, 2016 at 01:58:14PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 22, 2016 at 05:11:19PM +0200, Pablo M. Bermudo Garay wrote:
> > This patch adds a cache of rules within the nft handle. This feature is
> > more useful after the new checks of ruleset compatibility, since the
> > rule list is loaded twice consecutively.
> > 
> > Now all the operations causing changes in the ruleset must invalidate
> > the cache, a function called flush_rule_cache has been introduced for
> > this purpose.

Sorry for this email in Spanish. I thought Pablo was sending me this
patchset to make it an internal review as part of the GSoC mentorship.
