From: Aijaz Baig <aijazbaig1@gmail.com>
Subject: help needed with EXPORT_SYMBOL
Date: Sat, 21 Aug 2010 12:27:14 +0530
Message-ID: <1282373834.4080.79.camel@aijazbaig1-desktop>
Reply-To: aijazbaig1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:53174 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0HUG5W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Aug 2010 02:57:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Ive been trying to EXPORT a SYMBOL from a netfilter module (actually a
hook) to the KERNEL. Various modules seem to export various symbols to
the kernel (or so it seems), an example being x_tables which exports a
whole lot of functions like xt_register_target and so on and all other
netfilter modules which use these functions dont seem to have any
problems.

So why is it that when my netfilter module is exporting something to the
kernel and im tryin to use it from within a core kernel file, the
compiler flags a 'undefined reference to' error?

I googled and came to the conclusion from the kernelnewbies mailing list
that using kallsyms_lookup() seems to be the answer or is it?
So, if I do intend to use kallsyms_lookup how do I use it? There aren't
so many instances of it being used it seems.
 
Ive seen it being used in dev/core.c like so:
symname = kallsyms_lookup((unsigned long)sym, &symsize,&offset,&modname,
namebuf);

I am basically trying to call a function that MY module EXPORTs inside
one of the core linux routines. This would also mean that my netfilter
module must be compiled (and linked also maybe?..not so sound with link
time stuff) before the address becomes visible so that kallsyms_lookup
can find it. So do I really shd be using it and if so, how?

Any input is appreciated.

Regards,
Aijaz Baig.



