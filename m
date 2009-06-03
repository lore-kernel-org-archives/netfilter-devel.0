From: Patrick McHardy <kaber@trash.net>
Subject: Re: Avoiding multiple calls to xt_target.checkentry
Date: Wed, 03 Jun 2009 11:25:32 +0200
Message-ID: <4A26418C.5090707@trash.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62138 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZFCJZc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:25:32 -0400
In-Reply-To: <4A1DC798.1090604@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen wrote:
>>> In other words, is there a function only called the first time the rule is
>>> added by iptables?  Or should I be keeping track of that myself?
>> You forget that iptables does not add rules. It replaces entire tables,
>> and to make that atomic, the new table is checked before the old one
>> is released. And yes, you usually try to lookup a led trigger first
>> before creating one, because there can be a table that calls -j LED
>> twice.
> 
> Thanks for the explanation!  So - to get it straight in my mind - the
> checkentry function will be called multiple times while the trigger exists,
> but is the destroy function also called multiple times?  Or is checkentry
> called whenever tables are created, but destroy only ever called once when the
> table is removed for the last time?

They will always be called an equal amount of times - each one
once per target instance.
