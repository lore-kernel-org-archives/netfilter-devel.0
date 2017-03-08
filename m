From: Tarun Khanna <tkhanna@akamai.com>
Subject: Question about getting counters for transparent terminated flows
Date: Wed, 8 Mar 2017 12:37:00 -0500
Message-ID: <a2f3e82d-0155-4600-5ec9-f3b2a19265cb@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:60038 "EHLO
        prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753970AbdCHRkH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 12:40:07 -0500
Received: from prod-mail-xrelay06.akamai.com (localhost.localdomain [127.0.0.1])
        by postfix.imss70 (Postfix) with ESMTP id B399C16C9D5
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:37:01 +0000 (GMT)
Received: from prod-mail-relay09.akamai.com (prod-mail-relay09.akamai.com [172.27.22.68])
        by prod-mail-xrelay06.akamai.com (Postfix) with ESMTP id 9E06916C7C6
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:37:01 +0000 (GMT)
Received: from email.msg.corp.akamai.com (ecp.msg.corp.akamai.com [172.27.123.33])
        by prod-mail-relay09.akamai.com (Postfix) with ESMTP id 7F61E1E07C
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:37:01 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have an application that acts as a transparent proxy for tcp flows. I 
need to get packet and byte counters for these tcp flows on both sides 
of the proxy application. I looked at pulling the counters from the 
kernel using libnetfilter_conntrack. However I noticed that the 
conntrack library only shows one entry for flows that are terminated 
transparently. This is an issue, as I am not able to see byte and packet 
counters for the two sides of the flow separately. Is there a way to get 
the separate counters for flows that are transparently terminated?

If the flow is terminated but not transparently, I do get two separate 
entries from libnetfilter_conntrack, and the counters are as I would 
expect them to be.

Thank you.

Tarun
