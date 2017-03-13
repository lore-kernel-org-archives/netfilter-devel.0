From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH] nftables: fib: Support existence check
Date: Mon, 13 Mar 2017 13:46:08 +0100
Message-ID: <20170313124608.GA26921@salvia>
References: <20170310170802.27802-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752359AbdCMMra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 08:47:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1252EA3F5
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:47:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83E44DA850
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:47:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D248204FD
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:46:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170310170802.27802-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 10, 2017 at 06:08:02PM +0100, Phil Sutter wrote:
> Instead of the actual interface index or name, set destination register
> to just 1 or 0 depending on whether the lookup succeeded or not if
> NFTA_FIB_F_PRESENT was set in userspace.

Applied, thanks.
