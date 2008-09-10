From: Patrick McHardy <kaber@trash.net>
Subject: Re: Alignment problem with ebt_among
Date: Wed, 10 Sep 2008 16:23:06 +0200
Message-ID: <48C7D84A.2010703@trash.net>
References: <alpine.LNX.1.10.0809100931120.24942@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	David Miller <davem@davemloft.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39298 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYIJOXL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:23:11 -0400
In-Reply-To: <alpine.LNX.1.10.0809100931120.24942@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> But due to continued lack of alignment of the entire thing (e.g. 
> EBT_ALIGN(, I cannot rule out that
> alignment-sensitive architectures like sparc64 continue choke on it.
> (Due to lack of such machines, I am unable to test)
> 
> What we would need is, IMO,
> 
> 	new_size = old_size + EBT_ALIGN(ebt_mac_wormhash_size(wh);
> 	h = malloc(new_size);
> 
> but this of course breaks the binary interface between userspace and
> kernel. Possible solutions I can think of:
> 
> 	(a) kill ebt_among
> 	(b) willingly change it and break ABI
> 	(c) continue planned transformation to Xtables and fix later
> 
> Which should it be?

How about:

(d) add compat support to ebtables, transform to xtables,
     add compat translation

Compat support is needed anyway to properly run in a mixed
environment since most of the setsockopt argument structs
are not clean either.
