From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH 2/2] New netfilter target to trigger LED devices
Date: Sun, 09 Nov 2008 23:42:00 +1000
Message-ID: <4916E8A8.4060505@shikadi.net>
References: <4916E4F0.8010507@shikadi.net> <alpine.LNX.1.10.0811091429280.12658@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Richard Purdie <rpurdie@openedhand.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:4206 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbYKINmF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:42:05 -0500
In-Reply-To: <alpine.LNX.1.10.0811091429280.12658@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Looks good :)

Thanks for the quick feedback!  I'll fix up those issues and
resubmit after a good night's sleep :-)

> Though I wonder when I will ever have a desktop PC with LEDs
> driven by the led subsystem...

Actually what prompted this was a USB driver I'm working on
which implements a LED device, and I wanted something more
interesting to test it with :-)  Now I'm wondering how hard
it would be to tie the input subsystem in with it - I don't
use my scroll lock LED for anything at the moment...

Cheers,
Adam.
