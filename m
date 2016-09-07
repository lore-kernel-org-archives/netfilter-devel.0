From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_chain_route: re-route before skb is
 queued to userspace
Date: Wed, 7 Sep 2016 11:07:17 +0200
Message-ID: <20160907090717.GA9687@salvia>
References: <1473172262-7962-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51878 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbcIGJH1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 05:07:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C82B213A370
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 11:07:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF24E1150C5
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 11:07:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01B1215D62B
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 11:07:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473172262-7962-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 06, 2016 at 10:31:02PM +0800, Liping Zhang wrote:
[...]
> This is consistent with the mangle table in iptables.

Right, thanks for getting this code in sync with the ip{6}table_mangle
codebase.

So I'm applying this.
