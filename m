From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] xtables-addons: xt_RAWNAT: skb writable part might not
 include whole l4 header (ipv4 case).
Date: Wed, 8 May 2013 13:32:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1305081322250.29391@nerf07.vanv.qr>
References: <20130505220504.1a3f2380a1e798b37e628dd1@highloadlab.com> <20130505222433.5c27056103b98340bba773df@highloadlab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Dmitry Popov <dp@highloadlab.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40336 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab3EHLc7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 07:32:59 -0400
In-Reply-To: <20130505222433.5c27056103b98340bba773df@highloadlab.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2013-05-05 20:24, Dmitry Popov wrote:

>Also, shouldn't xt_RAWNAT depend on nf_defrag_ipv4 module? 

Dunno. Being a module for really "raw" nf_conntrack-less static NAT, I 
feel no reason to make it hard-depend on nf_defrag, and instead leave it 
up to the user whether or not to load nf_defrag.

With nf_nat having gained IPv6 support, I also feel less inclined to 
keep xt_RAWNAT around.

(In the meantime, your patch is applied.)


>xt_RAWNAT may work with ip fragments in PREROUTING chain, changing ip payload
>(believing it's tcp/udp checksum) in fragment is harmful.

I would tend to just ignore the fragment case for now, like many other 
modules. Comments against?

diff --git a/extensions/xt_RAWNAT.c b/extensions/xt_RAWNAT.c
index 858f911..0a24e77 100644
--- a/extensions/xt_RAWNAT.c
+++ b/extensions/xt_RAWNAT.c
@@ -87,6 +87,13 @@ static void rawnat4_update_l4(struct sk_buff *skb, __be32 oldip, __be32 newip)
 	struct udphdr *udph;
 	bool cond;
 
+	/*
+	 * We do not really deal with fragments. On the first packet, we can attempt
+	 * to modify the L4 header, otherwise just ignore the data.
+	 */
+	if ((iph->frag_off & htons(IP_OFFSET)) == 0)
+		return;
+
 	switch (iph->protocol) {
 	case IPPROTO_TCP:
 		tcph = transport_hdr;
