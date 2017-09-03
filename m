From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: xt_TEE: Fix potential deadlock when TEE target
 is inserted
Date: Sun, 3 Sep 2017 17:32:26 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1709031730130.10520@n3.vanv.qr>
References: <20170903143034.25844-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:42828 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752917AbdICPc2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2017 11:32:28 -0400
In-Reply-To: <20170903143034.25844-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2017-09-03 16:30, Taehee Yoo wrote:

>When xt_TEE target is inserted, lockdep warns about possible
>DEADLOCK situation. to avoid deadlock situation
>the register_netdevice_notifier() should be called by only init routine.
>
>+#include <linux/if.h>
> 
> struct xt_tee_tginfo {
> 	union nf_inet_addr gw;
>-	char oif[16];
>+	char oif[IFNAMSIZ];

This should not be done, as xt_tee_tginfo is exported to userspace.
(It also has nothing to do with fixing the deadlock, really.)

>+		case NETDEV_UNREGISTER:
>+			if ((dev->ifindex == priv->oif) &&

redundant new parenthesis group
