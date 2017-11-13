From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC]: Is there any reason libnetfilter_queue 1.0.3 is not
 released yet?
Date: Mon, 13 Nov 2017 16:21:44 +0100
Message-ID: <20171113152144.GA3188@salvia>
References: <20171113065406.GA7963@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33668 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752628AbdKMPVu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 10:21:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C17441C4367
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 16:21:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2B80DA843
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 16:21:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F88FDA78E
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 16:21:45 +0100 (CET)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CD2C5403DF98
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 16:21:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171113065406.GA7963@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 13, 2017 at 05:54:06PM +1100, Duncan Roe wrote:
> The nftables Wiki page
> https://wiki.nftables.org/wiki-nftables/index.php/Queueing_to_userspace refers
> to using nfqnl_test with its numeric queue argument, but this only works with a
> recent git snapshot of libnetfilter_queue.
> 
> Git log says 1.0.3 is ready to go since June 26, but it's not on the ftp server.
> Can someone put it there please?

Done.
