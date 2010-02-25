From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ip_tables: foreachs and reentrancy
Date: Thu, 25 Feb 2010 12:07:50 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002251205280.4362@obet.zrqbmnf.qr>
References: <1265970044-19518-1-git-send-email-jengelh@medozas.de> <4B856498.9040202@trash.net> <alpine.LSU.2.01.1002241952410.3301@obet.zrqbmnf.qr> <4B864FC4.3000201@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35079 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459Ab0BYLHv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:07:51 -0500
In-Reply-To: <4B864FC4.3000201@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-02-25 11:24, Patrick McHardy wrote:
>
>> My intention was to have the entire set merged by 2.6.32, only
>> delayed by my own tinkering around with the get_cycle measurement of
>> the data collapse. But it was ready on-time for the 2.6.34 window!
>> What went wrong? Do we need to begin the merge-into-kabernext window
>> much earlier?
>
>Yes, you should begin submitting patches when net-next opens,
>usually at -rc1.

Thanks for clearing this point of doubt up - I was under the
impression that submissions were only accepted when kaber-next
opens.
