From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 01/17] rename struct ct to ct_helper
Date: Tue, 18 Jul 2017 18:54:09 +0200
Message-ID: <20170718165409.GA18230@salvia>
References: <20170628100659.26976-1-fw@strlen.de>
 <20170628100659.26976-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751363AbdGRQyN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 12:54:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BDB024D651
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 18:54:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF675DA80E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 18:54:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6C29DA57F
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 18:53:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170628100659.26976-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I apply these series, from 2 to 17, but this doesn't compile.

make[1]: Entering directory
'/home/pablo/devel/scm/git-netfilter/nftables'
Making all in src
make[2]: Entering directory
'/home/pablo/devel/scm/git-netfilter/nftables/src'
  YACC     parser_bison.c
/home/pablo/devel/scm/git-netfilter/nftables/src/parser_bison.y:3146.33-44: error: symbol keyword_expr is used, but is not defined as a token and has no rules
                        |       keyword_expr
                                ^^^^^^^^^^^^
/home/pablo/devel/scm/git-netfilter/nftables/src/parser_bison.y:3146.33-44: warning: type clash on default action: <expr> != <> [-Wother]
                        |       keyword_expr
                                ^^^^^^^^^^^^

This changeset is large and it is making it a bit hard for me to
review.

Could you send me a smaller batch?

I want to understand why the parser is hitting shift/reduce problems
from set statements.

Thanks.
