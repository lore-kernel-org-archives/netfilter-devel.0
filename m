From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: Handling Port-Unreachable Response to UDP
Date: Mon, 28 Jul 2003 17:20:34 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0307281716420.11010@dns.toxicfilms.tv>
References: <3F252AAE.7000109@variosecure.net> <1059403723.12254.10.camel@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tim Burress <tim@variosecure.net>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <1059403723.12254.10.camel@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > We're wondering if an appropriate response to this situation would be to
> > destroy the conntrack entry for the UDP connection after receiving the
> > first port-unreachable?
>
> Sounds reasonable to me, but may as you said cause a significant load
> impact on connntrack if this client floods you...
Hmm, how about having a configurable amount of UDP related ICMPs for
retransmision handling, then destroying the conntrack entry.
If we're flooded the packets will not get matched after some threshold
(say 3), and possible retransmissions will get through.

Regards,
Maciej
