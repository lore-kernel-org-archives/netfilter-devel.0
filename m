From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: Avoiding multiple calls to xt_target.checkentry
Date: Thu, 28 May 2009 09:07:04 +1000
Message-ID: <4A1DC798.1090604@shikadi.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:4796 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZE0XHF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 19:07:05 -0400
In-Reply-To: <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> In other words, is there a function only called the first time the rule is
>> added by iptables?  Or should I be keeping track of that myself?
> 
> You forget that iptables does not add rules. It replaces entire tables,
> and to make that atomic, the new table is checked before the old one
> is released. And yes, you usually try to lookup a led trigger first
> before creating one, because there can be a table that calls -j LED
> twice.

Thanks for the explanation!  So - to get it straight in my mind - the
checkentry function will be called multiple times while the trigger exists,
but is the destroy function also called multiple times?  Or is checkentry
called whenever tables are created, but destroy only ever called once when the
table is removed for the last time?

Just trying to work out whether I need to avoid removing the LED trigger in
the destroy function as well.

Thanks again,
Adam.

