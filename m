From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] utils: nfsynproxy: fix build with musl libc
Date: Fri, 3 Mar 2017 10:55:26 +0100
Message-ID: <20170303095526.GA11571@salvia>
References: <06e0312d0bfd1f0b9e7c23ab654f18524d49e86b.1488440107.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbdCCPTx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 10:19:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B94312A686
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 10:55:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2942DA84B
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 10:55:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1E58DA84B
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 10:55:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <06e0312d0bfd1f0b9e7c23ab654f18524d49e86b.1488440107.git.baruch@tkos.co.il>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 02, 2017 at 09:35:07AM +0200, Baruch Siach wrote:
> The musl libc exposes some struct tcphdr field only when _GNU_SOURCE is
> defined. Fix the following build failure:
> 
> nfsynproxy.c: In function ‘parse_packet’:
> nfsynproxy.c:34:9: error: ‘const struct tcphdr’ has no member named ‘syn’
>   if (!th->syn || !th->ack)
>          ^
> nfsynproxy.c:34:21: error: ‘const struct tcphdr’ has no member named ‘ack’
>   if (!th->syn || !th->ack)
>                      ^
> nfsynproxy.c:42:8: error: ‘const struct tcphdr’ has no member named ‘res2’
>   if (th->res2 == 0x1)
>         ^
> nfsynproxy.c:45:13: error: ‘const struct tcphdr’ has no member named ‘doff’
>   length = th->doff * 4 - sizeof(*th);
>              ^

Applied, thanks.
