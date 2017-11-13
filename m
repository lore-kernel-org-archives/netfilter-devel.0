From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [RFC]: Is there any reason libnetfilter_queue 1.0.3 is not released
 yet?
Date: Mon, 13 Nov 2017 17:54:06 +1100
Message-ID: <20171113065406.GA7963@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:57083 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751583AbdKMGyV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 01:54:21 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with SMTP id 4A00A3C27D2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 17:54:07 +1100 (AEDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nftables Wiki page
https://wiki.nftables.org/wiki-nftables/index.php/Queueing_to_userspace refers
to using nfqnl_test with its numeric queue argument, but this only works with a
recent git snapshot of libnetfilter_queue.

Git log says 1.0.3 is ready to go since June 26, but it's not on the ftp server.
Can someone put it there please?

Cheers ... Duncan.
