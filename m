From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_queue: get rid of dependency on
 IP6_NF_IPTABLES
Date: Mon, 12 Sep 2016 19:50:30 +0200
Message-ID: <20160912175030.GA31089@salvia>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbcILRuf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 13:50:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A782412A688
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:50:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96BDF1153EF
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:50:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F197C114D6B
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:50:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 11, 2016 at 10:05:27PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> hash_v6 is used by both nftables and ip6tables, so depend on
> IP6_NF_IPTABLES is not properly.
> 
> Actually, it only parses ipv6hdr and computes a hash value, so
> even if IPV6 is disabled, there's no side effect too, remove it.

Applied, thanks.

We have nft_queue support for bridge now, but nfqueue_hash() takes a
pkt->pf parameter expecting NFPROTO_IPV4 or NFPROTO_IPV6.

So nft_queue hashing with bridge is currently broken.
