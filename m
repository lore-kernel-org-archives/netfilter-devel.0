From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: speed up netns cleanup
Date: Mon, 1 May 2017 11:20:36 +0200
Message-ID: <20170501092036.GA3476@salvia>
References: <20170424133741.2707-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54390 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S376439AbdEAJUl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 05:20:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 187BD1F4B81
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:20:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0914FDA870
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:20:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 048E2FF137
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:20:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170424133741.2707-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 24, 2017 at 03:37:38PM +0200, Florian Westphal wrote:
> low hanging fruits to speed up netns cleanup in netfilter.
> We're way too happy to issue expensive synchronize_rcu() all
> over the place.
> 
> On my test vm 8 processes doing 32 unshare each finish in ~3 minutes,
> with these patches it gets down to 40 seconds.

If this is a script, can we place this somewhere to keep an eye on
this?

> We could probably further improve this.

Series applied. I have taken v2 of 2/3.
