From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Fri, 15 Aug 2008 21:31:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808152127180.20054@blackhole.kfki.hu>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:43002 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbYHOTbh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:31:37 -0400
In-Reply-To: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sat, 16 Aug 2008, Changli Gao wrote:

> When using iptables to extent the firewall of Linux, I found that: if
> there are more than one kinds of iptables matches, only the former
> options are parsed correctly, but the later options will be treated
> wrongly.
> 
> For example:
> 
> iptables -t mangle -A PREROUTING -m a --mac-source 00:11:22:33:44:55
> -m b --mac-source 00:11:22:33:44:55 -j ACCEPT
> 
> the above command will fail due to the later match.

Yes: you should use match-specific options, like

iptables -t mangle -A PREROUTING -m a --a-mac-source 00:11:22:33:44:55
-m b --b-mac-source 00:11:22:33:44:55 -j ACCEPT
 
> Then I checked the source code of iptables. It seems that the extra
> options for each match are global for each individual command. It is
> out of my exception. I used to think that options are only available
> for that match. So I "fixed" this issues quickly. After patching, the
> command options contain the default global options and the last match
> or the target extra options.

With your patch applied we'd loose supporting multiple matches of the same 
type.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
