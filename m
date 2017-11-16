From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] Eliminate struct mnl_ctx
Date: Thu, 16 Nov 2017 14:32:14 +0100
Message-ID: <20171116133214.GA2455@salvia>
References: <20171110230617.15449-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932671AbdKPNcS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 08:32:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 208FB2E784C
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 14:32:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0EA6CDA86E
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 14:32:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171110230617.15449-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 11, 2017 at 12:06:17AM +0100, Phil Sutter wrote:
> The issue leading to this patch was that debug output in nft_mnl_talk()
> bypasses the application-defined output_fp. While investigating, another
> problem was discovered: Most of the ad-hoc defined mnl_ctx objects have
> their field 'debug_mask' set to zero regardless of what netlink_ctx
> contains (this affects non-batch code path only).

Applied, thanks Phil.
