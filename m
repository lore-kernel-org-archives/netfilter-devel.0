From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: IPT [PATCH] yay, autotools!
Date: Wed, 28 Nov 2007 13:05:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711281305260.16364@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr>
 <474D2B75.9070301@trash.net> <Pine.LNX.4.64.0711281149100.16364@fbirervta.pbzchgretzou.qr>
 <474D5010.10609@trash.net> <Pine.LNX.4.64.0711281246420.16364@fbirervta.pbzchgretzou.qr>
 <474D57DF.1030002@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60091 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbXK1MFi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:05:38 -0500
In-Reply-To: <474D57DF.1030002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 28 2007 12:58, Patrick McHardy wrote:
>> but *iptables* itself does not use it, does it? in which case
>> libipq should probably move to its own tarball, that is what
>> I was proposing.
>
>
> We could do that I guess, though I'm expecting a bunch of complaints
> from people who are used to get it from the iptables source.
>
>

ok will add libipq to the makefile...
