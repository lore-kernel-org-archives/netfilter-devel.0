Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 171F0C001E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jul 2023 01:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjGXBgt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Jul 2023 21:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjGXBgS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Jul 2023 21:36:18 -0400
Received: from out199-10.us.a.mail.aliyun.com (out199-10.us.a.mail.aliyun.com [47.90.199.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B0059C3;
        Sun, 23 Jul 2023 18:32:45 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Vo.bCsO_1690162261;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0Vo.bCsO_1690162261)
          by smtp.aliyun-inc.com;
          Mon, 24 Jul 2023 09:31:02 +0800
Date:   Mon, 24 Jul 2023 09:31:01 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiejian Wu <jiejian@linux.alibaba.com>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v2 net-next] ipvs: make ip_vs_svc_table and
 ip_vs_svc_fwm_table per netns
Message-ID: <20230724013101.GI6751@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20230723154426.81242-1-dust.li@linux.alibaba.com>
 <ff4612e3-bb5a-7acc-1607-5761e5d052c4@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff4612e3-bb5a-7acc-1607-5761e5d052c4@ssi.bg>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 23, 2023 at 08:19:54PM +0300, Julian Anastasov wrote:
>
>	Hello,
>
>On Sun, 23 Jul 2023, Dust Li wrote:
>
>> From: Jiejian Wu <jiejian@linux.alibaba.com>
>> 
>> Current ipvs uses one global mutex "__ip_vs_mutex" to keep the global
>> "ip_vs_svc_table" and "ip_vs_svc_fwm_table" safe. But when there are
>> tens of thousands of services from different netns in the table, it
>> takes a long time to look up the table, for example, using "ipvsadm
>> -ln" from different netns simultaneously.
>> 
>> We make "ip_vs_svc_table" and "ip_vs_svc_fwm_table" per netns, and we
>> add "service_mutex" per netns to keep these two tables safe instead of
>> the global "__ip_vs_mutex" in current version. To this end, looking up
>> services from different netns simultaneously will not get stuck,
>> shortening the time consumption in large-scale deployment. It can be
>> reproduced using the simple scripts below.
>> 
>> init.sh: #!/bin/bash
>> for((i=1;i<=4;i++));do
>>         ip netns add ns$i
>>         ip netns exec ns$i ip link set dev lo up
>>         ip netns exec ns$i sh add-services.sh
>> done
>> 
>> add-services.sh: #!/bin/bash
>> for((i=0;i<30000;i++)); do
>>         ipvsadm -A  -t 10.10.10.10:$((80+$i)) -s rr
>> done
>> 
>> runtest.sh: #!/bin/bash
>> for((i=1;i<4;i++));do
>>         ip netns exec ns$i ipvsadm -ln > /dev/null &
>> done
>> ip netns exec ns4 ipvsadm -ln > /dev/null
>> 
>> Run "sh init.sh" to initiate the network environment. Then run "time
>> ./runtest.sh" to evaluate the time consumption. Our testbed is a 4-core
>> Intel Xeon ECS. The result of the original version is around 8 seconds,
>> while the result of the modified version is only 0.8 seconds.
>> 
>> Signed-off-by: Jiejian Wu <jiejian@linux.alibaba.com>
>> Co-developed-by: Dust Li <dust.li@linux.alibaba.com>
>> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
>
>	Changes look good to me, thanks! But checkpatch is reporting
>for some cosmetic changes that you have to do in v3:
>
>scripts/checkpatch.pl --strict /tmp/file.patch

Oh, sorry for that! I ignored the CHECKs checkpatch reported, my checkpatch
shows:


   $./scripts/checkpatch.pl --strict 0001-ipvs-make-ip_vs_svc_table-and-ip_vs_svc_fwm_table-pe.patch
   CHECK: Prefer using the BIT macro
   #69: FILE: include/net/ip_vs.h:40:
   +#define IP_VS_SVC_TAB_SIZE (1 << IP_VS_SVC_TAB_BITS)

We just moved this line from ip_vs_ctl.c to ip_vs.h, so we ignored the
BIT macro. Do you think we should change it using BIT macro ?


   CHECK: struct mutex definition without comment
   #79: FILE: include/net/ip_vs.h:1051:
   +       struct mutex service_mutex;

I think we can add comment for it.
But rethinking a bit on the service_mutex in ip_vs_est.c, I'm a
wondering why we are using the service_mutex in estimation ? Is est_mutex
enough for the protecting in ip_vs_est.c ?


   CHECK: Logical continuations should be on the previous line
   #161: FILE: net/netfilter/ipvs/ip_vs_ctl.c:410:
                       && (svc->port == vport)
   +                   && (svc->protocol == protocol)) {

This is just the removal of '(svc->ipvs == ipvs)' and kept it as it is.
So haven't change according to checkpatch. If you prefer, I can modify
it to make checkpatch happy.


   CHECK: Alignment should match open parenthesis
   #233: FILE: net/netfilter/ipvs/ip_vs_ctl.c:1767:
   +                       list_for_each_entry(dest, &svc->destinations,
   +                                               n_list) {

We missed this, will change.


   CHECK: Alignment should match open parenthesis
   #246: FILE: net/netfilter/ipvs/ip_vs_ctl.c:1774:
   +                       list_for_each_entry(dest, &svc->destinations,
   +                                               n_list) {

Same above.

   total: 0 errors, 0 warnings, 5 checks, 506 lines checked



>
>Regards
>
>--
>Julian Anastasov <ja@ssi.bg>
