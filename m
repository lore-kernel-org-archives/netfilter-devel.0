From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: TEE broken in 3.6
Date: Wed, 17 Oct 2012 10:23:23 +0200
Message-ID: <20121017082323.GA13289@1984>
References: <20121016211319.3f07a7e3@goldlack.enda.eu>
 <1350417618.3954.1494.camel@edumazet-glaptop>
 <20121017094543.2ddb0397@goldlack.enda.eu>
 <1350460131.26103.68.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Cc: Torsten Luettgert <ml-netfilter@enda.eu>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56810 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab2JQIXa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:23:30 -0400
Content-Disposition: inline
In-Reply-To: <1350460131.26103.68.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 17, 2012 at 09:48:51AM +0200, Eric Dumazet wrote:
> On Wed, 2012-10-17 at 09:45 +0200, Torsten Luettgert wrote:
> > On Tue, 16 Oct 2012 22:00:18 +0200
> > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > 
> > > Could you try latest tree, with the following patch ?
> > 
> > Yeah, that works.
> > 
> > I'm still a bit sad, though, since I'll have to wait for 3.7 now (no
> > FLOWI_FLAG_KNOWN_NH in 3.6.*), or is there any solution for those "old"
> > kernels, too?
> > 
> > Regards,
> > Torsten
> 
> I believe its stable material, it will reach 3.6.3 or 3.6.4 dont worry.

@Eric: I've included the description to the patch (just to save you
some time to make it yourself).

Let me know if you're OK with the one attached. If not, feel free to
pass me yours.

--1yeeQ81UyVL57Vl7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-xt_TEE-fix-routing-due-to-rt_gateway-seman.patch"

>From d977416de1ceb9ec960b34c0202d711a9a6dead4 Mon Sep 17 00:00:00 2001
From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 17 Oct 2012 10:18:15 +0200
Subject: [PATCH] netfilter: xt_TEE: fix routing due to rt_gateway semantic
 changes

Since (f8126f1 ipv4: Adjust semantics of rt->rt_gateway.), xt_TEE
stopped working.

The problem is that it tries to ARP lookup the original destination
address of the forwarded packet, not the address of the gateway.

Reported-by: Torsten Luettgert <ml-netfilter@enda.eu>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TEE.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index ee2e5bc..bd93e51 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -70,6 +70,7 @@ tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
 	fl4.daddr = info->gw.ip;
 	fl4.flowi4_tos = RT_TOS(iph->tos);
 	fl4.flowi4_scope = RT_SCOPE_UNIVERSE;
+	fl4.flowi4_flags = FLOWI_FLAG_KNOWN_NH;
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		return false;
-- 
1.7.10.4


--1yeeQ81UyVL57Vl7--
