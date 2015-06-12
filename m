From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv4 3/3] netfilter: bridge: detect NAT66 correctly and
 change MAC address
Date: Fri, 12 Jun 2015 14:25:32 +0200
Message-ID: <20150612122532.GC13530@salvia>
References: <1432992460-4057-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de, Sven Eckelmann <sven@open-mesh.com>
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55564 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbbFLMUS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:20:18 -0400
Content-Disposition: inline
In-Reply-To: <1432992460-4057-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 30, 2015 at 03:27:40PM +0200, Bernhard Thaler wrote:
> IPv4 iptables allows to REDIRECT/DNAT/SNAT any traffic over a bridge.
> 
> e.g. REDIRECT
> $ sysctl -w net.bridge.bridge-nf-call-iptables=1
> $ iptables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 \
>   -j REDIRECT --to-ports 81
> 
> This does not work with ip6tables on a bridge in NAT66 scenario
> because the REDIRECT/DNAT/SNAT is not correctly detected.
> 
> The bridge pre-routing (finish) netfilter hook has to check for a possible
> redirect and then fix the destination mac address. This allows to use the
> ip6tables rules for local REDIRECT/DNAT/SNAT REDIRECT similar to the IPv4
> iptables version.
> 
> e.g. REDIRECT
> $ sysctl -w net.bridge.bridge-nf-call-ip6tables=1
> $ ip6tables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 \
>   -j REDIRECT --to-ports 81
> 
> This patch makes it possible to use IPv6 NAT66 on a bridge. It was tested
> on a bridge with two interfaces using SNAT/DNAT NAT66 rules.

Applied, thanks.

