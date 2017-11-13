From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC]: Is there any reason libnetfilter_queue 1.0.3 is not
 released yet?
Date: Mon, 13 Nov 2017 17:31:21 +0100
Message-ID: <20171113163121.GA13766@salvia>
References: <20171113065406.GA7963@dimstar.local.net>
 <20171113152144.GA3188@salvia>
 <nycvar.YFH.7.76.1711131625510.2460@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35456 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753033AbdKMQb1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 11:31:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5AF2E39626A
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 17:31:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49B89DA877
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 17:31:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1711131625510.2460@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 13, 2017 at 04:27:19PM +0100, Jan Engelhardt wrote:
> On Monday 2017-11-13 16:21, Pablo Neira Ayuso wrote:
> 
> >On Mon, Nov 13, 2017 at 05:54:06PM +1100, Duncan Roe wrote:
> >> The nftables Wiki page
> >> https://wiki.nftables.org/wiki-nftables/index.php/Queueing_to_userspace refers
> >> to using nfqnl_test with its numeric queue argument, but this only works with a
> >> recent git snapshot of libnetfilter_queue.
> >> 
> >> Git log says 1.0.3 is ready to go since June 26, but it's not on the ftp server.
> >> Can someone put it there please?
> >
> >Done.
> 
> There is also
> http://netfilter.org/projects/libnetfilter_queue/files/

Done.

> ..would be good if these directories would be unified. Speaking of 
> which, kernel.org abandoned their ftp, maybe time to do the same for 
> netfilter.org?

I'm ambivalent about this.
