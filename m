From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [PATCH v2] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Sun, 31 Dec 2017 09:51:10 +1100
Message-ID: <20171230225110.GA10178@dimstar.local.net>
References: <20171228072833.9980-1-harshasharmaiitr@gmail.com>
 <20171228105236.hmii7xbk5jtctmpr@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsha Sharma <harshasharmaiitr@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37792 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750944AbdL3WvX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 17:51:23 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 8127E42B7D6
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 09:51:11 +1100 (AEDT)
Content-Disposition: inline
In-Reply-To: <20171228105236.hmii7xbk5jtctmpr@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 28, 2017 at 11:52:36AM +0100, Pablo Neira Ayuso wrote:
> Cc'ing Duncan.

No need - I'm on netfilter-devel ;)
>
> On Thu, Dec 28, 2017 at 12:58:33PM +0530, Harsha Sharma wrote:
> > Do not print timeout and burst in case default values are used.
> > For e.g.
> > iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
> > --hashlimit-above 200/sec --hashlimit-mode srcip,dstport
> > --hashlimit-name http1 -j DROP
> >
> > nft add rule ip filter INPUT tcp dport 80 flow table http1 { tcp dport .
> > ip saddr limit rate over 200/second } counter drop
>
> This is what I was asking for.
>
> Applied, thanks Harsha.
>
> @Duncan: I think you can update the wiki again after this, given that
> now those values should not be printed.

I tested after applying the patch and now the second example is broken:

> iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit --hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode srcip,dstport --hashlimit-name http2 --hashlimit-htable-expire 3000 -j DROP
> nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport . ip saddr timeout 3s limit rate over 200 kbytes/second burst 1 mbytes burst 6 packets} counter drop

The traling "burst 6 packets" should not be there.

I propose to leave the wiki until this is fixed.

Cheers ... Duncan.
