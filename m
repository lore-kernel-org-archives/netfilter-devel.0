From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4 V6 nft] Simplify parser rule_spec tree
Date: Mon, 22 Aug 2016 18:13:16 +0200
Message-ID: <20160822161315.GA5023@salvia>
References: <20160821212210.26161-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755186AbcHVQN0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 12:13:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F31011F18E1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:13:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8715DA7F6
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:13:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE249100798
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:13:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160821212210.26161-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 21, 2016 at 11:22:07PM +0200, Carlos Falgueras García wrote:
> This patch separates the rule identification from the rule localization, so
> the logic moves from the evaluator to the parser. This allows to revert the
> patch "evaluate: improve rule managment checks"
> (4176c7d30c2ff1b3f52468fc9c08b8df83f979a8) and saves a lot of code.

Applied, thanks.
