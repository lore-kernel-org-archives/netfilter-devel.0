Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1595FC35DF5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 07:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD5F9218AC
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 07:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgBYHFl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 02:05:41 -0500
Received: from relay.sw.ru ([185.231.240.75]:40198 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgBYHFl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 02:05:41 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1j6UHb-0004rN-9A; Tue, 25 Feb 2020 10:05:31 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 0/4] netfilter: seq_file .next functions should increase
 position index
To:     coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <497a82c1-7b6a-adf4-a4ce-df46fe436aae@virtuozzo.com>
Message-ID: <5328139a-1c65-74a5-c748-1aabc18ef26c@virtuozzo.com>
Date:   Tue, 25 Feb 2020 10:05:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <497a82c1-7b6a-adf4-a4ce-df46fe436aae@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

v2: resend with improved patch description

In Aug 2018 NeilBrown noticed 
commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
"Some ->next functions do not increment *pos when they return NULL...
Note that such ->next functions are buggy and should be fixed. 
A simple demonstration is
   
dd if=/proc/swaps bs=1000 skip=1
    
Choose any block size larger than the size of /proc/swaps.  This will
always show the whole last line of /proc/swaps"

/proc/swaps output was fixed recently, however there are lot of other
affected files, and few of them of them are related to netfilter subsystem.

For example please take look at recent_seq_next()

 # dd if=/proc/net/xt_recent/SSH # original file output
 src=127.0.0.4 ttl: 0 last_seen: 6275444819 oldest_pkt: 1 6275444819
 src=127.0.0.2 ttl: 0 last_seen: 6275438906 oldest_pkt: 1 6275438906
 src=127.0.0.3 ttl: 0 last_seen: 6275441953 oldest_pkt: 1 6275441953
 0+1 records in
 0+1 records out
 204 bytes copied, 6.1332e-05 s, 3.3 MB/s

Read after lseek into middle of last line (offset 140 in example below)
generates expected end of last line and then unexpected whole last line
once again

 # dd if=/proc/net/xt_recent/SSH bs=140 skip=1
 dd: /proc/net/xt_recent/SSH: cannot skip to specified offset
 127.0.0.3 ttl: 0 last_seen: 6275441953 oldest_pkt: 1 6275441953
 src=127.0.0.3 ttl: 0 last_seen: 6275441953 oldest_pkt: 1 6275441953
 0+1 records in
 0+1 records out
 132 bytes copied, 6.2487e-05 s, 2.1 MB/s

In general if .next function does not change position index,
following .show function will repeat output related
to current position index. I.e. position index should be updated 
even if .next function returns NULL.

https://bugzilla.kernel.org/show_bug.cgi?id=206283

Vasily Averin (4):
  ct_cpu_seq_next should increase position index
  synproxy_cpu_seq_next should increase position index
  recent_seq_next should increase position index
  xt_mttg_seq_next should increase position index

 net/netfilter/nf_conntrack_standalone.c | 2 +-
 net/netfilter/nf_synproxy_core.c        | 2 +-
 net/netfilter/x_tables.c                | 6 +++---
 net/netfilter/xt_recent.c               | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
1.8.3.1
