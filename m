From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: nf_queue: remove duplicated include
 from nf_queue.c
Date: Wed, 10 Jan 2018 15:17:14 +0100
Message-ID: <20180110141714.yjqn7czhza64sdgy@salvia>
References: <1515589606-71967-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59430 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754655AbeAJORS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 09:17:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6EEE11EC2C5
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:17:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6018BDA84E
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:17:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1515589606-71967-1-git-send-email-weiyongjun1@huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 10, 2018 at 01:06:46PM +0000, Wei Yongjun wrote:
> Remove duplicated include.

Applied.
