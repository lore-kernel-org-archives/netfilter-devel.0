From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH,RFC] Route match, kernel
Date: Thu, 3 Jul 2008 09:27:29 -0700
Message-ID: <20080703162729.GA19256@linuxace.com>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030920280.20393@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:39453
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750721AbYGCQ1a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:27:30 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0807030920280.20393@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 03, 2008 at 09:22:03AM +0200, Jan Engelhardt wrote:
> 
> >+	case XT_ROUTE_SRC_EXISTS:
> >+		fl.nl_u.ip4_u.daddr = iph->saddr;
> >+		ret = fib_lookup(dev_net(in), &fl, &res);
> >+		if (ret == 0 && res.prefixlen != 0) {
> >+			fib_res_put(&res);
> >+			return true ^ info->invert;
> >+		}
> >+	case XT_ROUTE_SRC_EQ:
> >+		fl.nl_u.ip4_u.daddr = iph->saddr;
> >+		ret = fib_lookup(dev_net(in), &fl, &res);
> >+		if (ret == 0 && res.prefixlen == info->prefixlen) {
> >+			fib_res_put(&res);
> >+			return true;
> >+		}
> >+		break;
> 
> Should not these be true ^ info->invert too?

No - invert is only supported on the *_EXISTS case.  Didn't see any point
in supporting invert on gt/lt, but now that I think of it perhaps supporting
it on _EQ may be useful.  But can you see a point on gt/lt?

> I would probably combine mode and invert, to save a byte.

Possible.

> >+static bool
> >+route_mt6(const struct sk_buff *skb, const struct net_device *in,
> >+           const struct net_device *out, const struct xt_match *match,
> >+           const void *matchinfo, int offset, unsigned int protoff,
> >+           bool *hotdrop)
> >+{
> >+	return 1;
> >+}
> 
> If you do not support IPv6, do not write a function for it ;-)

OK, so I should have #if 0 it...but this is just an RFC and that was
listed in the TODO ;-)

Thanks for the review BTW.

Phil
