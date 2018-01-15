From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [PATCH v2] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Mon, 15 Jan 2018 12:45:32 +1100
Message-ID: <20180115014532.GA13839@dimstar.local.net>
References: <20171228072833.9980-1-harshasharmaiitr@gmail.com>
 <20171228105236.hmii7xbk5jtctmpr@salvia>
 <20171230225110.GA10178@dimstar.local.net>
 <20171230231630.qvfkstglqwhrpsff@salvia>
 <20180102224746.GB3309@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsha Sharma <harshasharmaiitr@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:58990 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752259AbeAOBpr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jan 2018 20:45:47 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with SMTP id 53C90109FFC
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 12:45:33 +1100 (AEDT)
Content-Disposition: inline
In-Reply-To: <20180102224746.GB3309@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 03, 2018 at 09:47:46AM +1100, Duncan Roe wrote:
> On Sun, Dec 31, 2017 at 12:16:30AM +0100, Pablo Neira Ayuso wrote:
...
> > > > @Duncan: I think you can update the wiki again after this, given that
> > > > now those values should not be printed.
> > >
The examples now work as intended, so I updated the wiki. (INPUT is now being
translated to input btw).

It is still the case that if the iptables command specifies default burst or
timeout then nothing is output for these, including the yetch case of specifying
a limit (with or w/out a burst) and getting no timeout.

I plan to look into that in February but have been rather busy getting ready for
LCA2018 where I'm giving a talk (on nftables).

Cheers ... Duncan.
