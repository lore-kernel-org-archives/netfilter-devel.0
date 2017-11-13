From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC]: Is there any reason libnetfilter_queue 1.0.3 is not
 released yet?
Date: Mon, 13 Nov 2017 16:27:19 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1711131625510.2460@n3.vanv.qr>
References: <20171113065406.GA7963@dimstar.local.net> <20171113152144.GA3188@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:58362 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751705AbdKMP1U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 10:27:20 -0500
In-Reply-To: <20171113152144.GA3188@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2017-11-13 16:21, Pablo Neira Ayuso wrote:

>On Mon, Nov 13, 2017 at 05:54:06PM +1100, Duncan Roe wrote:
>> The nftables Wiki page
>> https://wiki.nftables.org/wiki-nftables/index.php/Queueing_to_userspace refers
>> to using nfqnl_test with its numeric queue argument, but this only works with a
>> recent git snapshot of libnetfilter_queue.
>> 
>> Git log says 1.0.3 is ready to go since June 26, but it's not on the ftp server.
>> Can someone put it there please?
>
>Done.

There is also
http://netfilter.org/projects/libnetfilter_queue/files/

..would be good if these directories would be unified. Speaking of 
which, kernel.org abandoned their ftp, maybe time to do the same for 
netfilter.org?
