From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] parser: allow ct eventmask set new,related
Date: Wed, 7 Jun 2017 12:37:06 +0200
Message-ID: <20170607103706.GA9280@salvia>
References: <20170607102410.21024-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51860 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbdFGKhL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 06:37:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E8C924FBC8
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:37:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8AF4100A7F
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:37:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5133102185
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:36:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170607102410.21024-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 07, 2017 at 12:24:09PM +0200, Florian Westphal wrote:
> In case of bitmask types (tcp flags, ct eventmask) nft
> allows to use comma operator to test multiple values, i.e.
> tcp flags syn,ack   ct event new,destroy etc.
> 
> But currently nft fails to use this when used in a statement, i.e.
>    ... ct eventmask set new,destroy
> gives:
> syntax error, unexpected comma
> 
> This allows makes this work, it is the same as
>    ct eventmask set new|destroy
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Much nicer! Thanks for working on this!

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
