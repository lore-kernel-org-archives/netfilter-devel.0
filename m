From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Avoiding multiple calls to xt_target.checkentry
Date: Thu, 28 May 2009 23:06:14 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905282300360.5070@fbirervta.pbzchgretzou.qr>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60106 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689AbZE1VGO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2009 17:06:14 -0400
In-Reply-To: <4A1DC798.1090604@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2009-05-28 01:07, Adam Nielsen wrote:

>>> In other words, is there a function only called the first time the rule is
>>> added by iptables?  Or should I be keeping track of that myself?
>> 
>> You forget that iptables does not add rules. It replaces entire tables,
>> and to make that atomic, the new table is checked before the old one
>> is released. And yes, you usually try to lookup a led trigger first
>> before creating one, because there can be a table that calls -j LED
>> twice.
>
>Thanks for the explanation!  So - to get it straight in my mind - the
>checkentry function will be called multiple times while the trigger exists,
>but is the destroy function also called multiple times?  Or is checkentry
>called whenever tables are created, but destroy only ever called once when the
>table is removed for the last time?

old table         new table           new table 2
==================================================
(is in place)
                  checkentry
                  (put into place)
destroy
                                      checkentry
                                      (put into place)
                  destroy

>
>Just trying to work out whether I need to avoid removing the LED trigger in
>the destroy function as well.

Yes, as destroy can - and usually is - called after a new table has
ran through checkentry. With the use of some sort of refcounting, it's
easy: checkentry upps it, and destroy downs it. If the refcount goes to zero,
remove the trigger.
