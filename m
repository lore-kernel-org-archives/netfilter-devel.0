From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_connlimit: use rb_entry()
Date: Thu, 5 Jan 2017 13:26:44 +0100
Message-ID: <20170105122644.GA6279@salvia>
References: <ddabc96c798df194791134d8e070d728e2a7b59f.1482203698.git.geliangtang@gmail.com>
 <5fab578543b7f15cb416438800e24e70af675835.1482204114.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50828 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762730AbdAEM0x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 07:26:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 506F86DFE5
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:26:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3ED718E7B8
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:26:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 035D59D6A0
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:26:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <5fab578543b7f15cb416438800e24e70af675835.1482204114.git.geliangtang@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 20, 2016 at 10:02:13PM +0800, Geliang Tang wrote:
> To make the code clearer, use rb_entry() instead of container_of() to
> deal with rbtree.

Applied this one to nf-next, thanks.
