From: Torsten Luettgert <ml-netfilter@enda.eu>
Subject: Re: Splitting network packets from target modules
Date: Thu, 15 Nov 2012 14:49:15 +0100
Message-ID: <20121115144915.427483f6@goldlack.enda.eu>
References: <k82ps8$uh2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: arif <aftnix@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.cbxnet.de ([212.87.33.16]:59912 "EHLO mail1.cbxnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767793Ab2KONtT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:49:19 -0500
In-Reply-To: <k82ps8$uh2$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 15 Nov 2012 19:14:44 +0600
arif <aftnix@gmail.com> wrote:

> But i'm confused how i'm going to send these new skbs to uplink.
> returning NF_ACCEPT will not do the trick i guess.
> 
> Is there any existing target module which tries to do send multiple
> skbs to uplink?

I'd guess TEE would be the right place to look at since it creates
another packet and sends it on. But beware, it's buggy in current
kernels, a fix by Eric Dumazet is required:

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index ee2e5bc..bd93e51 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -70,6 +70,7 @@ tee_tg_route4(struct sk_buff *skb, const struct
xt_tee_tginfo *info) fl4.daddr = info->gw.ip;
 	fl4.flowi4_tos = RT_TOS(iph->tos);
 	fl4.flowi4_scope = RT_SCOPE_UNIVERSE;
+	fl4.flowi4_flags = FLOWI_FLAG_KNOWN_NH;
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		return false;

Hope that helps,
Torsten
