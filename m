From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 2/2] netfilter: nf_tables: make local functions
 static
Date: Mon, 29 May 2017 11:35:02 +0200
Message-ID: <20170529093502.GB10004@salvia>
References: <20170519162942.30004-1-sthemmin@microsoft.com>
 <20170519162942.30004-2-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58522 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbdE2JfK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 05:35:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C617F1DA084
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:35:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6C4310079D
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:35:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C62A2102195
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:34:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170519162942.30004-2-sthemmin@microsoft.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 19, 2017 at 09:29:42AM -0700, Stephen Hemminger wrote:
> Resolves warnings:
> net/netfilter/nft_rt.c:26:6: warning: no previous prototype for ‘nft_rt_get_eval’ [-Wmissing-prototypes]
> net/netfilter/nft_rt.c:75:5: warning: no previous prototype for ‘nft_rt_get_init’ [-Wmissing-prototypes]
> net/netfilter/nft_rt.c:106:5: warning: no previous prototype for ‘nft_rt_get_dump’ [-Wmissing-prototypes]

Also applied, thanks.
