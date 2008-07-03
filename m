From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH,RFC] Route match, kernel
Date: Thu, 3 Jul 2008 09:22:03 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807030920280.20393@fbirervta.pbzchgretzou.qr>
References: <20080703003942.GA2012@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42475 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936998AbYGCHWE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:22:04 -0400
In-Reply-To: <20080703003942.GA2012@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>+	case XT_ROUTE_SRC_EXISTS:
>+		fl.nl_u.ip4_u.daddr = iph->saddr;
>+		ret = fib_lookup(dev_net(in), &fl, &res);
>+		if (ret == 0 && res.prefixlen != 0) {
>+			fib_res_put(&res);
>+			return true ^ info->invert;
>+		}
>+	case XT_ROUTE_SRC_EQ:
>+		fl.nl_u.ip4_u.daddr = iph->saddr;
>+		ret = fib_lookup(dev_net(in), &fl, &res);
>+		if (ret == 0 && res.prefixlen == info->prefixlen) {
>+			fib_res_put(&res);
>+			return true;
>+		}
>+		break;

Should not these be true ^ info->invert too?

I would probably combine mode and invert, to save a byte.

>+static bool
>+route_mt6(const struct sk_buff *skb, const struct net_device *in,
>+           const struct net_device *out, const struct xt_match *match,
>+           const void *matchinfo, int offset, unsigned int protoff,
>+           bool *hotdrop)
>+{
>+	return 1;
>+}

If you do not support IPv6, do not write a function for it ;-)
