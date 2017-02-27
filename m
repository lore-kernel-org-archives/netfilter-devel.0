From: Tarun Khanna <tkhanna@akamai.com>
Subject: per flow stats collection using libnetfilter_conntrack
Date: Mon, 27 Feb 2017 15:49:06 -0500
Message-ID: <3bbe482c-863f-2b29-e3fd-522b0079ddbb@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:19252 "EHLO
        prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751787AbdB0VfC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 16:35:02 -0500
Received: from prod-mail-xrelay08.akamai.com (localhost.localdomain [127.0.0.1])
        by postfix.imss70 (Postfix) with ESMTP id 2DD57200039
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 20:49:26 +0000 (GMT)
Received: from prod-mail-relay08.akamai.com (prod-mail-relay08.akamai.com [172.27.22.71])
        by prod-mail-xrelay08.akamai.com (Postfix) with ESMTP id 175A0200014
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 20:49:26 +0000 (GMT)
Received: from email.msg.corp.akamai.com (usma1ex-cas3.msg.corp.akamai.com [172.27.123.32])
        by prod-mail-relay08.akamai.com (Postfix) with ESMTP id F04909809A
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 20:49:25 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is it possible to register for callbacks so that a user application is 
updated on a regular basis when the packet or bytes counts change for 
flows? I can poll the stats using something similar to "conntrack -L". 
However, I was wondering if it's possible to be notified regularly on 
updates.
