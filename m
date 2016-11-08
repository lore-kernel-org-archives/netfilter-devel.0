From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch net] ipvs: use IPVS_CMD_ATTR_MAX for family.maxattr
Date: Tue, 8 Nov 2016 23:53:54 +0100
Message-ID: <20161108225354.GA30272@salvia>
References: <1478218443-11616-1-git-send-email-xiyou.wangcong@gmail.com>
 <20161104105843.GC24863@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, andreyknvl@google.com
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752549AbcKHWyE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 17:54:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ECD3D392E1C
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Nov 2016 23:54:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF369DA803
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Nov 2016 23:54:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2921DA809
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Nov 2016 23:53:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161104105843.GC24863@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 04, 2016 at 11:58:44AM +0100, Simon Horman wrote:
> On Thu, Nov 03, 2016 at 05:14:03PM -0700, Cong Wang wrote:
> > family.maxattr is the max index for policy[], the size of
> > ops[] is determined with ARRAY_SIZE().
> > 
> > Reported-by: Andrey Konovalov <andreyknvl@google.com>
> > Tested-by: Andrey Konovalov <andreyknvl@google.com>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> 
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Pablo, can you take this one into nf?

Applied, thanks!
