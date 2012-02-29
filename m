From: "Jeremy/starcraft.man" <starcraft.man@ubuntu.com>
Subject: Make nfct_catch return control to original thread
Date: Wed, 29 Feb 2012 09:38:00 -0500
Message-ID: <CA+DcbdcTggNHJS3rCbnVNHejU5Zdb3+fukK_03qB+Y30K7XhxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37359 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab2B2OiA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:38:00 -0500
Received: by ghrr11 with SMTP id r11so830444ghr.19
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Feb 2012 06:38:00 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm a developer currently working at a company using libnetfilter, I
came in late in development of the product and the code is pretty much
complete. Due to debugging checks recently enabled, they want to be
able to unblock and gracefully stop all threads before terminating the
process. The problem then is that the thread which invokes nfct_catch
never returns and blocks the thread from cleanly terminating.

pthread_cancel is not an option since we develop on android and that
platform doesn't stopping threads that way.

I'm not that familiar with netfilter and am still reading up, from
what I've read it doesn't seem like I can. Please correct me if I'm
wrong, but the events that trigger the registered handlers are all
tied to interfaces being new/updated/down and thus I can't just use a
handler that returns NFNL_CB_STOP when it next gets an event (at least
not unless I trigger an event artificially say after setting a boolean
flag in the registered handler to force it to stop). Is there any sort
of signal mechanism I'm missing that could be used to force a return
from the loop of nfnl_catch?

Any help would be appreciated, even if it is to say you can't force
catch to return.

Thanks and have a nice day.

--
Jeremy Pallats/starcraft.man

Beginners Team/Wiki FG Member - https://wiki.ubuntu.com/BeginnersTeam
Wiki Homepage - https://wiki.ubuntu.com/starcraft.man
