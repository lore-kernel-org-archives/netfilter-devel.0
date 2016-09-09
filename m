From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] datatype: ll: use big endian byte ordering
Date: Fri, 9 Sep 2016 15:33:04 +0200
Message-ID: <20160909133304.GA24473@salvia>
References: <1473424996-26957-1-git-send-email-fw@strlen.de>
 <1473424996-26957-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57968 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750953AbcIINdH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 09:33:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 07C092273DF
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:33:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDFE4DA7F7
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:33:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBC2A114D77
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:33:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473424996-26957-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 09, 2016 at 02:43:14PM +0200, Florian Westphal wrote:
> ether daddr set 00:03:2d:2b:74:ec  is listed as:
> ether daddr set ec:74:2b:2d:03:00
> 
> (it was fine without 'set' keyword).  Reason is that
> ether address was listed as being HOST endian.
> 
> The payload expression (unlike statement) path contains
> a few conversion call sites for this, i.e.:
> 
> if (tmp->byteorder == BYTEORDER_HOST_ENDIAN)
>    mpz_switch_byteorder(tmp->value, tmp->len / BITS_PER_BYTE);
> 
> ... it might make sense to remove those in a followup patch.
> 
> Reported-by: Laura Garcia Liebana <nevola@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
