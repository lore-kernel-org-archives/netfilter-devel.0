From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: question about UNDEFINE/REDEFINE
Date: Fri, 26 Jan 2018 14:48:47 +0100
Message-ID: <20180126134847.hrk673qbogbozqci@salvia>
References: <3622208.jy4NlOniyd@voxel>
 <20180123110728.i7hujeyz6224atd2@salvia>
 <1993002.08LkLsM8EI@voxel>
 <20180126134549.t5wjq63x7vw7efcw@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: David Fabian <david.fabian@cldn.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752033AbeAZNsu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jan 2018 08:48:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2DE65DA72B
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2018 14:48:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CA79DA84A
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2018 14:48:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180126134549.t5wjq63x7vw7efcw@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 26, 2018 at 02:45:49PM +0100, Pablo Neira Ayuso wrote:
[...]
> 2) Probably even cleaner is to look at 'local' scopes like in bash.
> 
>  define local IP1 = 1.1.1.1
> 
> so the symbol is bound to this file - consider the content of a file
> determines a given scope. This can be also useful to the nested
> notation.

Actually, this would have different semantics to what bash offers,
since local variable are bound to the scope.

In the flat notation, there's one single scope for all of your
ruleset.
