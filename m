From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: ANNOUNCE: Netdev 2.1 update Mar 03
Date: Fri, 3 Mar 2017 17:34:22 -0500
Message-ID: <4112ce7e-f793-9982-64c4-d9c3aeb3835e@mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        linux-wireless@vger.kernel.org, tech-committee@netdevconf.org,
        David Miller <davem@davemloft.net>,
        Stephen Jaworski <jaws@mojatatu.com>, people@netdevconf.org,
        Brenda Butler <bjb@mojatatu.com>
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35379 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbdCCWky (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 17:40:54 -0500
Received: by mail-it0-f65.google.com with SMTP id 203so3844780ith.2
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Mar 2017 14:40:51 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



The tech committee has accepted a new workshop on
Network Performance chaired by Alexander Duyck

Some details:
----------
The network performance performance workshop is a follow-up of several 
mailing list threads on the netdev mailing list as well as presentations 
at Netdev 1.2. We want to discuss the progress made on various efforts 
to enable better performance through enabling new features in the 
kernel, and changing existing APIs to better enable the drivers to 
handle the ever increasing workloads.

This is an opportunity to bring together the various network device 
vendors to discuss what has worked and what hasn't in terms of enabling 
better performance in the Linux kernel ecosystem.

Topics for the session would include:

Implementing page based receive paths and page recycling and/or reuse
Zero-copy using AF_PACKET to accelerate user-space networking
Recent changes to enable better use of build_skb and XDP
Batching of Tx and Rx workloads
Kernel memory optimizations
-----

Alex will be posting a lot more details and agenda items by
the conference time.

cheers,
jamal
