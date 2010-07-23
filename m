From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xt_quota: don't copy quota back to userspace
Date: Fri, 23 Jul 2010 08:20:14 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007230818260.815@obet.zrqbmnf.qr>
References: <1279860845-7177-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49603 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab0GWGUR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jul 2010 02:20:17 -0400
In-Reply-To: <1279860845-7177-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-07-23 06:54, Changli Gao wrote:

>This patch should be applied after my another patch:
>http://patchwork.ozlabs.org/patch/59729/
>
>xt_quota: don't copy quota back to userspace
>
>In nowadays, table entries are per-cpu variables, so it don't make any 
>sense to copy quota back to one of the variable instances. To keep 
>things simple, this patch undo the copy.

I object. This line is on purpose, to give at least a chance of 
reporting back a more-or-less believable value. Without copying
the value back, users have moaned about the counter not decreasing
_at all_.
