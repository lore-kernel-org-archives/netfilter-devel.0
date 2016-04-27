From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 7/7] nft: add flow statement
Date: Wed, 27 Apr 2016 18:37:27 +0200
Message-ID: <20160427163727.GA2006@salvia>
References: <1461756590-22880-1-git-send-email-kaber@trash.net>
 <1461756590-22880-8-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32993 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbcD0Qhh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 12:37:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 13153E6642
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 18:37:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 04A24A91F
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 18:37:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F295464472
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 18:37:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1461756590-22880-8-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 27, 2016 at 12:29:50PM +0100, Patrick McHardy wrote:
> The flow statement allows to instantiate per flow statements for user
> defined flows. This can so far be used for per flow accounting or limiting,
> similar to what the iptables hashlimit provides. Flows can be aged using
> the timeout option.
> 
> Examples:
> 
> # nft filter input flow ip saddr . tcp dport limit rate 10/second
> # nft filter input flow table acct iif . ip saddr timeout 60s counter

I think you have to update this syntax to:

# nft add rule filter input \
        flow { ip saddr . tcp dport limit rate 10/second }
             ^                                           ^

# nft add rule filter input \
        flow table acct { iif . ip saddr timeout 60s counter }
                        ^                                    ^

so the idea is to wrap this around brackets.

When playing around with this in your initial patchset I found very
confusing that it may not look obvious to users that they can only use
one single statement.

For example:

# nft add rule filter input \
        flow table acct iif . ip saddr timeout 60s counter limit rate 10/second
                                                           ~~~~~~~~~~~~~~~~~~~~

Note that this limit rate applies globally.

This may cause us problems in the future too if we extend this to
support more than one single statement per flowtable entry (Not
telling we need this now, but if someone comes up with a useful
usecase, we should be capable of extending this).
