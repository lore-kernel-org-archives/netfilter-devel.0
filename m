From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: schedule xt_state for removal
Date: Thu, 25 Mar 2010 19:51:02 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003251943140.23164@obet.zrqbmnf.qr>
References: <1269377101-13875-1-git-send-email-jengelh@medozas.de> <1269377101-13875-5-git-send-email-jengelh@medozas.de> <4BAA2969.8010106@trash.net> <alpine.LSU.2.01.1003241616120.20299@obet.zrqbmnf.qr> <4BAB359F.6030308@trash.net>
 <alpine.DEB.2.00.1003251109190.21938@blackhole.kfki.hu> <4BAB3A51.3060001@trash.net> <alpine.LSU.2.01.1003251335270.27347@obet.zrqbmnf.qr> <alpine.DEB.2.00.1003251339180.22672@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58502 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab0CYSvE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:51:04 -0400
In-Reply-To: <alpine.DEB.2.00.1003251339180.22672@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-03-25 13:43, Jozsef Kadlecsik wrote:
>> >>>
>> >>> I'm not really convinced of removing state though, I has never
>> >>> caused any maintenance overhead, it requires a lot less memory
>> >>> than xt_conntrack
>> 
>> And yet, you proposed removing xt_NOTRACK in favor of xt_CT where the
>> same argument about memory tradeoff would hold.
>
>Just my thoughts: xt_NOTRACK is not so widely used than xt_state. So 
>it'll bite less (and hopefully more experienced) users.

Well that's why we would have a warning messages. It is not rocket
science to switch "-m state --state" to "-m conntrack --ctstate"
(well, a necessary prerequisite is to know how to use a text editor).
And users who _do write_ their own surely are of the more experienced
category than those who don't do it at all but are fed by the
distro's generator.

>> >>> and it seems more intuitive to write "-m state"
>> >>> than "-m conntrack --ctstate" to me.
>> >> 
>> >> I oppose the removal of xt_state, *unless* the userspace "-m state" is 
>> >> kept working and the conntrack module automatically supports it.
>> >
>> >Yes, that would be acceptable.
>> >
>> >> It's such a basic match that it's simply overkill to remove it.
>> >
>> >Agreed.
>> 
>> So what now? Should xt_conntrack be perhaps rebranded as a new
>> xt_state rev and let's obsolete xt_conntrack.c instead?
>
>That's much more acceptable, also because of the usage patterns. And the 
>migration can be made easier with module aliasing.
>
>Best regards,
>Jozsef
>-
>E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
>PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
>Address : KFKI Research Institute for Particle and Nuclear Physics
>          H-1525 Budapest 114, POB. 49, Hungary
>

