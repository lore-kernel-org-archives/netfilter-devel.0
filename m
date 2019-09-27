Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB505C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 05:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A43B320863
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 05:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfI0FEy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 01:04:54 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:2637 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfI0FEx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 01:04:53 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app12-12012 (RichMail) with SMTP id 2eec5d8d962fe12-3aa7a; Fri, 27 Sep 2019 12:55:13 +0800 (CST)
X-RM-TRANSID: 2eec5d8d962fe12-3aa7a
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee25d8d963016f-a2662;
        Fri, 27 Sep 2019 12:55:13 +0800 (CST)
X-RM-TRANSID: 2ee25d8d963016f-a2662
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH v2 0/2] ipvs: speedup ipvs netns dismantle
Date:   Fri, 27 Sep 2019 12:54:49 +0800
Message-Id: <1569560091-20553-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Implement exit_batch() method to dismantle more ipvs netns
per round.

Tested:
$  cat add_del_unshare.sh
#!/bin/bash

for i in `seq 1 100`
    do
     (for j in `seq 1 40` ; do  unshare -n ipvsadm -A -t 172.16.$i.$j:80 >/dev/null ; done) &
    done
wait; grep net_namespace /proc/slabinfo

Befor patch:
$  time sh add_del_unshare.sh
net_namespace       4020   4020   4736    6    8 : tunables    0    0    0 : slabdata    670    670      0

real    0m8.086s
user    0m2.025s
sys     0m36.956s

After patch:
$  time sh add_del_unshare.sh
net_namespace       4020   4020   4736    6    8 : tunables    0    0    0 : slabdata    670    670      0

real    0m7.623s
user    0m2.003s
sys     0m32.935s

Haishuang Yan (2):
  ipvs: batch __ip_vs_cleanup
  ipvs: batch __ip_vs_dev_cleanup

 include/net/ip_vs.h             |  2 +-
 net/netfilter/ipvs/ip_vs_core.c | 47 ++++++++++++++++++++++++-----------------
 net/netfilter/ipvs/ip_vs_ctl.c  | 12 ++++++++---
 3 files changed, 38 insertions(+), 23 deletions(-)

-- 
1.8.3.1



