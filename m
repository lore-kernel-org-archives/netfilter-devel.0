From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Out Of Bound Read in Netfilter Conntrack
Date: Tue, 24 Oct 2017 18:36:01 +0200
Message-ID: <20171024163601.GA30318@salvia>
References: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
 <20171024162903.GA20295@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751910AbdJXQgI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 12:36:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3F6A2EAA65
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:36:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E0FBDA848
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:36:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171024162903.GA20295@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 24, 2017 at 06:29:03PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Mon, Oct 09, 2017 at 07:01:14AM +0200, Eric Sesterhenn wrote:
> > Add missing counter decrement to prevent out of bounds memory read.
> 
> I have manually applied this. However, your patches are mangled most
> likely by MUA and patchword doesn't get it right.
> 
> If you could please revamp and make sure patches apply cleanly via:
> 
>         git am patch
> 
> I would really appreciate, thanks for your patience!

While at it, please prepend to your patches:

        netfilter: nf_ct_h323: ...

So we all know what subsystems this goes to.

Thanks a lot!
