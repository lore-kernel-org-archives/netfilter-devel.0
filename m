From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] xtables: deactivate intrapositional support
Date: Tue, 03 Nov 2009 19:39:14 +0100
Message-ID: <4AF078D2.9050601@trash.net>
References: <1256891969-18437-1-git-send-email-jengelh@medozas.de> <1256891969-18437-3-git-send-email-jengelh@medozas.de> <4AEF0636.6010604@trash.net> <alpine.LSU.2.00.0911021958480.18000@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Netfilter Core Team <coreteam@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50866 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZKCSjR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:39:17 -0500
In-Reply-To: <alpine.LSU.2.00.0911021958480.18000@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-11-02 17:17, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> In going to fix NF bug #611, "argv" would be needed in
>>> xtables_check_inverse to set "optarg" to the right spot in case of an
>>> intrapositional negation. Adding argv to the parameter list would
>>> cause an API change, which I would like to avoid because it is
>>> planned to be thrown out anyway.
>>>
>>> So deactive intrapositional support now already, but leave the error
>>> message (which has already been there for two releases). Slightly
>>> adjust it, because some users have been wondering whether iptables
>>> or they are at "fault".
>> I'm worried that this is too early, two releases is not particulary
>> long and I'd expect a lot of people haven't noticed the warning yet,
>> especially on headless systems. Looking at bug #611, we've never
>> claimed "-ptcp" would be supported, so this hardly justifies the
>> risk IMO.
>>
>> At least this needs more discussion, I'd like to hear a few more
>> opinions on this.
>>
> Given the ultimate shortage of developers on NF these days, I am unsure 
> there are that many opinions left.

I was unaware that there's an urgent need to add incompatibilities.

