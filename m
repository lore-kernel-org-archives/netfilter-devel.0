From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-restore: move code to add_param_to_argv,
 cleanup (fix gcc-4.7)
Date: Mon, 30 Jul 2012 03:40:48 +0200
Message-ID: <20120730014048.GA3521@1984>
References: <1343039903-7230-1-git-send-email-pablo@netfilter.org>
 <1343042946.2626.10727.camel@edumazet-glaptop>
 <1343043528.2626.10755.camel@edumazet-glaptop>
 <20120730013707.GA2350@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50857 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab2G3Bky (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:40:54 -0400
Content-Disposition: inline
In-Reply-To: <20120730013707.GA2350@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 30, 2012 at 03:37:07AM +0200, Pablo Neira Ayuso wrote:
> From 8cfcb0137f4aee880ec749cd2356148325f6085d Mon Sep 17 00:00:00 2001
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Mon, 30 Jul 2012 03:08:51 +0200
> Subject: [PATCH] iptables-restore: fix memory corruption in parameter parsing
>  with gcc-4.7

I'm going to change the title of this patch, memory corruption does
not seem appropriate. Instead, the problem seems to be related to
wrong assumptions on uninitialized memory area.
