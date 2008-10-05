From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/16] [NETFILTER]: Re-add missing checkentry calls
Date: Sun, 05 Oct 2008 15:32:24 +0200
Message-ID: <48E8C1E8.5050309@trash.net>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de> <48E8B831.7020609@trash.net> <alpine.LNX.1.10.0810050922510.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44842 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYJENcf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 09:32:35 -0400
In-Reply-To: <alpine.LNX.1.10.0810050922510.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 08:50, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> A previous commit ("Move Ebtables to use Xtables") unfortunately
>>> removed match and target checks in Ebtables. Add it back. Some checks
>>> go into xtables.c as part of consolidation work.
>> Should I fold this one into the patch that removed them?
>>
> I am not always sure of your procedure. When you say "applied, thanks", 
> I have to assume it is already in a non-resettable git tree where 
> folding is impossible.

I'm using stacked git to keep the history clean and bisectable.
So changes are always possible, although doing this creates a few
problems for people having cloned the tree, so I try to only do it
when necessary.

> Hence these patches are generally designed for 
> on-top-please.

That makes sense of course, the question was more about whether
it would make it easier for people doing bisections if I fold it.
It applies cleanly on top of that change directly, so it wouldn't
be a real problem.

