From: Andrew Collins <bsderandrew@gmail.com>
Subject: Re: [PATCH] netfilter: nf_nat: Also handle non-ESTABLISHED routing
 changes in MASQUERADE
Date: Wed, 12 Dec 2012 17:17:08 -0700
Message-ID: <CAKTPYJR=F+aob3tcLshVvsN-WvCAjgjep05rijd-_x+1ciUvHA@mail.gmail.com>
References: <1355356167-10397-1-git-send-email-bsderandrew@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36647 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2LMARI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:17:08 -0500
In-Reply-To: <1355356167-10397-1-git-send-email-bsderandrew@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 12, 2012 at 4:49 PM, Andrew Collins <bsderandrew@gmail.com> wrote:
> The MASQUERADE target now handles routing changes which affect
> the output interface of a connection, but only for ESTABLISHED
> connections.  It is also possible for NEW connections which
> already have a conntrack entry to be affected by routing changes.
>
> This adds a check to drop entries in the NEW+conntrack state
> when the oif has changed.
>
> Signed-off-by: Andrew Collins <bsderandrew@gmail.com>
> ---
>  net/ipv4/netfilter/iptable_nat.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)

My mistake, I forgot to include the corresponding ip6table_nat.c
change (it's identical), ignore this for now.
