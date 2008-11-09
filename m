From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] New netfilter target to trigger LED devices
Date: Sun, 9 Nov 2008 18:40:39 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811091839580.22255@fbirervta.pbzchgretzou.qr>
References: <4916E4F0.8010507@shikadi.net> <20081109171039.GA3287@x200.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
	netfilter-devel@vger.kernel.org,
	Richard Purdie <rpurdie@openedhand.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36674 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbYKIRkl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2008 12:40:41 -0500
In-Reply-To: <20081109171039.GA3287@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-11-09 18:10, Alexey Dobriyan wrote:

>On Sun, Nov 09, 2008 at 11:26:08PM +1000, Adam Nielsen wrote:
>> +	/*noconst*/struct xt_led_info_internal *ledinternal =
>>                        ledinfo->internal_data;
>	  ^^^^^^^
>What is this?

A C89-style comment?
