From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] ipset fixes
Date: Sat, 22 Sep 2012 12:34:33 +0200
Message-ID: <20120922103433.GA26572@1984>
References: <1348259901-16369-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43526 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab2IVKej (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2012 06:34:39 -0400
Content-Disposition: inline
In-Reply-To: <1348259901-16369-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Fri, Sep 21, 2012 at 10:38:21PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Here follows two important ipset fixes against your nf tree. (The first
> patch is an old one somehow forgotten to send or apply and the other
> ones depend on it.)
> 
> You can pull these changes from:
> 
> git://blackhole.kfki.hu/nf master
> 
> Best regards,
> Jozsef
> 
> Jozsef Kadlecsik (3):
>   netfilter: ipset: Fix sparse warnings "incorrect type in assignment"

This one above has to go through nf-next. I can manually applied, no
need to resend the patch.

>   netfilter: ipset: Check and reject crazy /0 input parameters
>   netfilter: ipset: Fix cidr book keeping for hash:*net* types

Please, could you develop how critical are these above? We're fairly
late in the release cycle, I'd prefer if we pass only really critical
fixes.

Thanks a lot for your updates.
