From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_set_rbtree: use per-set rwlock to
 improve the scalability
Date: Mon, 13 Mar 2017 19:32:33 +0100
Message-ID: <20170313183233.GB565@salvia>
References: <1489318727-38911-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>,
        Karel Rericha <karel@unitednetworks.cz>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50108 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753414AbdCMScj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 14:32:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 499681B8427
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 19:32:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 390D0DA852
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 19:32:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB976DA854
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 19:32:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489318727-38911-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 12, 2017 at 07:38:47PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Karel Rericha reported that in his test case, ICMP packets going through
> boxes had normally about 5ms latency. But when running nft, actually
> listing the sets with interval flags, latency would go up to 30-100ms.
> This was observed when router throughput is from 600Mbps to 2Gbps.
> 
> This is because we use a single global spinlock to protect the whole
> rbtree sets, so "dumping sets" will race with the "key lookup" inevitably.
> But actually they are all _readers_, so it's ok to convert the spinlock
> to rwlock to avoid competition between them. Also use per-set rwlock since
> each set is independent.

Also applied, thanks for testing Karel.
