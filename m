From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] TCP conntrack patches
Date: Sun, 9 Sep 2012 22:11:11 +0200
Message-ID: <20120909201111.GA19595@1984>
References: <1346442954-29047-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Jan Wrobel <wrr@mixedbit.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47456 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab2IIULP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:11:15 -0400
Content-Disposition: inline
In-Reply-To: <1346442954-29047-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Fri, Aug 31, 2012 at 09:55:52PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Jan Wrobel wrote a nice article on off-path TCP attacks (see
> http://arxiv.org/abs/1201.2074). He discovered two weaknesses
> in netfilter TCP conntrack, which make such attacks easier.
> The next two patches fixes the issues.
> 
> Please review them and consider applying them.

I think this can be considered security fixes, so I'll push this to
3.6-rc.

Thanks Jozsef.
