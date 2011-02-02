From: Patrick McHardy <kaber@trash.net>
Subject: Re: ebtables_nfqueue: missing structure afinfo
Date: Wed, 02 Feb 2011 23:59:44 +0100
Message-ID: <4D49E1E0.50304@trash.net>
References: <4D3DE736.70808@wzdftpd.net> <4D3EA72B.7000509@trash.net> <4D49AEFC.4040203@wzdftpd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pierre Chifflier <chifflier@wzdftpd.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44527 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab1BBW7q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:59:46 -0500
In-Reply-To: <4D49AEFC.4040203@wzdftpd.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 02.02.2011 20:22, schrieb Pierre Chifflier:
> I've spent a few days trying to make it optional (in nf_queue.c,
> function __nf_queue), however I have a weird problem:
> If I remove the test for afinfo (and ensure that the pointer is not used
> if null), everything seems to work fine.
> However, when I use a userspace program (always returning NF_ACCEPT), I
> got a fatal kernel oops (or panic) regarding packets.
> According to the info displayed, it seems to be sometimes in
> br_handle_frame, at
> this point:
> 	case BR_STATE_FORWARDING:
> 		rhook = rcu_dereference(br_should_route_hook);
> 		if (rhook) {
> 			if ((*rhook)(skb))
> 
> inside the (*rhook) call.

It shouldn't even get to this function since this is before the
NF_HOOK calls.

> Sometimes it's in netlink_unicast (unknown location), always when
> reinjecting packet.
> 
> I tried to get more info with kgdb, but without much success:
> #2  0xc11d1adc in skb_release_all (skb=0xdf1ed600) at net/core/skbuff.c:403
> #3  __kfree_skb (skb=0xdf1ed600) at net/core/skbuff.c:417
> #4  0xc11d1bdb in kfree_skb (skb=0xdf1ed600) at net/core/skbuff.c:438
> #5  0xc11ee4d1 in netlink_unicast (ssk=0xdbf15c00, skb=<value optimized
> out>,
>     pid=<value optimized out>, nonblock=0) at net/netlink/af_netlink.c:921
> 
> Any idea on what could cause this ? AFAICT, it was not happening when I
> used a fake afinfo structure.

No. Please send over the code you're using and I'll have a closer look.
