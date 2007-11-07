From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 0/3] iptables-edit: tool to apply iptables rules to
 iptables-save'ed statefiles
Date: Wed, 7 Nov 2007 17:37:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711071730310.20249@fbirervta.pbzchgretzou.qr>
References: <472E6039.7060801@endian.com> <Pine.LNX.4.64.0711071148530.1982@fbirervta.pbzchgretzou.qr>
 <4731AE99.8080105@endian.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38484 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbXKGQhl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:37:41 -0500
In-Reply-To: <4731AE99.8080105@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 7 2007 13:24, Peter Warasin wrote:
>Jan Engelhardt wrote:
>> On Nov 5 2007 01:13, Peter Warasin wrote:
>>> Most firewall scripts (for example fwbuilder, shorewall, firehole,
>>> etc..) work always this way:
>> fwbuilder uses (can use) iptables-save.
>
>I see, cool! I missed that one the last time i tried.
>Think i should give it another try.
>
>At the other hand it's a compiler, which rebuilds from scratch, isn't it?.

Yes, like most other compilers (e.g. C/C++) do, it turns a list of
"GUI rules" into implementation-specific (e.g. iptables) commands.
I would not even see why it would have to use iptables-edit (not that
it would be useless, but translators do not need it).

>Another advantage (can also be a disadvantage) is that iptables-edit
>don't rebuild the entire firewall ruleset from scratch, so one can have
>it's manually added iptables rules which then do not disappear after
>next iptables-restore.

GUI progs generally do not support modifying a "running table" (the one the
kernel uses), exactly because you do not know which rules are automatically
generated and which are not. Which is why you will have to add your custom
rules inside the GUI.

