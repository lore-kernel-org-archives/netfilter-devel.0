From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH ipset nf-next] netfilter: ipset: use nfnl_mutex_is_locked
Date: Wed, 6 Dec 2017 09:18:39 +0100
Message-ID: <20171206081839.GA4027@salvia>
References: <20171130200732.2814-1-fw@strlen.de>
 <alpine.DEB.2.11.1712012013530.26668@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33078 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752410AbdLFISn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 03:18:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CBF50C0B21
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 09:18:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCF11DA80B
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 09:18:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1712012013530.26668@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 01, 2017 at 08:14:48PM +0100, Jozsef Kadlecsik wrote:
> Hi Florian,
> 
> On Thu, 30 Nov 2017, Florian Westphal wrote:
> 
> > Check that we really hold nfnl mutex here instead of relying on correct
> > usage alone.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Yes, it's better this way :-)
> 
> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks.
