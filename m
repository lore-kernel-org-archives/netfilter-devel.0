From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] goto port to ipv6
Date: Mon, 18 Apr 2005 06:28:08 +0000
Message-ID: <42635378.6050002@outerspace.dyndns.org>
References: <425CD235.7060909@outerspace.dyndns.org>	<4262E109.2010804@trash.net>	<Pine.LNX.4.61.0504180304580.4321@filer.marasystems.com>
	<426310E5.2030207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <426310E5.2030207@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Patrick McHardy on 2005-04-18 01:44 UTC:

> But it's a useful feature. If this was the only reason, I think we
> should submit it for both IPv4 and IPv6.

What's your opinion of my fix included in this IPv6 port (which I fixed
for IPv4 separately and Harald accepted last friday) to indicate "goto"
targets in iptables -L listings with a [goto] in the match extension part?

One alternative could be adding some special character(s) around the
jump target itself, like *SUBCHAIN or SUBCHAIN* or ->SUBCHAIN or
something.. Also I have no idea whether one should consider the output
possibly being used by scripts etc, so I'd appreciate if people could
give their opinion on this (before it goes upstream :) ..

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCY1N3xyF48ZTvn+4RAugMAJ9MWEACo1ybJIKs4p2Fr7hT/n1EHwCeLc4T
wnNUQ7dzH231Extu+SK0YrY=
=t9Wg
-----END PGP SIGNATURE-----
