From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH iptables] libxt_length: update to revision 1
Date: Sun, 25 Jul 2010 18:28:37 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007251827200.14790@obet.zrqbmnf.qr>
References: <1279945746-24034-1-git-send-email-xiaosuo@gmail.com>  <alpine.LSU.2.01.1007241055320.9867@obet.zrqbmnf.qr> <AANLkTi=NwJkK1sRb+mNjNO8nr3AA5dymyZ1pTc0dgt_q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57298 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab0GYQ2i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jul 2010 12:28:38 -0400
In-Reply-To: <AANLkTi=NwJkK1sRb+mNjNO8nr3AA5dymyZ1pTc0dgt_q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2010-07-24 13:47, Changli Gao wrote:

>On Sat, Jul 24, 2010 at 4:55 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> On Saturday 2010-07-24 06:29, Changli Gao wrote:
>>
>>>update libxt_length to revision 1 to support ipv6 jumbo frames.
>>
>> You can't just go and change these things, would break xt_length v0.
>>
>
>Hmm. I have updated the patch(attached), but the v0 handlers are not
>called. Is there anything I missed? Or Is there a bug in iptables?

Probably because you are still breaking the compatibility by editing 
struct xt_length_info. I'd say let's concentrate on rev 2 that I 
submitted.
