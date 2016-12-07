From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2] netfilter: xt_bpf: support ebpf
Date: Wed, 7 Dec 2016 14:20:21 +0100
Message-ID: <20161207132021.GA4417@salvia>
References: <1481059502-47824-1-git-send-email-willemdebruijn.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        daniel@iogearbox.net, Willem de Bruijn <willemb@google.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932388AbcLGNUa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2016 08:20:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 96412174D02
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 14:20:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D5C7DA873
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 14:20:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E388DA843
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 14:20:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1481059502-47824-1-git-send-email-willemdebruijn.kernel@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 06, 2016 at 04:25:02PM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Add support for attaching an eBPF object by file descriptor.
> 
> The iptables binary can be called with a path to an elf object or a
> pinned bpf object. Also pass the mode and path to the kernel to be
> able to return it later for iptables dump and save.

Applied, thanks Willem.
