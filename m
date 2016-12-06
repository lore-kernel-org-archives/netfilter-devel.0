From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] NAT: skip checksum on offload SCTP packets
Date: Tue, 6 Dec 2016 11:44:51 +0100
Message-ID: <20161206104451.GA5422@salvia>
References: <d2c914edb023e502a839f8ff7037028311007cfe.1480948288.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51086 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751471AbcLFKwn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 05:52:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1008FD1625
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:45:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03432DA85F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:45:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F134ADA86E
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:45:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <d2c914edb023e502a839f8ff7037028311007cfe.1480948288.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 05, 2016 at 03:33:57PM +0100, Davide Caratti wrote:
> SCTP GSO and hardware can do CRC32c computation after netfilter processing,
> so we can avoid calling sctp_compute_checksum() on skb if skb->ip_summed
> is equal to CHECKSUM_PARTIAL. Moreover, set skb->ip_summed to CHECKSUM_NONE
> when the NAT code computes the CRC, to prevent offloaders from computing
> it again (on ixgbe this resulted in a transmission with wrong L4 checksum).

Applied, thanks Davide.
