From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf-next: TEE only
Date: Wed, 14 Apr 2010 13:32:08 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004141326570.13840@obet.zrqbmnf.qr>
References: <1271200907-5262-1-git-send-email-jengelh@medozas.de> <4BC59F93.8090209@trash.net> <alpine.LSU.2.01.1004141310120.13840@obet.zrqbmnf.qr> <4BC5A603.5090403@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50883 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab0DNLcK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 07:32:10 -0400
In-Reply-To: <4BC5A603.5090403@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-04-14 13:24, Patrick McHardy wrote:
>>> So what about oif routing which I asked for two times?
>> 
>> Guess it must have fallen off somewhere between the resends. We can 
>> still add it as a patch on top.
>
>Please add it before I apply it. Should be a fairly trivial change.
>
>>> I guess you'd usually have a host for logging or IDS somewhere on a
>>> private network and TEE packets there. So specifying oif and gateway
>>> seems most useful to me.
>> 
>> The oif is already determined by the route to the gateway(logging
>> host). I'd also fear that people abuse TEE as a ROUTE replacement
>> when they see an --oif.
>
>That's something different. The oif forces use of a specific output
>device, independant of the routing tables. F.i.:

You should be able to use a specific output device by use of a routing 
table, and selecting that table with fwmark.
