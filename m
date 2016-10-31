From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: nf_queue: place volatile data in own
 cacheline
Date: Mon, 31 Oct 2016 15:19:59 +0100
Message-ID: <20161031141959.GA21437@salvia>
References: <1477870507-10453-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52460 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943414AbcJaOUF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 10:20:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23A3AE8391
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:20:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 083BFDA841
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:20:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE308DA7F6
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:20:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477870507-10453-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 31, 2016 at 12:35:07AM +0100, Florian Westphal wrote:
> As the comment indicates, the data at the end of nfqnl_instance struct is
> written on every queue/dequeue, so it should reside in its own cacheline.
> 
> Before this change, 'lock' was in first cacheline so we dirtied both.

Applied, thanks Florian.
