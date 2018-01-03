From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: And another thing
Date: Thu, 4 Jan 2018 09:59:29 +1100
Message-ID: <20180103225929.GC3302@dimstar.local.net>
References: <20180103144109.8280-1-pablo@netfilter.org>
 <20180103222640.GB3302@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:51141 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751014AbeACW7o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 17:59:44 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with SMTP id 6D0981A2A54
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2018 09:59:30 +1100 (AEDT)
Content-Disposition: inline
In-Reply-To: <20180103222640.GB3302@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 04, 2018 at 09:26:40AM +1100, Duncan Roe wrote:
> On Wed, Jan 03, 2018 at 03:41:08PM +0100, Pablo Neira Ayuso wrote:
> > iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit --hashlimit-above 200kb/s --hashlimit-burst 1mb --hashlimit-mode srcip,dstport --hashlimit-name http2 --hashlimit-htable-expire 3000 -j DROP
> >
> > shows:
> >
> > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport . ip saddr timeout 3s limit rate over 200 kbytes/second burst 1 mbytes burst 6 packets} counter drop
> >
> > which prints burst twice, this is not correct.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
Not actually related to the patch, but I happened to notice:

> 769   if (info->cfg.mode & XT_HASHLIMIT_BYTES) {
> 770     uint32_t burst = 0;
> 771     if (cb->xflags & F_BURST) {
> 772       if (info->cfg.burst < cost_to_bytes(info->cfg.avg))
> 773         xtables_error(PARAMETER_PROBLEM,
> 774           "burst cannot be smaller than %lub", cost_to_bytes(info->cfg.avg));
> 775
> 776       burst = info->cfg.burst;
> 777       burst /= cost_to_bytes(info->cfg.avg);
> 778       if (info->cfg.burst % cost_to_bytes(info->cfg.avg))
> 779         burst++;
> 780       if (!(cb->xflags & F_HTABLE_EXPIRE))
> 781         info->cfg.expire = XT_HASHLIMIT_BYTE_EXPIRE_BURST * 1000;
> 782     }
> 783     info->cfg.burst = burst;
> 784   } else if (info->cfg.burst > XT_HASHLIMIT_BURST_MAX)
> 785     burst_error();

What is that final "else" claues there for? No hashlimit was specified so why
check its value?

Cheers ... Duncan.
