From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Revert "net: Remove state argument from
 skb_find_text()"
Date: Tue, 07 Feb 2017 10:53:20 -0500 (EST)
Message-ID: <20170207.105320.45609559819874123.davem@davemloft.net>
References: <1486273710-18457-1-git-send-email-igor.pylypiv@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: igor.pylypiv@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:49586 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754778AbdBGPxW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Feb 2017 10:53:22 -0500
In-Reply-To: <1486273710-18457-1-git-send-email-igor.pylypiv@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Igor Pylypiv <igor.pylypiv@gmail.com>
Date: Sat,  4 Feb 2017 21:48:30 -0800

> This reverts commit 059a2440fd3cf4ec57735db2c0a90401cde84fca.
> 
> Textsearch state parameter should be passed by pointer because
> its resulting value is needed for call to textsearch_next().
> 
> Signed-off-by: Igor Pylypiv <igor.pylypiv@gmail.com>

There are no users of this functionality.

Once you add one, you can submit this patch alongside of it.
