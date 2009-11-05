From: Patrick McHardy <kaber@trash.net>
Subject: Re: Avoiding multiple calls to xt_target.checkentry
Date: Thu, 05 Nov 2009 16:00:53 +0100
Message-ID: <4AF2E8A5.7020409@trash.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38024 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbZKEPAu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 10:00:50 -0500
In-Reply-To: <4A265891.4050201@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen wrote:
>>> Thanks for the explanation!  So - to get it straight in my mind - the
>>> checkentry function will be called multiple times while the trigger
>>> exists,
>>> but is the destroy function also called multiple times?  Or is checkentry
>>> called whenever tables are created, but destroy only ever called once
>>> when the
>>> table is removed for the last time?
>> They will always be called an equal amount of times - each one
>> once per target instance.
> 
> Great, thanks for the info (thanks Jan too!)  I'm working on a patch so I'll
> post it when I think I've solved the issue correctly.

Just wondering whether there's still hope for this issue to get fixed.

I haven't added the LED extension to iptables yet, so if there's no
interest in fixing this, we can remove the LED target again.
