From: Florian Westphal <fw@strlen.de>
Subject: Re: [BUG] kernel crash in br_netfilter
Date: Tue, 8 Mar 2016 12:06:00 +0100
Message-ID: <20160308110600.GA1011@breakpoint.cc>
References: <56D43A9E.2070504@neratec.com>
 <56DDBDCD.8000004@neratec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Felix Fietkau <nbd@openwrt.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37793 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932479AbcCHLGE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 06:06:04 -0500
Content-Disposition: inline
In-Reply-To: <56DDBDCD.8000004@neratec.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> > Reproducing the crash
> > 1. build the firmware for the system to test
> >    * use default configuration
> >    * ensure to select CONFIG_BRIDGE_NETFILTER in kernel_menuconfig
> > 2. boot the device and access it over serial
> > 3. ensure br-lan bridge has at least two active ports
> >    * tested with ath9k + Ethernet (gianfar and ag71xx)
> >    * if not enabled, enable radio0 and ensure wlan0 is in bridge
> > 4. run: sysctl -w net.bridge.bridge-nf-call-iptables=1
> > 5. from your host, continuously ping the device over Ethernet
> > 6. run: ifconfig br-lan down
> > 
> > The next ingress packet causes a fatal crash.
> > 
> > Trace logs for MIPS and PPC are attached and hint to __nf_conntrack_confirm
> > 
> > 
> > Let me know if I could provide more information to further isolate the problem.
> > 
> > 
> Got forward with that issue and after wondering why the netfilter folks were
> unable to reproduce, it finally turned out the problematic code is OWRT private in
> target/linux/generic/patches-X/120-bridge_allow_receiption_on_disabled_port.patch

Yes, the patch is wrong.  As you discovered, the
br_netfilter/call-iptables infrastructure will free the skb, so all code
after NF_HOOK in this patch results in use-after-free.

Seems the quick-fix (but thats also not correct) is to use NF_BR_LOCAL_IN instead so that
we bypass the call-iptables infrastructure.

> 1. gets passed to br_handle_frame()
> 2. enters the BR_STATE_DISABLED case in the mentioned patch
> 3. gets passed to the related NF_HOOK
>    a) in br_nf_pre_routing() a conntrack context ct is created
>    b) that in the same nf_iterate() is destroyed in br_nf_pre_routing_finish()
> 4. in the br_pass_frame_up() following the NF_HOOK
>    a) ipv4_confirm() runs __nf_conntrack_confirm(ct) with invalid ct
>    b) which attempts to nf_ct_del_from_dying_or_unconfirmed_list(ct)
>    c) and with that de-references and writes to LIST_POISON2 in pprev

Yes, once NF_HOOK returns skb is in undefined state.

This snippet (from mainline):

                /* Deliver packet to local host only */
                if (NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_IN,
                            dev_net(skb->dev), NULL, skb, skb->dev, NULL,
                            br_handle_local_finish)) {
                        return RX_HANDLER_CONSUMED; /* consumed by filter */
                } else {
                        *pskb = skb;
                        return RX_HANDLER_PASS; /* continue processing */
                }

... is also dubious.  It only works because no module in current
uptream kernel registers a destructive hook in NF_BR_LOCAL_IN.

In fact, this looks like we get crash here as well once we gain ability to
NFQUEUE in nftables bridge family.

> My hot-fix to prevent the crash is to instead of passing the skb to NF_HOOK
> directly pass it to br_handle_local_finish(). But having insufficient insight into
> what is going on there, this is fighting the symptoms rather than solving the root
> cause. Maybe it is even better to drop patch 120 (not tested yet)?

Sorry, I don't know why this patch was not merged upstream and do not know why its
in openwrt.
