From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] netfilter: fix mangle tables back
Date: Thu, 11 Feb 2010 19:15:53 +0200
Message-ID: <20100211171553.GB4099@x200>
References: <20100211161235.GA4099@x200>
 <alpine.LSU.2.01.1002111724250.11348@obet.zrqbmnf.qr>
 <4B743196.6020005@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:19511 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab0BKRP5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:15:57 -0500
Received: by fg-out-1718.google.com with SMTP id e21so409164fga.1
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 09:15:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4B743196.6020005@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 11, 2010 at 05:34:30PM +0100, Patrick McHardy wrote:
> Jan Engelhardt wrote:
> > On Thursday 2010-02-11 17:12, Alexey Dobriyan wrote:
> > 
> >> Calling POST_ROUTING hook with NULL input device is not going to work.
> >>
> >> --- a/net/ipv4/netfilter/iptable_mangle.c
> >> +++ b/net/ipv4/netfilter/iptable_mangle.c
> >> @@ -85,7 +85,7 @@ iptable_mangle_hook(unsigned int hook,
> >> 		     const struct net_device *out,
> >> 		     int (*okfn)(struct sk_buff *))
> >> {
> >> -	if (hook == NF_INET_LOCAL_OUT)
> >> +	if (hook == NF_INET_LOCAL_OUT || hook == NF_INET_POST_ROUTING)
> >> 		return ipt_local_hook(hook, skb, in, out, okfn);
> >>
> >> 	/* PREROUTING/INPUT/FORWARD: */
> > 
> > postrouting did not call ipt_local_hook before, so why now?
> 
> What Alexey meant is that
> 
> 	/* PREROUTING/INPUT/FORWARD: */
> 	return ipt_do_table(skb, hook, in, out,
> 			    dev_net(in)->ipv4.iptable_mangle);
> 
> dev_net(in) for a NULL device won't work. Passing them to the local
> hook won't work either however since we perform rerouting there.
> I'm confused now why this didn't crash here so far ...

It did crashed, that's why I noticed it.
But now I can't reproduce it too. Hopefully this patch is correct.


[PATCH] netfilter: fix mangle tables

In POST_ROUTING hook, calling dev_net(in) is going to oops.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv4/netfilter/iptable_mangle.c  |    4 +++-
 net/ipv6/netfilter/ip6table_mangle.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -87,7 +87,9 @@ iptable_mangle_hook(unsigned int hook,
 {
 	if (hook == NF_INET_LOCAL_OUT)
 		return ipt_local_hook(hook, skb, in, out, okfn);
-
+	if (hook == NF_INET_POST_ROUTING)
+		return ipt_do_table(skb, hook, in, out,
+				    dev_net(out)->ipv4.iptable_mangle);
 	/* PREROUTING/INPUT/FORWARD: */
 	return ipt_do_table(skb, hook, in, out,
 			    dev_net(in)->ipv4.iptable_mangle);
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -81,7 +81,9 @@ ip6table_mangle_hook(unsigned int hook, struct sk_buff *skb,
 {
 	if (hook == NF_INET_LOCAL_OUT)
 		return ip6t_local_out_hook(hook, skb, out, okfn);
-
+	if (hook == NF_INET_POST_ROUTING)
+		return ip6t_do_table(skb, hook, in, out,
+				     dev_net(out)->ipv6.ip6table_mangle);
 	/* INPUT/FORWARD */
 	return ip6t_do_table(skb, hook, in, out,
 			     dev_net(in)->ipv6.ip6table_mangle);
