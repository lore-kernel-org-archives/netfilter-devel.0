From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] extensions: libxt_conntrack: Fix 'state'
 translation to nft
Date: Tue, 7 Mar 2017 17:17:29 +0100
Message-ID: <20170307161729.GA2233@salvia>
References: <20170307153507.14640-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40844 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755511AbdCGQYj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 11:24:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C75E224703
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 17:17:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A698DA84A
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 17:17:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98391DA841
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 17:17:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170307153507.14640-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 07, 2017 at 04:35:07PM +0100, Phil Sutter wrote:
> While translating a conntrack state match in old syntax, matches are
> looked up by name, only. This returned the revision 0 entry since
> matches are registered in reverse order of appearance in the array
> passed to xtables_register_matches(). The problem is that revision 0
> doesn't define an xlate callback.
> 
> Fix this by reordering the matches in conntrack_mt_reg so that the
> highest revision one is found first.

Applied, thanks Phil.
