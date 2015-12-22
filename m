From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_NFQUEUE: Add translation to nft
Date: Tue, 22 Dec 2015 21:21:12 +0100
Message-ID: <20151222202112.GA4470@salvia>
References: <20151221132342.GA2582@gmail.com>
 <20151222164020.GA17410@salvia>
 <CAKHNQQE0=tQQcaWCvAgyQGA3yiM3mfZcoLcrfb-Kn8DKaY=+6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37891 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbbLVU2N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 15:28:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A9F5024A0E6
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 21:28:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 99D7CDA80B
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 21:28:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5F6C9DA811
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 21:28:10 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQE0=tQQcaWCvAgyQGA3yiM3mfZcoLcrfb-Kn8DKaY=+6w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 01:08:51AM +0530, Shivani Bhardwaj wrote:
> On Tue, Dec 22, 2015 at 10:10 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Dec 21, 2015 at 06:53:43PM +0530, Shivani Bhardwaj wrote:
> >> Add translation of NF queue to nftables.
> >>
> >> Examples:
> >>
> >> $ sudo iptables-translate -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE --queue-num 30
> >> nft add rule ip nat PREROUTING tcp dport 80 counter  queue num 30
> >>
> >> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-num 0 --queue-bypass -p TCP --sport 80
> >> nft add rule ip filter FORWARD tcp sport 80 counter  queue num 0 bypass
> >                                                      ^
> > Make sure this space is gone in a v2 of this patch.
> >
> >> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-balance 0:3
> >> nft add rule ip filter FORWARD counter  queue num 0-3 fanout
> >
> > I think --queue-balance is independent from fanout. Check the code and
> > make sure this is correct.
> >
> Hi,
> 
> I have taken reference from here :
> http://wiki.nftables.org/wiki-nftables/index.php/Queueing_to_userspace
> 
> It says:
> When doing load balancing, you can use the fanout option to use the
> CPU ID as an index to map packets to the queues. The idea is that you
> can improve performance if there's a queue/userspace application per
> CPU
> 
> Please let me know if I have understood this wrong.

I think this description above is not precise, please have a look at:
man iptables-extensions and check NFQUEUE, so you make sure you're
interpreting things the right way.

       --queue-balance value:value
              This specifies a range of queues to use. Packets are
              then balanced across the given queues.  This is useful for
              multicore systems:  start  multiple  instances  of  the
              userspace program on queues x, x+1, .. x+n and use
              "--queue-balance x:x+n". Packets belonging to the same
              connection are put into the same nfqueue.

       --queue-cpu-fanout
              Available starting Linux kernel 3.10. When used together
              with --queue-balance this will use the CPU ID as an index
              to map packets to the queues. The idea is that you can improve
              performance if there's a queue per CPU. This requires
              --queue-balance to be specified.

So fanout is optional.

You can also fix the wiki to avoid this ambiguity. Thanks.
