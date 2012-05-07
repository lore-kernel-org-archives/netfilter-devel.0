From: Kelvie Wong <kelvie@ieee.org>
Subject: Re: [PATCH] netfilter: nf_ct_expect: partially implement
 ctnetlink_change_expect
Date: Mon, 7 May 2012 09:43:24 -0700
Message-ID: <20120507164324.GA3824@kwong-desktop>
References: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
 <1336005564-23171-3-git-send-email-kelvie@ieee.org>
 <20120506230915.GA23306@1984>
 <CAK2bC5rMTMMdepCUpv6oB17ez-LMp=ZUSXacomZXTiM1ZDB92w@mail.gmail.com>
 <20120507084228.GA27334@1984>
 <CAK2bC5o7dxrum59D6fmxsTvSmbWGXbgMeDASW5H1XFtB1=rhEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49428 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab2EGQnb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 12:43:31 -0400
Received: by pbbrp8 with SMTP id rp8so6886399pbb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 07 May 2012 09:43:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAK2bC5o7dxrum59D6fmxsTvSmbWGXbgMeDASW5H1XFtB1=rhEw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 07, 2012 at 09:28:58AM -0700, Kelvie Wong wrote:
> That will be fine.
> 
> Thank you,
> -- 
> Kelvie Wong

Here's the patch if you don't want to do the work :)

>From 2fa0ea4c54ad8b16e7978f8d41892f4d33b0db65 Mon Sep 17 00:00:00 2001
From: Kelvie Wong <kelvie@ieee.org>
Date: Mon, 7 May 2012 09:30:55 -0700
Subject: [PATCH] netfilter: nf_ct_expect: partially implement
 ctnetlink_change_expect

This refreshes the "timeout" attribute in existing expectations if one is
given.

The use case for this would be for userspace helpers to extend the lifetime
of the expectation when requested, as this is not possible right now
without deleting/recreating the expectation.

I use this specifically for forwarding DCERPC traffic through:

DCERPC has a port mapper daemon that chooses a (seemingly) random port for
future traffic to go to. We expect this traffic (with a reasonable
timeout), but sometimes the port mapper will tell the client to continue
using the same port. This allows us to extend the expectation accordingly.

Signed-off-by: Kelvie Wong <kelvie@ieee.org>
---
 net/netfilter/nf_conntrack_netlink.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ca7e835..57518fc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2065,7 +2065,16 @@ static int
 ctnetlink_change_expect(struct nf_conntrack_expect *x,
 			const struct nlattr * const cda[])
 {
-	return -EOPNOTSUPP;
+	/* Refresh the timeout */
+	if (cda[CTA_EXPECT_TIMEOUT]) {
+		if (!del_timer(&x->timeout))
+			return -ETIME;
+
+		x->timeout.expires = jiffies +
+			ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
+		add_timer(&x->timeout);
+	}
+	return 0;
 }
 
 static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
-- 
1.7.9.5

-- 
Kelvie Wong
