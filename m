From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [netfilter-core] memory leak with IP connection tracking and
	IP forwarding
Date: Wed, 09 Jun 2004 17:05:09 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <1086793508.1785.21.camel@nienna.balabit>
References: <200405041305.55627.tspat@de.ibm.com>
	 <200405041602.26635.tspat@de.ibm.com>
	 <20040517071453.GE26147@obroa-skai.de.gnumonks.org>
	 <200405180829.10869.tspat@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <linux-net-owner@vger.kernel.org>
To: tspat@gmx.de
In-Reply-To: <200405180829.10869.tspat@de.ibm.com>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-05-18, k keltez=E9ssel 08:29-kor Thomas Spatzier ezt =EDrta:
> > > On the router I issue a 'watch -n 1 cat /proc/meminfo'.
> > > Then I do a 'ping -f -s 64000' from one host to another host via =
the
> > > router. On each update of my watch above there are about 10 MB of=
 memory
> > > (MemFree) missing.

  I've tried to reproduce this with 2.4.25 and 2.6.6, but couldn't find
any leaks... Can you tell me something more specific about your kernel
config and the ruleset on the firewall? Can you reproduce the same with
ip_conntrack loaded but without any iptables rules?

--=20
 Regards,
   Krisztian KOVACS

