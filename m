From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 3/3] payload: remove byteorder conversion
Date: Fri, 9 Sep 2016 15:34:42 +0200
Message-ID: <20160909133442.GC24473@salvia>
References: <1473424996-26957-1-git-send-email-fw@strlen.de>
 <1473424996-26957-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58446 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750992AbcIINeu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 09:34:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37CF72273DB
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:34:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AAA4114D62
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:34:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D115A114D77
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:34:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473424996-26957-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 09, 2016 at 02:43:16PM +0200, Florian Westphal wrote:
> This is what made ether addresses get formatted correctly with
> plain payload expression (ether saddr 00:11 ...) when listing
> rules.  Not needed anymore since etheraddr_type is now BIG_ENDIAN.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
