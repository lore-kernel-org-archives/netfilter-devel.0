From: Andrew Beverley <andy@andybev.com>
Subject: Re: Accessing packet marking functions
Date: Mon, 28 Jun 2010 22:21:15 +0100
Message-ID: <1277760075.1433.7.camel@andybev>
References: <1276965739.1476.35.camel@andybev>
	 <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
	 <1277032613.1476.93.camel@andybev>
	 <alpine.LSU.2.01.1006201351490.23203@obet.zrqbmnf.qr>
	 <1277037072.1476.107.camel@andybev>  <4C205543.9080902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:60746 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0F1VVa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:21:30 -0400
In-Reply-To: <4C205543.9080902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> > The problem is that Squid normally runs as a non-privileged user (I had
> > to remove the root checks from the code to get it to run as root). Is
> > there any way to mark packets when not root? Or is the only way to make
> > this work to run a small part of Squid as root?
> 
> 
> enter_suid()/leave_suid().

Thanks, although in the end I have decided to try and use the
CAP_NET_ADMIN capability flag instead, to keep the use of root to a
minimum.

Cheers,

Andy


