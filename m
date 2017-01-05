From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/2] nf_conntrack: validate crc32c on SCTP
 packets hitting PREROUTING hook
Date: Thu, 5 Jan 2017 13:25:13 +0100
Message-ID: <20170105122513.GA6237@salvia>
References: <cover.1483355460.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50286 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752655AbdAEMZT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 07:25:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BDD386DFDC
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:25:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B00232E4F5
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:25:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D958201F2
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:25:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <cover.1483355460.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 02, 2017 at 01:29:39PM +0100, Davide Caratti wrote:
> unlike what happens with other protcols, conntrack entries are matched by
> SCTP packets even when crc32c is incorrect. Moreover, netfilter 'REJECT'
> target does not generate any ICMP on reception of SCTP packets, because it
> computes RFC 1624 checksum ad compares it with crc32c in the transport
> header, resulting in a systematic mismatch.
> 
> The above issues can be resolved by implementing .error() callback in SCTP
> conntrack helper. Patch 1 of this series lets LIBCRC32C be selected with
> NF_CT_PROTO_SCTP, to allow crc32c validation within nf_conntrack. Patch 2
> implements .error() callback in nf_conntrack_l4proto_sctp{4,6}: like other
> protocols do with the Internet Checksum, sctp_error() validates crc32c in
> PREROUTING hook, updates the value of skb->ip_summed and returns the result
> of checksum validation to let conntrack core skip corrupted packets.

Series applied, thanks Davide.
