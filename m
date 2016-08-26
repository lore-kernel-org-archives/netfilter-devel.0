From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] expr: imm: Fix immediate verdict comparison
Date: Fri, 26 Aug 2016 19:26:48 +0200
Message-ID: <20160826172648.GA25007@salvia>
References: <20160825151930.GA3482@salvia>
 <20160826134922.15496-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57138 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751691AbcHZR07 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2016 13:26:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAD061022B8
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2016 19:26:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB937114D76
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2016 19:26:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DC2B100A7D
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2016 19:26:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160826134922.15496-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 26, 2016 at 03:49:22PM +0200, Carlos Falgueras García wrote:
> An immediate expression of type 'DATA_VERDICT' can have set a chain (jump
> or goto), in this cases we must compare its 'union nftnl_data_reg' using
> 'DATA_CHAIN' flag instead of 'DATA_VERDICT'
> 
> Before this patch compare expressions "jump -> chain_a" and
> "jump -> chain_b" returns they are equals.

Applied, thanks Carlos.

> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---
> V2: Chosen a clearest code structure

Please, place v2 also in your patch subject, ie.

        [PATCH libnftnl,v2] expr: imm: Fix immediate verdict comparison

Thanks.
