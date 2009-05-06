From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/4] conntrack event subsystem updates for 2.6.31
Date: Wed, 06 May 2009 15:36:06 +0200
Message-ID: <4A019246.4070001@netfilter.org>
References: <20090502141522.8067.436.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48080 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbZEFNg0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 May 2009 09:36:26 -0400
In-Reply-To: <20090502141522.8067.436.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi Patrick,
> 
> This is the first bunch of patches oriented to the event caching
> system, I still have a couple more here but I'm still getting them
> into shape.

I noticed a "scheduling while atomic" problem in the event caching
"replace notify chain by function pointer" patch. It seems that
gfp_any(), which is used by nfnetlink_send(), returns GFP_KERNEL inside
a RCU read-side lock section, that's invalid. Moreover, this triggers a
backtrace when using very small buffers and making lots of requests from
user-context (we hit schedule() due to __GFP_WAIT in the netlink code).

Patrick, just to let you know in case that you look at these patches. I
have fixed this here. I'll resend these patches once nf-next-2.6 is open.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
