From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] List handles of added rules if requested
Date: Mon, 8 May 2017 19:31:09 +0200
Message-ID: <20170508173109.GA32191@salvia>
References: <20170505143323.29654-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754244AbdEHRbV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 13:31:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8E6C71EC2C6
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:31:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F3AF1B908E
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:31:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C7311B9092
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:31:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170505143323.29654-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 05, 2017 at 04:33:23PM +0200, Phil Sutter wrote:
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
> This patch prints an identifying string for each added rule which may be
> used as single parameter to a later 'nft delete rule' command. So a
> simple scripting example looks like this:
> 
> | handle=$(nft add rule ip t c counter)
> | ...
> | nft delete rule $handle
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Pass NLM_F_ECHO to kernel to leverage already existing reporting
>   infrastructure and therefore not require a seperate kernel patch.
> - Limit mnl_callback() action to NEWRULE messages - when replacing a
>   rule, it would otherwise print the deleted rule as well.

This does not work for nft -i.
