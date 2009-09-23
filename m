From: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>
Subject: Re: xtables-addons ACCOUNT - userspace
Date: Wed, 23 Sep 2009 22:11:27 +0200 (MEST)
Message-ID: <alpine.LNX.2.00.0909232154500.25578@cedric.unob.cz>
References: <4ABA69F3.9010907@ttx.sk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-660600280-524277951-1253735746=:25578"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?Vlado_Dr=B8=EDk?= <vlado@ttx.sk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cedric.unob.cz ([160.216.40.10]:46835 "EHLO cedric.unob.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbZIWULf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Sep 2009 16:11:35 -0400
In-Reply-To: <4ABA69F3.9010907@ttx.sk>
Content-ID: <alpine.LNX.2.00.0909232156270.25578@cedric.unob.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---660600280-524277951-1253735746=:25578
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.0909232156271.25578@cedric.unob.cz>


Hello Vlado,

I'm glad you find it useful, like me.

I've originally submitted my ports of

   xt_ACCOUNT ( _including_ the userspace iptaccount tool )
   xt_pknock ( with improved functionality over ipt_pknock 0.5 )
   xt_stealth

for inclusion to xtables-addons (Xt-a) few weeks ago. So far Jan 
Engelhardt, its maintainer, has added just the kernel part of ACCOUNT
to Xt-a, perhaps due to lack of time and becouse he probably didnt want
to delay release of Xt-a 1.18 .

You may try to ask him about the current status of adding iptaccount
as well as the other modules I "ported" (I'm looking forward to this too).

>From what I know the troublesome part is that I didnt do the ports
in git, so he will need to pluck apart all my changes and stuff it
into git as separate commits. (Next time - if there will be such time
- I wont make this mistake again).

In the meantime, you may find the patch against Xt-a 1.17 containing
all the three above at:

     ftp://ftp.unob.cz/pub/linux/patches/xtables-addons/

, and each of these in a form of separate patches against Xt-a 1.17 here:

     http://www.spinics.net/lists/netfilter-devel/msg10340.html

Best regards,

Jan


On Wed, 23 Sep 2009, Vlado Dr¸ík wrote:

> Hello Jan,
>
> I've noticed that you are the one who is behind porting the ACCOUNT
> module to xtables-addons framework.
> I'd like to thank you for this work. It's great extension that will
> surely benefit from this work as less effort will be needed in future
> for maintaining compatibility.
> Kernel and iptables part is workig for me (at least I'm able to craete a
> rule in iptables) but I'm not able to read state from this module via
> iptaccount command line utility (seems that protocol changed or
> something like that) and compiling the library against this new
> infrastructure seems not to be so trivial for me.
>
> So I wanted to ask you if you already have this part working.
>
> Thanks,
> Vlado
>
---660600280-524277951-1253735746=:25578--
