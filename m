From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/1] ipset patch for nf
Date: Sat, 29 Aug 2015 01:03:26 +0200
Message-ID: <20150828230326.GA30203@salvia>
References: <1440782152-21890-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42720 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbbH1W5I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Aug 2015 18:57:08 -0400
Content-Disposition: inline
In-Reply-To: <1440782152-21890-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 28, 2015 at 07:15:51PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please apply the next bugfix patch against the nf tree.
> 
> - Dave Jones reported that KASan detected out of bounds access in hash:net*
>   types, which is fixed in the next patch
> 
> Thanks,
> Jozsef
> 
> The following changes since commit 18e1db67e93ed75d9dc0d34c8d783ccf10547c2b:
> 
>   netfilter: bridge: fix IPv6 packets not being bridged with CONFIG_IPV6=n (2015-08-19 21:21:41 +0200)
> 
> are available in the git repository at:
> 
>   git://blackhole.kfki.hu/nf master

Pulled into nf, thanks Jozsef.
