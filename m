From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 4/4] netfilter: xtables: schedule xt_state for removal
Date: Thu, 25 Mar 2010 11:17:38 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1003251109190.21938@blackhole.kfki.hu>
References: <1269377101-13875-1-git-send-email-jengelh@medozas.de> <1269377101-13875-5-git-send-email-jengelh@medozas.de> <4BAA2969.8010106@trash.net> <alpine.LSU.2.01.1003241616120.20299@obet.zrqbmnf.qr> <4BAB359F.6030308@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:40282 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab0CYKRj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:17:39 -0400
In-Reply-To: <4BAB359F.6030308@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 25 Mar 2010, Patrick McHardy wrote:

> Jan Engelhardt wrote:
> > On Wednesday 2010-03-24 16:02, Patrick McHardy wrote:
> >> Jan Engelhardt wrote:
> >>> xt_conntrack has been provided since v2.5.32.
> >>>   
> >> I'm fine with the removal of old revisions, but how are you planning on
> >> informing users about removal of this module? Most people don't read
> >> feature-removal-schedule, and distributions are unable to help with
> >> user written scripts.
> > 
> > I would suggest to do the same as we did with disallowing DROP in the 
> > nat table:
> > 
> >  - a message printed by iptables whenever -m state is used
> > 
> >  - a kernel message whenever whenever a rule with xt_state is created
> > 
> > We did not actually do the kernel side with nat-prohibit-DROP, but I
> > regard it as very useful, as the community was very much able to help
> > itself if only they got the word - and it turned out that dmesg is
> > _the_ place people look in especially when they don't supervise
> > iptables output directly, as with, for example, boot splash where
> > messages are hidden, or server/router devices that one tends to
> > forget about.
> 
> Yes, a kernel message sounds fine and less annoying than an
> iptables message since we can limit it to print only once.
> 
> I'm not really convinced of removing state though, I has never
> caused any maintenance overhead, it requires a lot less memory
> than xt_conntrack and it seems more intuitive to write "-m state"
> than "-m conntrack --ctstate" to me.

I oppose the removal of xt_state, *unless* the userspace "-m state" is 
kept working and the conntrack module automatically supports it.

It's such a basic match that it's simply overkill to remove it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
