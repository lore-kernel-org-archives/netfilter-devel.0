From: Ciaran Deignan <ciaran.deignan@netcelo.com>
Subject: Re: snat and ICMP question
Date: Wed, 09 Oct 2002 13:16:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA4100B.79866BC0@netcelo.com>
References: <3DA30D48.3EA0E56E@netcelo.com> <200210081500.06505.marian@ti.com> <3DA400B9.390A17F7@netcelo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Marian Stagarescu <marian@ti.com>,
	netfilter-devel@lists.netfilter.org,
	Matthieu Marc <matthieu.marc@netcelo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org




> > > iptables -t mangle -A PREROUTING --in-interface ipsec+ \
> > >                         -j MARK --set-mark 1
> > > iptables -t nat -A POSTROUTING -m mark --mark 1 \
> > >                                 -j MASQUERADE
> >

> config. Actually, the web server is on the private interface.
> 
> The ICMP error message contains the real address of the
> remote user. Do you think I should mark ICMP messages
> on the OUTPUT chain? I must try that...

I tried adding the following rule, but that didn't change
anything:

	iptables -t mangle -A OUTPUT -p ICMP -j MARK --set-mark 1

Is there any way I could cause the ICMP error to be
generated before the packet is de-nated?

Ciaran

-- 
+---------------------------------------------------------+
Ciaran Deignan                              04 38 49 87 27

Netcelo SA - IPsec VPN Solutions    http://www.netcelo.com/
18-20 rue Henri Barbusse - BP 2501, 38035 Grenoble Cedex 2
+---------------------------------------------------------+
