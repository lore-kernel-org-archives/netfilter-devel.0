From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [Netdev ANNOUNCE]: New talk accepted debug pipe
Date: Fri, 24 Mar 2017 11:56:30 -0400
Message-ID: <0edc0f79-c960-5f26-efea-4a26455f5747@mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>,
        netfilter@vger.kernel.org, linux-wireless@vger.kernel.org,
        Heri Muhero <hmuhero@gmail.com>
To: people@netdevconf.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:38120 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936529AbdCXP4d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 11:56:33 -0400
Received: by mail-it0-f41.google.com with SMTP id y18so4845254itc.1
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 08:56:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The tech committee would like to announce a new accepted talk.

Arkadi Sharshevski will give a talk on the new dpipe tool.

Details are as follows:
-----
While doing the hardware offloading process much of the hardware
specifics cannot be presented. One example for such is the routing LPM
algorithm used in Mellanox Spectrum ASIC which differs in hardware
implementation from the kernel software implementation. The only
information the user receives is whether specific route is offloaded or
not, but he cannot really understand the underlying implementation nor
get the specific statistics related to that process.

Another example is TC classification-action offload which in hardware
commonly implemented using TCAM memory. Currently there is no
capability to gain visibility into the TCAM structure and to debug
sub-optimal resource allocation.

The new dpipe interface introduces capability for exporting the ASICs
pipeline abstraction via devlink infrastructure, which should serve as
an complementary tool. This infrastructure allows the user to get
visibility into the ASIC by modeling it as a set of match/action tables.

-----

cheers,
jamal
