From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/6] netfilter: xtables: consolidate table hook
 functions
Date: Mon, 10 Aug 2009 22:12:09 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908102209520.28094@fbirervta.pbzchgretzou.qr>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de> <1249931992-18761-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46340 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZHJUMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:12:10 -0400
In-Reply-To: <1249931992-18761-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-08-10 21:19, Jan Engelhardt wrote:
>+/* The work comes in here from netfilter.c. */
>+static unsigned int
>+iptable_mangle_hook(unsigned int hook,
>+		     struct sk_buff *skb,
>+		     const struct net_device *in,
>+		     const struct net_device *out,
>+		     int (*okfn)(struct sk_buff *))
>+{
>+	if (hook == NF_INET_LOCAL_OUT)
>+		return ipt_local_hook(hook, skb, in, out, okfn);
>+
>+	/* PREROUTING/INPUT/FORWARD: */
>+	return ipt_do_table(skb, hook, in, out,
>+	       dev_net(in)->ipv4.iptable_mangle);
>+}

And the little style nuances are already resolved in the git repo
(diffstat does not change, so I went for a quick repush before
anyone saw it) before we start arguing about the shade of pink
the bikeshed is supposed to have.

