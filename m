From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 1/2] netfilter: resolve warnings about missing
 prototypes
Date: Mon, 29 May 2017 11:34:52 +0200
Message-ID: <20170529093452.GA10004@salvia>
References: <20170519162942.30004-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbdE2Je4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 05:34:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 092091DA08A
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:34:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EEE0F100A6C
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:34:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1458100A6C
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:34:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170519162942.30004-1-sthemmin@microsoft.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 19, 2017 at 09:29:41AM -0700, Stephen Hemminger wrote:
> Missing include file causes:
> 
> net/netfilter/nf_dup_netdev.c:26:6: warning: no previous prototype for ‘nf_fwd_netdev_egress’ [-Wmissing-prototypes]
> net/netfilter/nf_dup_netdev.c:40:6: warning: no previous prototype for ‘nf_dup_netdev_egress’ [-Wmissing-prototypes]

Applied to nf-next, thanks.
