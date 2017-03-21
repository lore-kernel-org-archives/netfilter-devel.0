From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/5] netfilter: nfnl_cthelper: don't report error if
 NFCTH_PRIV_DATA_LEN is empty
Date: Tue, 21 Mar 2017 11:18:28 +0100
Message-ID: <20170321101828.GA1940@salvia>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51978 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754338AbdCUKSd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 06:18:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5B52CEAA62
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:18:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E1B9DA729
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:18:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4223DA87D
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:18:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489934162-7415-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 19, 2017 at 10:35:58PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Currently, when we create cthelper via nfnetlink, -EINVAL will be
> returned if the NFCTH_PRIV_DATA_LEN attribute is empty.
> 
> But enforcing the user to specify the NFCTH_PRIV_DATA_LEN attr seems
> unnecessary, so it's better to set the helper->data_len to zero if
> the NFCTH_PRIV_DATA_LEN attribute is empty.
> 
> Found by running example program from libnetfilter_cthelper:
>   # ./libnetfilter_cthelper/examples/nfct-helper-add test 1
>   error: Invalid argument

I suggest you fix this userspace example instead, we should always
send NFCTH_PRIV_DATA_LEN. This is integral part of the helper
description.

NFCTH_ATTR_PRIV_DATA_LEN has been always set from the conntrack-tools,
so most likely this example just got outdated at some point of the
development and nobody noticed so far.

Thanks.
