From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] Simplify parser rule_spec tree
Date: Tue, 23 Aug 2016 13:17:10 +0200
Message-ID: <20160823111710.GA1411@salvia>
References: <20160823074045.31327-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54884 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753403AbcHWLRq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 07:17:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CDB6DB6C7E
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 13:17:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABCE7114D6C
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 13:17:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A968D114D6C
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 13:17:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160823074045.31327-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 23, 2016 at 09:40:45AM +0200, Carlos Falgueras García wrote:
> This patch separates the rule identification from the rule localization, so
> the logic moves from the evaluator to the parser. This allows to revert the
> patch "evaluate: improve rule managment checks"
> (4176c7d30c2ff1b3f52468fc9c08b8df83f979a8) and saves a lot of code.

OK, now this doesn't crash anymore :).

> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---

Please, place a list of vX items describing incremental updates here
so other can follow track of what you're doing, otherwise it becomes
hard to follow.

Thanks.
