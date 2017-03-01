From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] mnl: continue monitor if errno is ESRCH
Date: Wed, 1 Mar 2017 16:18:00 +0100
Message-ID: <20170301151800.GA1044@salvia>
References: <20170226163058.24754-1-alexander@alemayhu.com>
 <20170226202410.GB1827@salvia>
 <20170301112103.GA14422@salvia>
 <20170301114140.GA14753@salvia>
 <20170301145227.GA10448@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alexander Alemayhu <alexander@alemayhu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49198 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751093AbdCAPSM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 10:18:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3612C1AEA75
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 16:18:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25565DA819
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 16:18:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E44CFDA80B
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 16:18:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170301145227.GA10448@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 01, 2017 at 03:52:27PM +0100, Alexander Alemayhu wrote:
> On Wed, Mar 01, 2017 at 12:41:40PM +0100, Pablo Neira Ayuso wrote:
> > 
> > Actually, this patch would be better. All return values of these
> > notify function are ignored, so we can turned it into void.
> 
> Monitor seems to work as expected and does not exit with this patch.
> Should all of the tests pass with this? Currently seeing
> 
> I: results: [OK] 58 [FAILED] 49 [TOTAL] 107

Hm, I'm hitting this here:

I: results: [OK] 107 [FAILED] 0 [TOTAL] 107

Running nft git HEAD and nf.git kernel.

If you're on the same page as me, would you run some test individually
to see what is breaking?

Thanks.
