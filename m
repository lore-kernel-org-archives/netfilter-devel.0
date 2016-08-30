From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v3 2/2] xtables-compat: add rule cache
Date: Tue, 30 Aug 2016 18:58:22 +0200
Message-ID: <20160830165822.GA1175@salvia>
References: <20160826165844.6849-1-pablombg@gmail.com>
 <20160826165844.6849-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57168 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758453AbcH3Q63 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 12:58:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B9ADA7E2E
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 18:58:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B7B21B3208
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 18:58:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F40BFF2D5
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 18:58:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160826165844.6849-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 26, 2016 at 06:58:44PM +0200, Pablo M. Bermudo Garay wrote:
> This patch adds a cache of rules within the nft handle. This feature is
> useful since the whole ruleset was brought from the kernel for every
> chain during listing operations. In addition with the new checks of
> ruleset compatibility, the rule list is loaded one more time.
> 
> Now all the operations causing changes in the ruleset must invalidate
> the cache, a function called flush_rule_cache has been introduced for
> this purpose.

Applied, thanks!
