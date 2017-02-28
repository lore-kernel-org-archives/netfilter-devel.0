From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnfct 0/2] fix - src: add support for IPv6 NAT
Date: Tue, 28 Feb 2017 13:53:59 +0900
Message-ID: <20170228045359.GA21582@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34734 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdB1F3Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 00:29:25 -0500
Received: by mail-pf0-f174.google.com with SMTP id p185so997557pfb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 21:27:39 -0800 (PST)
Received: from gmail.com (softbank218138040024.bbtec.net. [218.138.40.24])
        by smtp.gmail.com with ESMTPSA id f62sm852340pfg.48.2017.02.27.20.54.06
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Feb 2017 20:54:07 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi,

This patch series fixes commit:

    73ad642ba462d0992e1903012eee4ebfec89ed69
    f5e51ad64d9e5597e8880b652abe261585c2563d

Conditions in getobjopt_is_snat() / getobjopt_is_dnat() has
been changed in the commit above and fixed by this, but I do
not understand proper way to check a nfct content is correct.
Please review it.

Thanks,
