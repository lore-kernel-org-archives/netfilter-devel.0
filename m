From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 4/4] conntrackd: introduce RequestResync
 option
Date: Tue, 25 Apr 2017 13:37:32 +0200
Message-ID: <20170425113732.GB5355@salvia>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270929676.1751.18425946182083865800.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947061AbdDYLhq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 07:37:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D013D1373DA
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 13:37:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6487468
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 13:37:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6683BFF2D9
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 13:37:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149270929676.1751.18425946182083865800.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 07:28:16PM +0200, Arturo Borrero Gonzalez wrote:
> In some environments where both nodes of a cluster share all the conntracks,
> after an initial or manual resync, the conntrack information diverges from
> node to node.
> 
> I have observed that this is not due to syncronization problems, given the
> link between the nodes is very stable and stats show no issues.
> So, this could be due to every node of the cluster seing slighly different
> traffic and flow updates, perhaps different tiemouts being applied to
> the conntracks in every node.
> A manual resync (using conntrackd -n) resolves these issues inmediately.
> 
> This new configuration option tells conntrackd to request a resync
> with the other node, similar to what could happen manually using
> the 'conntrackd -n' command.
> 
> By now this option is only valid in NOTRACK sync mode.
> 
> Example configuration:
> 
> [...]
> Sync {
>         Mode NOTRACK {
>                 DisableInternalCache on
>                 DisableExternalCache on
>                 RequestResync 30

This looks very similar to the timer based approach that it is already
there. Did you give it a try?

This approach doesn't solve nicely the case where you have an entry
with a large timeout that got out of sync.
