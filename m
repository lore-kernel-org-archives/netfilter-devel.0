From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: Remove expire information from list stateless
 ruleset.
Date: Tue, 6 Jun 2017 18:05:41 +0200
Message-ID: <20170606160541.GA12970@salvia>
References: <59364aea.86c6620a.a5511.685a@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35302 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbdFFQFq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 12:05:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 040DC209918
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:05:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA85FFF2F1
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:05:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D37DA102191
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:05:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <59364aea.86c6620a.a5511.685a@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 11:55:40AM +0530, Varsha Rao wrote:
> As expires is stateful information. This patch removes expire
> information from list stateless ruleset. With nft -s option, the
> ruleset will be as following.
> 
> table ip firewall {
>         set host {
>                 type ipv4_addr
>                 flags timeout
>                 elements = { 10.0.0.2 timeout 10m }
>         }
> }

Applied, thanks Varsha.

Congrats, your first patch to nftables is in.
