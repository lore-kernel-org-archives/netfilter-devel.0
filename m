From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: xt_owner-xt_socket plans
Date: Mon, 21 Jan 2008 15:41:24 +0100
Message-ID: <20080121144124.GA373@sch.bme.hu>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr> <479461C2.1060703@balabit.hu> <Pine.LNX.4.64.0801211417200.24186@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laszlo Attila Toth <panther@balabit.hu>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:55496 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbYAUOl1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:41:27 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801211417200.24186@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On h, jan 21, 2008 at 02:23:25 +0100, Jan Engelhardt wrote:
> On January 21 2008 10:11, Laszlo Attila Toth wrote:
> >Jan Engelhardt wrote:
> >> I just remembered that xt_socket (from tproxy) does an (explicit) socket
> >> lookup. xt_owner on the other hand, takes the socket pointer from the skb --
> >> which of course only works in the output path.
> >> 
> >> xt_owner is still in the 2.6.25 development queue, and because the two
> >> modules are similar, I thought that maybe xt_owner could be merged with
> >> xt_socket (doing a rename to xt_socket in the current net-2.6.25),
> >> because they are quite close in their task.
> >> 
> >> That would also allow xt_owner to be used in the input path.
> >> 
> >> Opinions?
> >
> > Hello,
> >
> > That sounds great.
> >
> > Note that the socket match depends on tproxy core, also the tproxy would be
> > partially merged into the net-2.25 tree. [...]
> 
> Here is what I had in mind, please have a look.
> http://dev.computergmbh.de/gitweb.cgi?p=linux;h=dev-xtsocket;a=shortlog

This won't work:

+       sk = nf_tproxy_get_v4(iph->protocol, iph->saddr, iph->daddr,
+                             hp->source, hp->dest, in, false);
+       if (sk != NULL)
+               nf_tproxy_put_sock(sk);
+       return sk;

socket_mt_get() returns a struct sock * without holding a reference for
that pointer.

-- 
KOVACS Krisztian
