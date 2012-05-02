From: "Jeremy/starcraft.man" <starcraft.man@ubuntu.com>
Subject: Re: Make nfct_catch return control to original thread
Date: Wed, 2 May 2012 14:34:41 -0400
Message-ID: <CA+DcbdfXLQ2ugNO2iO2hX9Bo25r9Z8_55e7XKRpq-UEV+NV6og@mail.gmail.com>
References: <CA+DcbdcTggNHJS3rCbnVNHejU5Zdb3+fukK_03qB+Y30K7XhxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55724 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab2EBSem (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 May 2012 14:34:42 -0400
Received: by vcqp1 with SMTP id p1so687689vcq.19
        for <netfilter-devel@vger.kernel.org>; Wed, 02 May 2012 11:34:41 -0700 (PDT)
In-Reply-To: <CA+DcbdcTggNHJS3rCbnVNHejU5Zdb3+fukK_03qB+Y30K7XhxA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Quick question regarding conntrack.

Is there a way for me to generate an NFCT_T_DESTROY event artificially
(i.e. avoiding usual mechanism tied to connection close). To further
qualify, I'd like to be able to do this in a situation I can't
guarantee any connectivity. I tried a localhost connection/termination
it didn't seem to trigger a callback.

I want to force a return on a callback that is set on destroy events
if you are wondering.

Thanks for the time.

--
Jeremy Pallats/starcraft.man

Beginners Team/Wiki FG Member - https://wiki.ubuntu.com/BeginnersTeam
Wiki Homepage - https://wiki.ubuntu.com/starcraft.man
