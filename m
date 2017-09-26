From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: ipset: pernet ops must be unregistered
 last
Date: Tue, 26 Sep 2017 19:58:50 +0200
Message-ID: <20170926175850.GA24805@salvia>
References: <20170926095754.32766-1-fw@strlen.de>
 <alpine.DEB.2.11.1709261947190.19287@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56151 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966562AbdIZR6z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2017 13:58:55 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1709261947190.19287@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 26, 2017 at 07:48:45PM +0200, Jozsef Kadlecsik wrote:
> On Tue, 26 Sep 2017, Florian Westphal wrote:
> 
> > Removing the ipset module leaves a small window where one cpu performs
> > module removal while another runs a command like 'ipset flush'.
> > 
> > ipset uses net_generic(), unregistering the pernet ops frees this
> > storage area.
> > 
> > Fix it by first removing the user-visible api handlers and the pernet
> > ops last.
> > 
> > Fixes: 1785e8f473082 ("netfiler: ipset: Add net namespace for ipset")
> > Reported-by: Li Shuang <shuali@redhat.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> 
> Pablo, could you apply the patch in the nf tree?

Applied, thanks Jozsef.

