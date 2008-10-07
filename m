From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH] TPROXY cleanups
Date: Tue, 07 Oct 2008 08:32:54 +0200
Message-ID: <1223361174.8909.6.camel@nessa.odu>
References: <20081006121943.GA13547@x200.localdomain>
 <20081006122603.GA18559@sch.bme.hu> <20081006123921.GA23796@x200.localdomain>
 <20081006141559.GC18559@sch.bme.hu> <48EA31C7.3040604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Alexey Dobriyan <adobriyan@gmail.com>, hidden@sch.bme.hu,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:44618 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYJGGdD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 02:33:03 -0400
Received: from [192.168.1.103] ([89.132.101.55])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTPSA id <0K8C00KG3VHRNN20@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Tue, 07 Oct 2008 08:32:21 +0200 (CEST)
In-reply-to: <48EA31C7.3040604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On h, okt 06, 2008 at 05:41:59 +0200, Patrick McHardy wrote:
> KOVACS Krisztian wrote:
> >On h, okt 06, 2008 at 04:39:21 +0400, Alexey Dobriyan wrote:
> >>xt_TPROXY will pin it because it uses a symbol from it, so it won't
> >>dissapear.
> >
> >Yeah, that's true, and I think that it's impossible to remove the rule
> >attaching the socket references while the skb's in flight. Ok, so let's
> >add module_exit() then.
> 
> So Alexey's patch is fine for applying?

My only fear was that you can remove the core module while there's a
function pointer attached to the skb.

The TPROXY target is the only one actually attaching the pointer and you
obviously can't remove the core module while you have a rule referring to
TPROXY. The question is wheter or not it's possible that an skb still has
the TPROXY-assigned socket (and destructor function pointer) after the
referring iptables rule has been removed.

I'm still not 100% sure that this is not possible... Making the module
unloadable is not the proper solution, though.

-- 
KOVACS Krisztian

