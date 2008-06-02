From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix connlimit bug when receive RST packet in ESTABLISHED
 state
Date: Mon, 02 Jun 2008 14:20:44 +0200
Message-ID: <4843E59C.1030808@trash.net>
References: <3104bfb60806020422s73c60a29kde8c896e1db901d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@computergmbh.de>
To: Dong Wei <dwei.zh@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35122 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYFBMUx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:20:53 -0400
In-Reply-To: <3104bfb60806020422s73c60a29kde8c896e1db901d6@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dong Wei wrote:
> Hi, all
>   In xt_connlimit match module, the counter of an IP is decreased when
> the TCP packet is go through the chain with ip_conntrack state TW.
> Well, it's very natural that the server and client close the socket
> with FIN packet. But when the client/server close the socket with RST
> packet(using so_linger), the counter for this connection still exsit.
> The following patch can fix it which is based on linux-2.6.25.4
> 
> diff -ruN a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
> --- a/net/netfilter/xt_connlimit.c      2008-06-02 18:48:38.000000000 +0800
> +++ b/net/netfilter/xt_connlimit.c      2008-06-02 18:50:40.000000000 +0800
> @@ -75,7 +75,8 @@
>         u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;
> 
>         if (proto == IPPROTO_TCP)
> -               return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
> +               return (conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT
> +                       || conn->proto.tcp.state == TCP_CONNTRACK_CLOSE);

Looks fine to me. Jan?
