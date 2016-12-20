From: Llorente Santos Jesus <jesus.llorente.santos@aalto.fi>
Subject: How to leverage  IP & UDP checksum offloading from iptables kernel
 module?
Date: Tue, 20 Dec 2016 11:25:06 +0000
Message-ID: <f9f1b6c9622444c7bc492425f408ea3f@aalto.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out-01.aalto.fi ([130.233.228.120]:54242 "EHLO
        smtp-out-01.aalto.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756355AbcLTLZJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2016 06:25:09 -0500
Received: from smtp-out-01.aalto.fi (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 214B711543B_8591513B
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 11:25:07 +0000 (GMT)
Received: from exng1.org.aalto.fi (exng1.org.aalto.fi [130.233.223.20])
        by smtp-out-01.aalto.fi (Sophos Email Appliance) with ESMTP id E50DF115429_8591512F
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 11:25:06 +0000 (GMT)
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I was trying to build an iptables extension that mangles IPv4 / UDP packets. I want to create a stateless NAT mechanism to mangle either source or destination similar to RAWDNAT/RAWSNAT targets of xtables-addons (http://manpages.ubuntu.com/manpages/precise/man8/xtables-addons.8.html)

However, I wanted to offload the checksum calculation to the NIC, if the feature is supported. I have been looking into the kernel files, skb, ip_forward modules and so on, but I couldn't get a clear picture on how to leverage the offloading to save some CPU cycles and compare both approaches, with and without the offloading.

Any help would be highly appreciated! Thanks!

Best,
Jesus


