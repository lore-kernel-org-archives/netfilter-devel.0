From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [xtables-addons] extensions in a non-modular kernel
Date: Tue, 8 Dec 2009 10:59:49 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912081057250.15262@obet.zrqbmnf.qr>
References: <6fbd78aa0912030254p2382b23do6bc7a8700a013e47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Wiktor Kolodziej <wiktor@zhr.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55765 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbZLHJ7n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:59:43 -0500
In-Reply-To: <6fbd78aa0912030254p2382b23do6bc7a8700a013e47@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2009-12-03 11:54, Wiktor Kolodziej wrote:

>Is there any easy way to compile extensions into a non-modular kernel?

Depends on the definition of easy.

>I've found in Jan's "An Introduction to Xtables-addons" that this is
>possible, but can you please give me some more info how to do it?
>What do you mean by "editing some kernel Makefile to descend into
>xtables-addons/extensions" ?

ln -s ~/xtables-addons ~/linux/net/netfilter/
echo "obj-y += xtables-addons/extensions/" 
	>>~/linux/net/netfilter/Makefile

Granted it does not stop there, one needs to modify extensions/Kbuild 
because it depends on symbols from mconfig (oh my) which would need to
be exchanged to obj-y or something.

