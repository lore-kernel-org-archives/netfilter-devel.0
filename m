From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v3] datatype: Display pre-defined inet_service values
 in host byte order
Date: Sat, 10 Dec 2016 14:16:40 +0100
Message-ID: <20161210131640.GA30182@salvia>
References: <20161210003513.GA30388@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46400 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752323AbcLJNQx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Dec 2016 08:16:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 86BEB8CD7D
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Dec 2016 14:16:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7736FC21BF
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Dec 2016 14:16:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F32CC21C8
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Dec 2016 14:16:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161210003513.GA30388@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 09, 2016 at 10:35:13PM -0200, Elise Lennion wrote:
> nft describe displays, to the user, which values are available for a selector,
> then the values should be in host byte order.
> 
> Variable size was replaced by len to better match the common pattern.

Applied, thanks Elise.

BTW, I have moved switch_byteorder() to datatype.c, I remember I
suggested you to place it under gmputil.c but given this doesn't take
any mpz_t parameter, let's keep it where we use it and remember this
is there.

Anyway, another issue that would be good to revisit:

# nft describe tcp dport
payload expression, datatype inet_service (internet network service)
(basetype integer), 16 bits

pre-defined symbolic constants:
        tcpmux                          0x0001
        echo                            0x0007
        discard                         0x0009
        ...

The convention is to represent ports in base 10, not as hex. So if you
can follow up with a patch to solve this I'd appreciate it.

Probably this is a new field we can place in struct symbol_table.

Thanks.
