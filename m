From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: scrubbing support in Netfilter
Date: Wed, 28 May 2008 09:27:43 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805280923220.12937@fbirervta.pbzchgretzou.qr>
References: <87hccjdbm4.fsf@chdir.org> <alpine.LNX.1.10.0805271729350.12937@fbirervta.pbzchgretzou.qr> <87hccinbco.fsf@chdir.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Nicolas Bareil <nico@chdir.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58690 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYE1H1o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2008 03:27:44 -0400
In-Reply-To: <87hccinbco.fsf@chdir.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-05-28 09:20, Nicolas Bareil wrote:
>>>  - Random IP ID
>>>  - Zeroify ToS
>>
>> Zeroify? Clearing the TOS is probably not a good idea because
>> it defeats packet scheduling (if it uses TOS).
>
>Correct me if I'm wrong, but on Internet (I mean, just after the first
>ISP's router), the ToS is not used or even looked up.

I was not even thinking about the ISP using TOS, or the remote side,
to address Patrick's concern that some ISP possibly zero it.

The TOS field may very well by an internal network (i.e. campus) and
you could run into a situation where there is a Linux gateway with
(xt_SCRUB) enabled, and another gateway after it (which _really_
connects to the ISP) that actually uses TOS for packet scheduling on
the (perhaps slower) link towards the ISP.

SSH does set IPTOS_LOWDELAY for interactive sessions and clears it
for bulk transfers (e.g. rsync), so there is definitely value for it
within your own realm. I was not e
