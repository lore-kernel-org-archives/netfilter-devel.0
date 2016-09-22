From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_queue: improve queue range support
 for bridge family
Date: Thu, 22 Sep 2016 17:18:27 +0200
Message-ID: <20160922151827.GB17824@salvia>
References: <1473943816-26103-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42548 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933098AbcIVPSl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 11:18:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0A1EEC1079
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:18:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ECE11DA845
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:18:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 666D3DA817
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:18:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473943816-26103-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 15, 2016 at 08:50:16PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> After commit ac2863445686 ("netfilter: bridge: add nf_afinfo to enable
> queuing to userspace"), we can queue packets to the user space in bridge
> family. But when the user specify the queue range, packets will be only
> delivered to the first queue num. Because in nfqueue_hash, we only support
> ipv4 and ipv6 family. Now add support for bridge family too.

Applied, thanks for finishing this!
