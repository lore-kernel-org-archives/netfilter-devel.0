From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: insist that the lock is held.
Date: Mon, 29 May 2017 14:02:32 +0200
Message-ID: <20170529120232.GA11187@salvia>
References: <20170519070859.75808-1-lorenzo@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jscherpelz@google.com,
        subashab@codeaurora.org, dcbw@redhat.com, aconole@bytheb.org
To: Lorenzo Colitti <lorenzo@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40430 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751194AbdE2MCk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 08:02:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9A805303D03
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:02:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8AFE7100A7F
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:02:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91453102183
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:02:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170519070859.75808-1-lorenzo@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 19, 2017 at 04:08:59PM +0900, Lorenzo Colitti wrote:
> Currently, iptables programs will exit with an error if the
> iptables lock cannot be acquired, but will silently continue if
> the lock cannot be opened at all. This can cause unexpected
> failures (with unhelpful error messages) in the presence of
> concurrent updates, which can be very difficult to find in a
> complex or multi-administrator system.
> 
> Instead, refuse to do anything if the lock cannot be acquired.
> The behaviour is not affected by command-line flags because:
> 
> 1. In order to reliably avoid concurrent modification, all
>    invocations of iptables commands must follow this behaviour.
> 2. Whether or not the lock can be opened is typically not
>    a run-time condition but is likely to be a configuration
>    error.
> 
> Existing systems that depended on things working mostly correctly
> even if there was no lock might be affected by this change.
> However, that is arguably a configuration error, and now that the
> iptables lock is configurable, it is trivial to provide a lock
> file that is always accessible: if nothing else, the iptables
> binary itself can be used. The lock does not have to be writable,
> only readable.
> 
> Tested by configuring the system to use an xtables.lock file in
> a non-existent directory and observing that all commands failed.

Applied, thanks Lorenzo.
