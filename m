From: Michael Richardson <mcr@sandelman.ottawa.on.ca>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Tue, 27 Apr 2004 14:58:59 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <19797.1083092339@marajade.sandelman.ottawa.on.ca>
References: <20040415212034.GE7611@obs.bg> <407FE99D.6010100@trash.net>  <20040424101748.GB23401@obs.bg>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: Message from Ivan Mitev <imitev@obs.bg>
   of "Sat, 24 Apr 2004 13:17:49 +0300." <20040424101748.GB23401@obs.bg>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


>>>>> "Ivan" == Ivan Mitev <imitev@obs.bg> writes:
    Ivan> i tried to use the ipsec policy for a transport mode, AH+ESP,
    Ivan> but i don't manage to get it working (ie pkts are not matched
    Ivan> by the ipsec policy rule) however AH or ESP alone work fine.

    Ivan> btw, maybe no one uses AH + ESP, but that's only a test...

  There is really no point in mixing them.
  ESP in RFC2401 IPsec (vs 1827) provides authentication.

--
]       ON HUMILITY: to err is human. To moo, bovine.           |  firewalls  [
]   Michael Richardson,    Xelerance Corporation, Ottawa, ON    |net architect[
] mcr@xelerance.com      http://www.sandelman.ottawa.on.ca/mcr/ |device driver[
] panic("Just another Debian GNU/Linux using, kernel hacking, security guy"); [
