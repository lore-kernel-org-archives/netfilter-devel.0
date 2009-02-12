From: Patrick McHardy <kaber@trash.net>
Subject: Re: pull request
Date: Thu, 12 Feb 2009 06:11:42 +0100
Message-ID: <4993AF8E.7040200@trash.net>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de> <4992E97C.5050508@trash.net> <alpine.LSU.2.00.0902111644260.20223@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0902120037240.20800@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39802 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZBLFLq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:11:46 -0500
In-Reply-To: <alpine.LSU.2.00.0902120037240.20800@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-02-11 16:45, Jan Engelhardt wrote:
>> On Wednesday 2009-02-11 16:06, Patrick McHardy wrote:
>>> How do these interact with the Jamal's pending changes?
>> I think it should be fine as I am changing just the periphery here.
>> If it merges without git-pull stopping, after you applied his,
>> it's probably ok :)
>>
> OTOH, I suggest you could do it like Linus [states in his Git
> presentation at Google], that is, merging whatever happens to be
> first in the mailbox. I think that the statistical distribution
> is equal anyway.

Thats why I'm asking. He was first so it would only be fair to
apply his patches first. Your's are more though so might be more
work to fix up. The easiest way might be if you apply Jamal's
patches and I simply pull everything from you. You seem to have
more remarks about these patches than me anyways :)
