From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_gateway locks up
Date: Fri, 26 Oct 2007 16:33:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710261617020.12896@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710220012060.1997@fbirervta.pbzchgretzou.qr>
 <4721F4F7.1060602@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48690 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbXJZOdm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:33:42 -0400
In-Reply-To: <4721F4F7.1060602@ufomechanic.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 26 2007 15:08, Amin Azez wrote:
>It assumes that IF skb->dst is set, that it is a neighbour table entry.
>
>Your code is:
>
>	dst = skb->dst;
>	if ((neigh = dst->neighbour) == NULL)
>		return false;
>
>
>It doesn't consider that skb->dst may be NULL, which it will in PRE_ROUTING.

That's because Patrick said it cannot be NULL :-)
http://marc.info/?l=netfilter-devel&m=118105659716253&w=2

Of course, an oops in an interrupt handler ain't that funny..
