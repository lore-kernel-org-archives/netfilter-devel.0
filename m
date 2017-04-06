From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nat: remove rcu_read_lock in
 __nf_nat_decode_session.
Date: Thu, 6 Apr 2017 21:51:25 +0200
Message-ID: <20170406195125.GA6515@salvia>
References: <20170327152850.19812-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36284 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751180AbdDFTvh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 15:51:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1A9A411E588
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:51:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0BC21DA7E9
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:51:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 648B6DA7E9
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:51:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170327152850.19812-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 28, 2017 at 12:28:50AM +0900, Taehee Yoo wrote:
> __nf_nat_decode_session is called from nf_nat_decode_session as decodefn.
> before calling decodefn, it already set rcu_read_lock. so rcu_read_lock in
> __nf_nat_decode_session can be removed.

Could you have close look at the tree to confirm if we have more spots
where rcu_read_lock is unnecessary?

$ git grep rcu_read_lock net/netfilter/ | wc -l
158
$ git grep rcu_read_lock
net/ipv4/netfilter/ | wc -l
3
$ git grep rcu_read_lock
net/ipv6/netfilter/ | wc -l
2
$ git grep rcu_read_lock
net/bridge/netfilter/ | wc -l

It's a fair good amount, it would take me around one hour probably to
evaluate those here.

If you can help us on verifying this, it would be simply great.

Thanks!
