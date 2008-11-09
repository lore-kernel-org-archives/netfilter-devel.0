From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH 2/2] New netfilter target to trigger LED devices
Date: Mon, 10 Nov 2008 07:44:03 +1000
Message-ID: <491759A3.1010209@shikadi.net>
References: <4916E4F0.8010507@shikadi.net> <20081109171039.GA3287@x200.localdomain> <alpine.LNX.1.10.0811091839580.22255@fbirervta.pbzchgretzou.qr> <20081109175819.GA3127@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org,
	Richard Purdie <rpurdie@openedhand.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:3966 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbYKIVoI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:44:08 -0500
In-Reply-To: <20081109175819.GA3127@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>> +	/*noconst*/struct xt_led_info_internal *ledinternal =
>>>>                        ledinfo->internal_data;
>>> 	  ^^^^^^^
>>> What is this?
>> A C89-style comment?
> 
> I'm talking about noconst. Utterly pointless.

It's to highlight the parts of my code where I'm taking a
const pointer, and then modifying the data pointed to.  I'm
not sure whether this is allowed, so I thought I'd play
it safe and flag that part of the code for comment.

If you think it's fine as is then I'd be happy to remove
the comment, unless it might be helpful to explain to
others that what I'm doing is intentional.

Cheers,
Adam.

