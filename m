From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: nf_flow_table: remove duplicated
 include from nf_flow_table_ipv6.c
Date: Wed, 10 Jan 2018 15:18:06 +0100
Message-ID: <20180110141806.ne5yk4cvjayczm5t@salvia>
References: <1515589626-72041-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753587AbeAJOSL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 09:18:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C654D1EC2C5
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:18:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B74CCDA85D
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:18:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1515589626-72041-1-git-send-email-weiyongjun1@huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 10, 2018 at 01:07:06PM +0000, Wei Yongjun wrote:
> Remove duplicated include.

I'm going to collapse this patch to:

http://patchwork.ozlabs.org/patch/858284/

and call it "netfilter: remove duplicated include"

So we don't need two patches for the same thing.

OK?
