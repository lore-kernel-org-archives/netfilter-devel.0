From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd - long living connections
Date: Wed, 1 Aug 2012 20:35:08 +0200
Message-ID: <20120801183508.GA25947@1984>
References: <CAAJpzgYSo5_sXunijxBBdWrJET1hLJ8gPw0WLZod-m4jxZHosw@mail.gmail.com>
 <20120801165402.GA19512@1984>
 <CAAJpzgZObQP=ngyFL854RxdbU3VA5BzAC-MyUwCT2Nb6=hzJCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33537 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab2HASfU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 14:35:20 -0400
Content-Disposition: inline
In-Reply-To: <CAAJpzgZObQP=ngyFL854RxdbU3VA5BzAC-MyUwCT2Nb6=hzJCg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 01, 2012 at 11:14:44AM -0700, Gomathivinayagam Muthuvinayagam wrote:
> Apologize, I did not understand your answer.

Please, don't top-post:
http://www.idallen.com/topposting.html

> The problem that I'm facing is, say if I set a polling interval of 60s
> and in some cases I may lose the data. For example,
> net.netfilter.nf_conntrack_tcp_timeout_close has a timeout value of
> 10s. In this case, if the close event happens and with polling
> interval of 60s I might miss the no of packets and size.
> 
> So I have to combine polling based + event based logging. If I
> generate both the files separately, I have to combine them like going
> through each file, and find out order of events and then I have to
> intelligently combine them. This will take considerable cpu usage in
> case of large network traffic system.
>
> My idea is through a single stack, I would like to combine polling
> based(logs update events) + event based(Create & Destroy events). In
> this scheme, from single NFCT plugin I will be registering two
> callbacks one is for getting update events using polling, and another
> one is for getting create and destroy events using event based(no
> hashtable). Is that possible?

You can hack ulodg2 to add a new mode, to periodically poll and dump
the current table content including time information. Similar to what
the NFACCT plugin does.
