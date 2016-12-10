From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_bpf: support ebpf pinned objects
Date: Sat, 10 Dec 2016 14:06:58 +0100
Message-ID: <20161210130658.GA29356@salvia>
References: <1481234978-40351-1-git-send-email-willemdebruijn.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44756 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753177AbcLJNHO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Dec 2016 08:07:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AA03D7FC46
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Dec 2016 14:07:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C508DA7F6
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Dec 2016 14:07:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91A83DA729
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Dec 2016 14:07:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1481234978-40351-1-git-send-email-willemdebruijn.kernel@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 08, 2016 at 05:09:38PM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Exercise the new kernel feature introduced in commit 2c16d6033264
> ("netfilter: xt_bpf: support ebpf") to load pinned eBPF programs.
> 
> The new interface allows instantiating a bpf match using
> 
>   -m bpf --object-pinned ${PATH}
> 
> where ${PATH} points to a node in a bpf virtual filesystem. See
> also the revised man page.

Applied, thanks Willem.
