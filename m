From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: RFC: net/netfilter reorganization
Date: Tue, 7 Oct 2008 19:09:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810071856010.12399@localhost.localdomain>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu>
 <20081005.132850.34376215.davem@davemloft.net>
 <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net>
 <alpine.LNX.1.10.0810051909430.3354@fbirervta.pbzchgretzou.qr>
 <48E9E368.50901@trash.net> <alpine.LNX.1.10.0810062106260.438@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810071331170.12399@localhost.localdomain>
 <alpine.LNX.1.10.0810071129180.23228@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sam@ravnborg.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2195 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbYJGRJq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:09:46 -0400
In-Reply-To: <alpine.LNX.1.10.0810071129180.23228@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 7 Oct 2008, Jan Engelhardt wrote:

> Nope. A patch as simple as
> 
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -317,7 +317,7 @@ config NETFILTER_XT_TARGET_CLASSIFY
>           To compile it as a module, choose M here.  If unsure, say N.
>  
>  config NETFILTER_XT_TARGET_CONNMARK
> -       tristate  '"CONNMARK" target support'
> +       tristate
>         depends on NF_CONNTRACK
>         depends on NETFILTER_ADVANCED
>         select NF_CONNTRACK_MARK
> 
> nukes TARGET_CONNMARK from .config - as in, there is not even a
> "# TARGET_CONNMARK is unset" line.

That's correct, as it doesn't get any value (either from a default or a 
select). If it has a value, it will be used to select other symbols.

> As such I can understand why adding a "select ELSE" for TARGET_CONNMARK
> won't work.

I don't quite understand what you're trying to do. :)

bye, Roman
