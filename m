From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] extensions: libxt_statistic: Complete nft
 translator
Date: Mon, 13 Mar 2017 17:53:53 +0100
Message-ID: <20170313165353.GA32057@salvia>
References: <20170313160153.21120-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36542 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdCMQyI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 12:54:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 192861AAAE6
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 17:54:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0ACABDA80B
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 17:54:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14691DA80B
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 17:53:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170313160153.21120-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 13, 2017 at 05:01:53PM +0100, Phil Sutter wrote:
[...]
> The nftables numgen expression works differently:

Phil, if you think we need a 1:1 mapping so iptables users moving to
nftables don't get confused, I'll be fine to take an update to
nft_numgen so we accomodate a new NFT_NG_PROBABILISTIC mode or so.

Thanks!
