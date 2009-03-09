From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: module testing practices [was Re: build error when compiling
 nfsim  against 2.6.23.17]
Date: Mon, 9 Mar 2009 23:56:40 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903092355590.26534@fbirervta.pbzchgretzou.qr>
References: <ad28918e0903091536r6d35cbf7ncf9ac0e74ed6dffb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Fred Moyer <fred@redhotpenguin.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47656 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZCIW4o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:56:44 -0400
In-Reply-To: <ad28918e0903091536r6d35cbf7ncf9ac0e74ed6dffb@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-03-09 23:36, Fred Moyer wrote:
>>
>> At least VMware Workstation has the Snapshot feature which cuts the
>> "reboot" time down to whatever it takes to reread the disk image from disk.
>>
>> Avoiding oopses is the best strategy, at which point you can reedit-
>> compile-reload the module as often as you need without reverting to
>> a snapshot.
>
>In the event of an oops, do you have any suggestions for capturing the
>stacktrace?  My vmware terminal console is 25 rows with no scrollback
>when it oopses, so I'm only getting half the stack.
>
Boot with vga=6 to get 50 lines, or 'console=ttyS0 console=tty0' to get
it all via serial.
