From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] List handles of added rules if requested
Date: Thu, 4 May 2017 15:36:26 +0200
Message-ID: <20170504133626.GC5607@salvia>
References: <20170504123421.22147-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbdEDNgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 09:36:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5BF0E210566
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 15:36:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B354FF2C1
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 15:36:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E817FF2C8
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 15:36:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170504123421.22147-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 04, 2017 at 02:34:21PM +0200, Phil Sutter wrote:
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

This is a hack.

We should follow the rule description path.
