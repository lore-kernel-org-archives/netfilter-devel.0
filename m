From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Suppress compile-time warnings:
Date: Mon, 21 Nov 2011 18:37:22 +0100
Message-ID: <20111121173722.GA4193@1984>
References: <1320863855-2540-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58527 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab1KURhf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:37:35 -0500
Content-Disposition: inline
In-Reply-To: <1320863855-2540-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 09, 2011 at 07:37:35PM +0100, Jozsef Kadlecsik wrote:
> warning: 'ip_to' may be used uninitialized in this function
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  net/netfilter/ipset/ip_set_hash_ipport.c    |    2 +-
>  net/netfilter/ipset/ip_set_hash_ipportip.c  |    2 +-
>  net/netfilter/ipset/ip_set_hash_ipportnet.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Applied to my nf branch:

http://1984.lsi.us.es/git/?p=net/.git;a=summary

Thanks!
