From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Handling Port-Unreachable Response to UDP
Date: 28 Jul 2003 16:48:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1059403723.12254.10.camel@henrik.marasystems.com>
References: <3F252AAE.7000109@variosecure.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tim Burress <tim@variosecure.net>
In-Reply-To: <3F252AAE.7000109@variosecure.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

m=E5n 2003-07-28 klockan 15.52 skrev Tim Burress:

> We've been looking at a problem in which a client sends a UDP packet to=
=20
> a server on an unused port. This generates an ICMP port-unreachable=20
> packet (as usual), but we find that this same ICMP packet can then be=20
> replayed back to the client over and over. Apparently it gets through=20
> netfilter because our standard rules allow RELATED traffic.

Explain the context of "replayed back to the client over and over".

> We're wondering if an appropriate response to this situation would be t=
o=20
> destroy the conntrack entry for the UDP connection after receiving the=20
> first port-unreachable?

Sounds reasonable to me, but may as you said cause a significant load
impact on connntrack if this client floods you...

--=20
Henrik Nordstrom <hno@marasystems.com>
MARA Systems AB
