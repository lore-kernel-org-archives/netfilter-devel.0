From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 10/13] TProxy: added IPv6 socket lookup function to
 nf_tproxy_core
Date: Tue, 22 Sep 2009 10:30:22 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909221029560.22568@obet.zrqbmnf.qr>
References: <1253548005.12519.10.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Balazs Scheidler <bazsi@balabit.hu>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1253548005.12519.10.camel@bzorp.balabit>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Monday 2009-08-24 14:51, Balazs Scheidler wrote:
>+		case NFT_LOOKUP_LISTENER:
>+			sk = inet6_lookup_listener(net, &tcp_hashinfo,
>+                                                   daddr, ntohs(dport),
>+                                                   in->ifindex);
>+
>+                        /* NOTE: we return listeners even if bound to
>+                         * 0.0.0.0, those are filtered out in

s/0.0.0.0/::/g  :-)
