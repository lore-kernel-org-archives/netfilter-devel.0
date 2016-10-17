From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: xt_NFLOG: fix unexpected truncated packet
Date: Mon, 17 Oct 2016 17:31:31 +0200
Message-ID: <20161017153131.GA9160@salvia>
References: <1476195987-3129-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42484 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758000AbcJQPbl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 11:31:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9150FA8209
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:31:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80BB2BAC44
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:31:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8E99DA817
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:31:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476195987-3129-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 11, 2016 at 10:26:27PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Justin and Chris spotted that iptables NFLOG target was broken when they
> upgraded the kernel to 4.8: "ulogd-2.0.5- IPs are no longer logged" or
> "results in segfaults in ulogd-2.0.5".
> 
> Because "struct nf_loginfo li;" is a local variable, and flags will be
> filled with garbage value, not inited to zero. So if it contains 0x1,
> packets will not be logged to the userspace anymore.

Applied and enqueued for -stable, thanks.
