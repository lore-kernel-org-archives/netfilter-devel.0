From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Accessing packet marking functions
Date: Mon, 28 Jun 2010 23:45:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006282345150.6939@obet.zrqbmnf.qr>
References: <1276965739.1476.35.camel@andybev>  <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>  <1277032613.1476.93.camel@andybev>  <alpine.LSU.2.01.1006201351490.23203@obet.zrqbmnf.qr>  <1277037072.1476.107.camel@andybev>  <4C205543.9080902@trash.net>
 <1277760075.1433.7.camel@andybev>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46069 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab0F1Vpf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:45:35 -0400
In-Reply-To: <1277760075.1433.7.camel@andybev>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-06-28 23:21, Andrew Beverley wrote:

>> > The problem is that Squid normally runs as a non-privileged user (I had
>> > to remove the root checks from the code to get it to run as root). Is
>> > there any way to mark packets when not root? Or is the only way to make
>> > this work to run a small part of Squid as root?
>> 
>> enter_suid()/leave_suid().
>
>Thanks, although in the end I have decided to try and use the
>CAP_NET_ADMIN capability flag instead, to keep the use of root to a
>minimum.

Hey, I've you're thatmuch worried, you'd be using selinux ;-)
