From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: support ct l3proto/protocol without direction
 syntax
Date: Mon, 17 Oct 2016 18:28:16 +0200
Message-ID: <20161017162816.GA15107@salvia>
References: <1474554892-50927-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38550 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935315AbcJQQ22 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 12:28:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3DED015AEB5
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 18:28:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D27BDA819
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 18:28:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8BE7DA819
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 18:28:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474554892-50927-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 22, 2016 at 10:34:52PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Acctually, ct l3proto and ct protocol are unrelated to direction, so
> it's unnecessary that we must specify dir if we want to use them.
> 
> Now add support that we can match ct l3proto/protocol without direction:
>   # nft add rule filter input ct l3proto ipv4
>   # nft add rule filter output ct protocol 17
> 
> Note: existing syntax is still preserved, so "ct reply l3proto ipv6"
> is still fine.

Applied, thanks.

Sorry, it seems I accidentally left this patch behind.
