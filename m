From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Fix connlimit bug when receive RST packet in ESTABLISHED
 state
Date: Mon, 2 Jun 2008 16:35:52 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806021634480.4055@fbirervta.pbzchgretzou.qr>
References: <3104bfb60806020422s73c60a29kde8c896e1db901d6@mail.gmail.com> <4843E59C.1030808@trash.net> <alpine.LNX.1.10.0806021428440.4055@fbirervta.pbzchgretzou.qr> <4843EF22.9010207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dong Wei <dwei.zh@gmail.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44567 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYFBOfx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:35:53 -0400
In-Reply-To: <4843EF22.9010207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-06-02 15:01, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Monday 2008-06-02 14:20, Patrick McHardy wrote:
>> > Dong Wei wrote:
>> > > diff -ruN a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
>> > > --- a/net/netfilter/xt_connlimit.c      2008-06-02 18:48:38.000000000
>> > > +0800
>> > > +++ b/net/netfilter/xt_connlimit.c      2008-06-02 18:50:40.000000000
>> > > +0800
>> > > @@ -75,7 +75,8 @@
>> > >         u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;
>> > >
>> > >         if (proto == IPPROTO_TCP)
>> > > -               return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
>> > > +               return (conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT
>> > > +                       || conn->proto.tcp.state == TCP_CONNTRACK_CLOSE);
>> > Looks fine to me. Jan?

Acked-by: Jan Engelhardt <jengelh@medozas.de>
