From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/3] net: sched: Use dev_net() instead of the direct
 access to ->nd_net
Date: Fri, 18 Oct 2013 03:44:09 -0700
Message-ID: <1382093049.3284.10.camel@edumazet-glaptop.roam.corp.google.com>
References: <1382089317-24311-1-git-send-email-kadlec@blackhole.kfki.hu>
	 <1382089317-24311-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53562 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3JRKoL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:44:11 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so4489559pdj.29
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2013 03:44:10 -0700 (PDT)
In-Reply-To: <1382089317-24311-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2013-10-18 at 11:41 +0200, Jozsef Kadlecsik wrote:
> We have to use dev_net() instead of the direct access to ->nd_net,
> otherwise compilation fails if NET_NS is not enabled. Reported by
> the kbuild test robot.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---

It seems Stephen took care of this :

http://patchwork.ozlabs.org/patch/284049/



