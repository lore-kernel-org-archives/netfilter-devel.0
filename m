From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: Ensure u8 attributes are loaded
 from u32 within the bounds
Date: Thu, 22 Sep 2016 17:02:05 +0200
Message-ID: <20160922150205.GA17409@salvia>
References: <20160914125959.GA3020@sonyv>
 <20160922145836.GA15625@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934268AbcIVPCV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 11:02:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D67A49D324
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:02:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C58BCDA81C
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:02:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDAEBDA849
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:02:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160922145836.GA15625@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 22, 2016 at 04:58:36PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 14, 2016 at 03:00:02PM +0200, Laura Garcia Liebana wrote:
> > Check storage of u32 netlink attributes in smaller resources. This
> > validation is usually required when the u32 netlink attributes are being
> > stored in a private structure size of u8 in the kernel.
> 
> Applied with changes, no need to resend. If I break anything, just
> follow up on top.

And for the record:

netfilter: nf_tables: validate maximum value of u32 netlink attributes

I have renamed the titled to this, slightly shorter.
