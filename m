From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] bridge: drop netfilter fake rtable unconditionally
Date: Mon, 13 Mar 2017 13:02:08 -0700 (PDT)
Message-ID: <20170313.130208.357290085069827195.davem@davemloft.net>
References: <20170313163817.24447-1-fw@strlen.de>
        <20170313165124.GA32021@salvia>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:55412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753203AbdCMUCP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 16:02:15 -0400
In-Reply-To: <20170313165124.GA32021@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 13 Mar 2017 17:51:24 +0100

> I also love this bridge netfilter Frankenstein a lot. Looking forward
> you kill this via native bridge conntrack support for nf_tables.

Indeed, Florian, you will be my hero if you can remove fake_rtable
:-)
