From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: codesize: netfilter/iptables vs. nftables
Date: Tue, 11 Aug 2009 18:53:20 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908111845370.14528@fbirervta.pbzchgretzou.qr>
References: <4A8146C4.5090108@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43974 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbZHKQxV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:53:21 -0400
In-Reply-To: <4A8146C4.5090108@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-08-11 12:24, Christoph A. wrote:
>
>unlike the iptables kernel approach, nftables does not have a 1-to-1
>mapping of matches with modules in the kernel and provides only basic
>functionality/operations, userspace can use to combine to build
>matches/rules. (intelligence moves from kernel to userspace)
>The kernelcode size of nftables would be constant regardless of how many
>matches it supports.
>Is this assumption correct?

Certain fundamentals do require kernel support such as "store this
in the nfmark now" or "store this in the ctmark now". This won't
change. (See Patrick's reply too.)

What iptables currently does is ask the kernel to match on tcp,
but it could very well ask "check byte X in the network header
for 6" to test for tcp. That is what nftables does, and there is
also xt_u32 for iptables.

>Another thing I would like to know is the current codesize of
>netfilter/iptables (including ip6tables and ebtables modules) compared
>to nftables kernelsize (sloc) (although the current featureset may defer)
>
>I compared them like this:
>
>1. step:
>count lines with sloccount in the following directories:
>net/ipv4/netfilter/
>net/ipv6/netfilter/
>net/bridge/netfilter/
>net/netfilter/

With that you would be counting Conntrack and NAT too, which is not
useful in the comparison. And realistically, counting all extensions
too perturbs the statistics, since iptables, right now, _can_ do
more (TPROXY, just to name one).

Hence I counted by

	net/{bridge,ipv4,ipv6,}/netfilter/*tables.c
	net/{bridge,ipv4,ipv6}/netfilter/*table_{filter,raw,security,mangle}.c

Something like that. iptables clocks in at some 9 kLOC IIRC (~5k
after my large consolidation), and nftables somewhere at 2.5k, but
that's only because I have not yet started trimming down ebtables.
