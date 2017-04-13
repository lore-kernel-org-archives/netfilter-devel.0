From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libmnl] nlmsg: introduce mnl_nlmsg_batch_rest to get the
 rest length
Date: Fri, 14 Apr 2017 00:27:00 +0200
Message-ID: <20170413222700.GA5024@salvia>
References: <20170403061127.GA2329@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49276 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752121AbdDMW1M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 18:27:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 589A2BA712
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:27:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97130DA7F7
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:27:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B14EDA7E9
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:27:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170403061127.GA2329@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 03, 2017 at 03:11:27PM +0900, Ken-ichirou MATSUZAWA wrote:
> Recent languages implements array to hold its length. This patch
> enables to help to wrap these. As of this C library, we can use
> this like below without double sized buffer.
> 
>     char buf[MNL_SOCKET_BUFFER_SIZE];
> 
>     b = mnl_nlmsg_batch_start(buf, sizeof(buf));
>     nlbuf = mnl_nlmsg_batch_current(b);
>     rest = mnl_nlmsg_batch_rest(b);
>     if (rest < NLMSG_HDRLEN)
>             return false;

Only for this usecase above?

>     nlh = mnl_nlmsg_put_header(nlbuf);

Probably we need mnl_nlmsg_put_header_check()?

>     ...
>     if (!mnl_attr_put_u8_check(nlh, rest, 1, 2))
>             return false;
>     ...
