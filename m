From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_tables: foreachs and reentrancy
Date: Thu, 25 Feb 2010 12:09:39 +0100
Message-ID: <4B865A73.8020804@trash.net>
References: <1265970044-19518-1-git-send-email-jengelh@medozas.de> <4B856498.9040202@trash.net> <alpine.LSU.2.01.1002241952410.3301@obet.zrqbmnf.qr> <4B864FC4.3000201@trash.net> <alpine.LSU.2.01.1002251205280.4362@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64250 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862Ab0BYLJk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:09:40 -0500
In-Reply-To: <alpine.LSU.2.01.1002251205280.4362@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-02-25 11:24, Patrick McHardy wrote:
>>> My intention was to have the entire set merged by 2.6.32, only
>>> delayed by my own tinkering around with the get_cycle measurement of
>>> the data collapse. But it was ready on-time for the 2.6.34 window!
>>> What went wrong? Do we need to begin the merge-into-kabernext window
>>> much earlier?
>> Yes, you should begin submitting patches when net-next opens,
>> usually at -rc1.
> 
> Thanks for clearing this point of doubt up - I was under the
> impression that submissions were only accepted when kaber-next
> opens.

It opens when submissions show up :)
