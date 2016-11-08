From: Florian Westphal <fw@strlen.de>
Subject: Re: "random" syn packets dropped
Date: Tue, 8 Nov 2016 15:08:57 +0100
Message-ID: <20161108140857.GE24908@breakpoint.cc>
References: <CAJO99TnMCZdROCNV9-3xcURbGZVw7X-wKwf-vkUc5Lc3R_QT9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-15?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42486 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752497AbcKHOK6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 09:10:58 -0500
Content-Disposition: inline
In-Reply-To: <CAJO99TnMCZdROCNV9-3xcURbGZVw7X-wKwf-vkUc5Lc3R_QT9A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bjørnar Ness <bjornar.ness@gmail.com> wrote:
> I am not sure if this is nftables related, but I post this issue here,
> and see if any of you can come up with a clue to what might be
> going on here.
> 
> Problem description:
> 
> When I create multiple tcp connections from the same client to
> multiple dst hosts at the same time, the n'th syn packet is just
> discarded by "something" in the kernel.
> 
> If I reorder the list of dst hosts, a different dst host will hang in SYN_SENT
> on the client. This setup has been running for about a month, and we have
> no changed that can explain this behavior.
> 
> What I am seeing on the firewall running kernel 4.8.1 is the following:
> 
> * the syn packet enters through the eth1.700 interface (tcdump)
> * nft trace monitoring shows the packet beeing accepted on eth1.300 in
> postrouting.
> * tcpdump on the eth1.300 interface does not show the packet.
> * rp_filter etc should not be kicking in here, (and also, "random"
> hosts are dropped)
> * conntrack table is not full
> * this issue seem to suddenly appeared, is this a known bug?

No.

> * hint? All connections from the client is established from the same
> source port.

can you show conntrack -S output?

Is nat in use?

Does 'perf script net_dropmonitor' show anything?

Thanks.
