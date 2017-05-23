From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3] List handles of added rules if requested
Date: Tue, 23 May 2017 23:04:26 +0200
Message-ID: <20170523210426.GA5212@salvia>
References: <20170519114532.4484-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37304 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161388AbdEWVEk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2017 17:04:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A29A4E1220
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:04:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9255BFF6F4
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:04:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 680F8FF2E2
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:04:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170519114532.4484-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 19, 2017 at 01:45:32PM +0200, Phil Sutter wrote:
> Being able to retrieve an added rule's handle atomically is a crucial
> feature for scripts invoking nft command: Without it, there is no way to
> be sure a handle extracted from 'nft list ruleset' command actually
> refers to the rule one has added before or that of another process which
> ran in between.
> 
> Extracting an added rule's handle itself is not an easy task already,
> since there is a chance that a given rule is printed differently than
> when it was added before. A simple example is port number vs. service
> name:
> 
> | nft add rule ip t c tcp dport { ssh, 80 } accept
> 
> There is no way to make 'nft list ruleset' return the rule just like
> this as depending on whether '-nn' was given or not, it either prints
> the set as '{ ssh, http }' or '{ 22, 80 }' but never in the mixed form
> that was used when adding it.
> 
> This patch adds the option to print an identifying string for each added
> rule which may be used as single parameter to a later 'nft delete rule'
> command. So a simple scripting example looks like this:
> 
> | handle=$(nft --echo add rule ip t c counter)
> | ...
> | nft delete rule $handle

Please, extend this so --echo consistently print the result for other
commands too. I prefer this works for all commands or none.

We should probably consider the introduction of unique handles to
table, chains, sets and objects at some point. Thus, you may request
to a specific version of the object, that if it is not available,
simply bail out. These handles would be printed with this --echo
option too.
