From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5 0/5] netfilter: exit_net checks for objects
 initialized in net_init hook
Date: Mon, 13 Nov 2017 13:55:08 +0100
Message-ID: <20171113125508.GA12197@salvia>
References: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
 <2f512ef8-8bb8-c227-1cde-1be56ae4c3ec@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
To: Vasily Averin <vvs@virtuozzo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752576AbdKMMzO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 07:55:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 21EFF392E04
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:55:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C957BAAC1
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:55:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <2f512ef8-8bb8-c227-1cde-1be56ae4c3ec@virtuozzo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Vasily,

On Sun, Nov 12, 2017 at 02:32:14PM +0300, Vasily Averin wrote:
> OpenVz kernel team have a long history of fighting against namespace-related bugs,
> some of them could be excluded by using simple checks described below.

I'm folding this series into one single patch, description looks like
this:

    netfilter: exit_net cleanup check added

    Be sure that lists initialized in net_init hook was return to initial
    state.

I understand your goal is to make it easier for review, but given this
is all part of the same logic change, I just hope you don't mind I
have squashed them into one single patch like I did.

Thanks.
