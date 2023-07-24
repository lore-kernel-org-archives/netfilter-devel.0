Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0A9C001E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jul 2023 10:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjGXKY3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jul 2023 06:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbjGXKYT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2023 06:24:19 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770F4526F
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2023 03:18:51 -0700 (PDT)
Received: from mg.bb.i.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id E63D52322B
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2023 13:18:49 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id CE9EC23227
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2023 13:18:49 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
        by ink.ssi.bg (Postfix) with ESMTPSA id 0683E3C07C8;
        Mon, 24 Jul 2023 13:18:42 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ssi.bg; s=ink;
        t=1690193923; bh=SCZRWOzob6VC4Fc+IynUeDO44QbYqOB9xWyQgHRmE+I=;
        h=Date:From:To:cc:Subject:In-Reply-To:References;
        b=uwX3347G3JprqfWir/U5Crg1yILWVwb6y5At63Rrxk+aPRWoZh9yD8vhRyJM29fsM
         NJbo8iZ6XQBPzYWSjE346G+TsuMEwpwUvGh5+zBsCOpDXFV1zkYdpxZuMNsKfgiXbi
         U+ZC1TYD17XKBhEGxSzgh2DhtQKQTNzx5Qg0rXyo=
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.17.1) with ESMTP id 36OAIcAO063160;
        Mon, 24 Jul 2023 13:18:40 +0300
Date:   Mon, 24 Jul 2023 13:18:38 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Dust Li <dust.li@linux.alibaba.com>
cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jiejian Wu <jiejian@linux.alibaba.com>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v3 net-next] ipvs: make ip_vs_svc_table and ip_vs_svc_fwm_table
 per netns
In-Reply-To: <20230724074028.17964-1-dust.li@linux.alibaba.com>
Message-ID: <b1c9352e-b1be-09dd-6bd4-d107f1181241@ssi.bg>
References: <20230724074028.17964-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Mon, 24 Jul 2023, Dust Li wrote:

> From: Jiejian Wu <jiejian@linux.alibaba.com>
> 
> Current ipvs uses one global mutex "__ip_vs_mutex" to keep the global
> "ip_vs_svc_table" and "ip_vs_svc_fwm_table" safe. But when there are
> tens of thousands of services from different netns in the table, it
> takes a long time to look up the table, for example, using "ipvsadm
> -ln" from different netns simultaneously.
> 
> We make "ip_vs_svc_table" and "ip_vs_svc_fwm_table" per netns, and we
> add "service_mutex" per netns to keep these two tables safe instead of
> the global "__ip_vs_mutex" in current version. To this end, looking up
> services from different netns simultaneously will not get stuck,
> shortening the time consumption in large-scale deployment. It can be
> reproduced using the simple scripts below.
> 
> init.sh: #!/bin/bash
> for((i=1;i<=4;i++));do
>         ip netns add ns$i
>         ip netns exec ns$i ip link set dev lo up
>         ip netns exec ns$i sh add-services.sh
> done
> 
> add-services.sh: #!/bin/bash
> for((i=0;i<30000;i++)); do
>         ipvsadm -A  -t 10.10.10.10:$((80+$i)) -s rr
> done
> 
> runtest.sh: #!/bin/bash
> for((i=1;i<4;i++));do
>         ip netns exec ns$i ipvsadm -ln > /dev/null &
> done
> ip netns exec ns4 ipvsadm -ln > /dev/null
> 
> Run "sh init.sh" to initiate the network environment. Then run "time
> ./runtest.sh" to evaluate the time consumption. Our testbed is a 4-core
> Intel Xeon ECS. The result of the original version is around 8 seconds,
> while the result of the modified version is only 0.8 seconds.
> 
> Signed-off-by: Jiejian Wu <jiejian@linux.alibaba.com>
> Co-developed-by: Dust Li <dust.li@linux.alibaba.com>
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>

	Looks good to me, thanks! I'm taking this patch and
will repost it together with other related patches.

> ---
> v3:
>   * fix complains of checkpatch
> v2:
>   * remove global __ip_vs_mutex in ip_vs_est.c
>   * remove ip_vs_ prefix for svc_table and svc_fwm_table
>   * remove redundant "svc->ipvs == ipvs" checks
> ---

Regards

--
Julian Anastasov <ja@ssi.bg>

