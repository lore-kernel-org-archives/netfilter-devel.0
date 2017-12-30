From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Sun, 31 Dec 2017 00:16:30 +0100
Message-ID: <20171230231630.qvfkstglqwhrpsff@salvia>
References: <20171228072833.9980-1-harshasharmaiitr@gmail.com>
 <20171228105236.hmii7xbk5jtctmpr@salvia>
 <20171230225110.GA10178@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Harsha Sharma <harshasharmaiitr@gmail.com>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751078AbdL3XQe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 18:16:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72E75C2B23
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:16:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63AE1FEFB2
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:16:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171230225110.GA10178@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Harsha,

On Sun, Dec 31, 2017 at 09:51:10AM +1100, Duncan Roe wrote:
> On Thu, Dec 28, 2017 at 11:52:36AM +0100, Pablo Neira Ayuso wrote:
> > Cc'ing Duncan.
> 
> No need - I'm on netfilter-devel ;)
> >
> > On Thu, Dec 28, 2017 at 12:58:33PM +0530, Harsha Sharma wrote:
> > > Do not print timeout and burst in case default values are used.
> > > For e.g.
> > > iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
> > > --hashlimit-above 200/sec --hashlimit-mode srcip,dstport
> > > --hashlimit-name http1 -j DROP
> > >
> > > nft add rule ip filter INPUT tcp dport 80 flow table http1 { tcp dport .
> > > ip saddr limit rate over 200/second } counter drop
> >
> > This is what I was asking for.
> >
> > Applied, thanks Harsha.
> >
> > @Duncan: I think you can update the wiki again after this, given that
> > now those values should not be printed.
> 
> I tested after applying the patch and now the second example is broken:
> 
> > iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit --hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode srcip,dstport --hashlimit-name http2 --hashlimit-htable-expire 3000 -j DROP
> > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport . ip saddr timeout 3s limit rate over 200 kbytes/second burst 1 mbytes burst 6 packets} counter drop
> 
> The traling "burst 6 packets" should not be there.

Please, send a new patch to fix this as Duncan spots.

Thanks.
