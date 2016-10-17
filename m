From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/10, nf-next] Netfilter core updates
Date: Mon, 17 Oct 2016 19:06:59 +0200
Message-ID: <20161017170659.GA11889@salvia>
References: <1476702636-3303-1-git-send-email-pablo@netfilter.org>
 <20161017113804.GA13024@breakpoint.cc>
 <f7ty41nrskx.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Aaron Conole <aconole@bytheb.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936131AbcJQRHJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 13:07:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 021431E0DC6
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 19:07:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA0B6DA852
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 19:07:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE04FDA81B
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 19:07:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <f7ty41nrskx.fsf@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 17, 2016 at 09:52:14AM -0400, Aaron Conole wrote:
> Florian Westphal <fw@strlen.de> writes:
> 
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> Let me know if you have any comment, otherwise I'll place this in the
> >> nf-next tree so we can follow up working on top of these.
> >
> > Please do, thanks!
> 
> +1.  Some of this work was in my back burner, so thanks Pablo :)

Thanks. I still need that the fix for nf_queue propagates to David's
net tree. Will request him to pull net into net-next. May take a
little while.
