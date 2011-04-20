From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 20 Apr 2011 09:54:57 +0100
Message-ID: <4DAE9F61.2010103@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr> <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com> <4DA58A73.9030308@wildgooses.com> <alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr> <4DA59881.1050501@wildgooses.com> <alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr> <4DA5D346.5030303@wildgooses.com> <BANLkTincEe0_Fj89wJecgR5Up7CvS6ERtw@mail.gmail.com> <BANLkTimNc7_XyEoX2usooZLsYyYTn4OnUA@mail.gmail.com> <4DAC67F3.3070503@wildgooses.com> <BANLkTikq_5uRpzZWqRA9-VMT4h2Vxjgvpg@mail.gmail.com> <BANLkTikyT1VOH9aBJ4=LmM5raL2L8Y+46w@mail.gmail.com> <4DADB406.104060
 6@wildgooses.com> <BANLkTi=PqPkDpKu8ej1tCkVNugpecbLHyg@mail.gmail.com> <BANLkTim9Gi-XpwNGZ0RRgtt+PaoRB+Jw0Q@mail.gmail.com> <alpine.DEB.2.00.1104200926210.16821@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:41706 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab1DTIy7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:54:59 -0400
In-Reply-To: <alpine.DEB.2.00.1104200926210.16821@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/04/2011 08:31, Jozsef Kadlecsik wrote:
> The module "ip_set" is loaded in if the "ipset" program is installed and 
> invoked on that system.

Aha, that is almost certainly the cause.  As well as kernel, I had
updated the software image to include ipset/conntrack and didn't connect
the events

I see that I obviously haven't built my image correctly and included the
ip_set module - apologies to the iptables folks - obviously user error
here..

So, in conclusion, with the two patches from Maciej, there is now no
modprobe activity in the event of static iptables and kernel with all
modules built-in.  Perfect

Thanks for everyone's interest in this - superb response

Ed W
