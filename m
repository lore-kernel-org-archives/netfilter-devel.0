From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nat: use atomic bit op to clear the
 _SRC_NAT_DONE_BIT
Date: Tue, 23 May 2017 23:28:40 +0200
Message-ID: <20170523212840.GA9024@salvia>
References: <1495377491-46768-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033038AbdEWV2y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2017 17:28:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6230BE122F
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:28:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52DEEFF2E2
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:28:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3DD61FF2DC
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:28:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1495377491-46768-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 21, 2017 at 10:38:11PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> We need to clear the IPS_SRC_NAT_DONE_BIT to indicate that the ct has
> been removed from nat_bysource table. But unfortunately, we use the
> non-atomic bit operation: "ct->status &= ~IPS_NAT_DONE_MASK". So
> there's a race condition that we may clear the _DYING_BIT set by
> another CPU unexpectedly.
> 
> Since we don't care about the IPS_DST_NAT_DONE_BIT, so just using
> clear_bit to clear the IPS_SRC_NAT_DONE_BIT is enough.
> 
> Also note, this is the last user which use the non-atomic bit operation
> to update the confirmed ct->status.

Applied to nf, thanks.

Does your patchset for nf-next depend on this in any way? If so, you
will have to wait until this propagates to nf-next.
