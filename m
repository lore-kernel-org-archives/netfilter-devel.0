From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: xt_RAWNAT target idea
Date: Mon, 14 Jan 2008 15:39:06 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801141532210.12915@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
 <478AFB75.7040701@trash.net> <Pine.LNX.4.64.0801140944000.10906@fbirervta.pbzchgretzou.qr>
 <478B310A.3040300@trash.net> <Pine.LNX.4.64.0801141347190.10906@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:36697 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbYANPLD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:11:03 -0500
In-Reply-To: <Pine.LNX.4.64.0801141347190.10906@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Mon, 14 Jan 2008, Jan Engelhardt wrote:

> > Another issue is IPv6 support. Everyone agrees that we don't
> > want to support IPv6 NAT. So this would have to be removed.
> 
> There is a need for IPv6 (conntrackful) NAT actually, just like there is 
> for DHCPv6. Hiding hosts (you want websites to know how many devices you 
> have?) or when your ISP runs a pay-per-address model.

DHCPv6 is a useful thing but IPv6 NAT is evil. (IPv4) NAT was introduced 
to address (i.e. slow down) the depletion of the IPv4 address space. 
There is simply no need for such a hack for IPv6.

If someone wants to hide hosts then run a proxy.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
