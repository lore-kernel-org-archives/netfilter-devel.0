From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: build error when compiling nfsim against 2.6.23.17
Date: Fri, 6 Mar 2009 19:31:44 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903061931280.21430@fbirervta.pbzchgretzou.qr>
References: <ad28918e0903041223t7edb61d3hb479b3ca3c91ed26@mail.gmail.com>  <49AFC4BB.8090102@netfilter.org> <ad28918e0903060902o21e72ae1r65fb7f1680b8e618@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Fred Moyer <fred@redhotpenguin.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45619 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZCFSbs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:31:48 -0500
In-Reply-To: <ad28918e0903060902o21e72ae1r65fb7f1680b8e618@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-03-06 18:02, Fred Moyer wrote:
>On Thu, Mar 5, 2009 at 4:25 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> Fred Moyer wrote:
>>> I'm developing a connection tracking module for the 2.6.23.17 kernel
>>> using the nf_conntrack helper examples (actually porting a nat module
>>> I had for 2.4.30) and am trying to use the nfsim test framework
>>> instead of my previous crude method of sending packets through the
>>> machine.
>>
>> Sorry, nfsim currently lacks of maintainer.
>
>Ok, I'll make an effort to fix that issue and submit a patch.
>
>What is the recommended alternative for testing connection helper modules?

Testing them in a real world - perhaps virtual machines though - setup :-)
