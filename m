From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: log_arp: Use ARPHRD_ETHER instead of
 literal '1'
Date: Tue, 30 Aug 2016 11:54:48 +0200
Message-ID: <20160830095448.GB20414@salvia>
References: <1472391682-13832-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34356 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757521AbcH3Jy6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 05:54:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 60E4312A691
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:54:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51A36100A7F
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:54:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FA33100A7D
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:54:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472391682-13832-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 28, 2016 at 09:41:22PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There is one macro ARPHRD_ETHER which defines the ethernet proto for ARP,
> so we could use it instead of the literal number '1'.

Also applied, thanks.
