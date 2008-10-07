From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Tue, 7 Oct 2008 11:30:38 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810071129180.23228@fbirervta.pbzchgretzou.qr>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu> <20081005.132850.34376215.davem@davemloft.net> <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net> <alpine.LNX.1.10.0810051909430.3354@fbirervta.pbzchgretzou.qr> <48E9E368.50901@trash.net>
 <alpine.LNX.1.10.0810062106260.438@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810071331170.12399@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sam@ravnborg.org
To: Roman Zippel <zippel@linux-m68k.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45367 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYJGPak (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:30:40 -0400
In-Reply-To: <Pine.LNX.4.64.0810071331170.12399@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-10-07 07:34, Roman Zippel wrote:
>> 
>> Seems like config options without a one-line text are considered 
>> nonexistent for kconfig to begin with, so that nothing can depend or 
>> default on these.
>
>Not really. If one of these two symbols has a value different than 'n', it 
>should should also select BOTH_CTMARK. I did a quick test and I still get 
>the expected behaviour, so there is something else...
>
Nope. A patch as simple as

--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -317,7 +317,7 @@ config NETFILTER_XT_TARGET_CLASSIFY
          To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_CONNMARK
-       tristate  '"CONNMARK" target support'
+       tristate
        depends on NF_CONNTRACK
        depends on NETFILTER_ADVANCED
        select NF_CONNTRACK_MARK

nukes TARGET_CONNMARK from .config - as in, there is not even a
"# TARGET_CONNMARK is unset" line.
As such I can understand why adding a "select ELSE" for TARGET_CONNMARK
won't work.
