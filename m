From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/23] netfilter: xtables: do centralized checkentry call
 (1/2)
Date: Mon, 06 Oct 2008 18:43:30 +0200
Message-ID: <48EA4032.20300@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <1a68c9d72045f79f5b103da31beb8a3e120e9de2.1223294924.git.jengelh@medozas.de> <48EA3B7F.9000007@trash.net> <alpine.LNX.1.10.0810061232490.10698@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46809 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbYJFQnh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:43:37 -0400
In-Reply-To: <alpine.LNX.1.10.0810061232490.10698@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-10-06 12:23, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> It used to be that {ip,ip6,etc}_tables called extension->checkentry
>>> themselves, but this can be moved into the xtables core.
>> This one doesn't apply cleanly:
>>
>> patching file net/bridge/netfilter/ebtables.c
>> Hunk #3 FAILED at 684.
>> 1 out of 3 hunks FAILED -- saving rejects to file
>> net/bridge/netfilter/ebtables.c.rej
>>
>> Since I guess this will introduce new rejects in the following
>> patches, I'll wait until you've figured out what went wrong.
>> I've applied the patches in the order specified on top of
>> 8d51a6615, replacing the previous patches.
> 
> By logic alone already, I can say I dunno what's going on.

The patchset you've sent is missing the patch "fix one wrong return
value" from your tree.

Please send that one seperately.
