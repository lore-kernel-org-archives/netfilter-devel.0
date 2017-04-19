From: Florian Westphal <fw@strlen.de>
Subject: Re: nfqueue buf size for recv()
Date: Wed, 19 Apr 2017 23:45:21 +0200
Message-ID: <20170419214521.GD17294@breakpoint.cc>
References: <20170419165024.GA28485@legohost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oleg <lego12239@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45124 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1761818AbdDSVqi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 17:46:38 -0400
Content-Disposition: inline
In-Reply-To: <20170419165024.GA28485@legohost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oleg <lego12239@yandex.ru> wrote:
> Can anybody tell me how can i determine a right buf size for recv()
> in libnetfilter_queue program.
> 
> http://www.netfilter.org/projects/libnetfilter_queue/doxygen/group__Queue.html#gae36aee5b74d0c88d2f8530e356f68b79
> 
> tells nothing about this.

I'd suggest a 80k buffer to be on safe side.

You need to be able to hold the size of one packet, which could be up to
64k depending on options/mtu) plus all the extra netlink meta data.

