From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Invalid size of target
Date: Wed, 16 Jul 2008 22:37:34 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807162232360.32031@fbirervta.pbzchgretzou.qr>
References: <48bd37870807141225k7c8ed4c2o747bff281792b13f@mail.gmail.com>  <48bd37870807141226n4a5a8b8fwf1b5284d42b5a7b5@mail.gmail.com>  <alpine.LNX.1.10.0807142204050.13215@fbirervta.pbzchgretzou.qr>  <48bd37870807141336u3f821c32s5f9cb9ee0fe94370@mail.gmail.com>
  <alpine.LNX.1.10.0807142313290.13215@fbirervta.pbzchgretzou.qr>  <48bd37870807150547r6211bb9bp74c1d3490c019000@mail.gmail.com>  <alpine.LNX.1.10.0807151650130.2212@fbirervta.pbzchgretzou.qr> <48bd37870807161115u1cf3eca2jf5e649fbd78a729e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kevin Sookocheff <kevin.sookocheff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35577 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYGPUhf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:37:35 -0400
In-Reply-To: <48bd37870807161115u1cf3eca2jf5e649fbd78a729e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-07-16 20:15, Kevin Sookocheff wrote:

>Hi Jan,
>
>Simplifying my iptables private struct in ipt_CSUM.h down to
>
>struct ipt_CSUM_info {
>   u_int32_t    count;
>};
>
>and calculating .size .userspacesize (in libiptCSUM.c) and .targetsize
>(in ipt_CSUM.c) all with IPT_ALIGN(sizeof(struct ipt_CSUM_info) gives
>me an error stating:
>
>iptables: CSUM target: invalid size 12 != 4

It's impossible to figure out if there is no code to have a look at.

>In what way should I be creating this struct so that it aligns
>correctly in user and kernel space?

With the above struct, you fulfilled all alignment requirements.
It's a brown paper bag to me, and only compiling it myself
here will yield more information.
