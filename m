From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_conntrack: bump version to 1.0.7
Date: Mon, 17 Jul 2017 19:21:55 +0200
Message-ID: <20170717172155.GA2434@salvia>
References: <20170710203350.29166-1-richard@nod.at>
 <20170717154014.GA32112@salvia>
 <2f1aae18-6706-dd67-654d-1146c035c0d5@nod.at>
 <20170717160316.GA573@salvia>
 <nycvar.YFH.7.76.1707171808410.32562@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Weinberger <richard@nod.at>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40760 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751293AbdGQRWI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 13:22:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAEE924711
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 19:21:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9BDCFDA46D
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 19:21:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38177DA80E
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 19:21:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1707171808410.32562@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 17, 2017 at 06:28:48PM +0200, Jan Engelhardt wrote:
> 
> On Monday 2017-07-17 18:03, Pablo Neira Ayuso wrote:
> >
> >IIRC, we should always bump current and version even if no changes
> >happen. Rules are here:
> >
> >http://git.netfilter.org/libmnl/tree/Make_global.am
> 
> If I read those rules correctly -
> 
>  "If any interfaces have been added"
> 
> - then, since no interface was added, removed, or otherwise modified, no bump
> is the right thing.

Right, after another read, it seems bump is unnecessary.

So I'm taking Richard's patch as is.
