From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: UDP entries do not list ctstate
Date: Tue, 19 Feb 2008 01:39:56 +0100
Message-ID: <47BA255C.1080801@netfilter.org>
References: <Pine.LNX.4.64.0802190111280.26274@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41887 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759606AbYBSAkE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:40:04 -0500
In-Reply-To: <Pine.LNX.4.64.0802190111280.26274@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Jan Engelhardt wrote:
> to figure out what Netfilter actually does, we add a rule to match 
> incoming DNS replies for demonstrational purposes:
> 
> 	iptables -I INPUT -p udp --sport 53 -m conntrack --ctstate 
> 	ESTABLISHED
> 
> as one would expect, ESTABLISHED matches. Now, after the DNS reply has 
> been received, running `conntrack -L | grep udp` does not show the 
> string "ESTABLISHED" at all, even if I run it within the UDP conntrack 
> timeout. Glitch/Bug in /usr/sbin/conntrack?

The output is compatible with /proc/net/ip_conntrack which doesn't show
the generic states for UDP. Instead, it shows the flag assured when we
have seen traffic in both directions.

BTW, you can also `use conntrack -L -p udp' to filter so you don't need
to use grep for this particular case.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
