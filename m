From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/2] [NETFILTER]: xt_owner: allow matching UID/GID ranges
Date: Sun, 20 Jan 2008 19:03:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201838540.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801201318040.14598@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801201318500.14598@fbirervta.pbzchgretzou.qr>
 <479351A5.9000501@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43001 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbYATSDX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:03:23 -0500
In-Reply-To: <479351A5.9000501@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 20 2008 14:50, Patrick McHardy wrote:
>
> Jan Engelhardt wrote:
>> commit 1ab123486c698860966193d254db54f8a4d428b4
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Sun Jan 20 13:15:08 2008 +0100
>> 
>>     [NETFILTER]: xt_owner: allow matching UID/GID ranges
>
>
> Is that actually useful? The GID already allows to match
> on entire groups, this seems like a "let do it just because
> we can" patch to me.
>
Of course there is a use case. System with like 2000 students; the
user database is historically grown, so UIDs are 'consecutively
random', i.e. order depends on time the user account was added.
Preallocating an UID range to students is therefore not anymore
possible.

	* I do not want to add 2000 -m owner rules,
	that would just be totally inefficient.

I could add rules for blocks of UIDs (usually they do get added in
batch), but...

	* that's still lots!
	2032-5241, 6010-6185, 10001-10209, 10214, 10235-10422, ...

So, we turn to the GID. Because the GID of a user depends on the
grade (and that changes over time), preallocating UID ranges is not
even feasible. But well, at least the number of rules is down:

	* 1301, 1302, 1303, 1304, 1305...

Can we simplify that? Yes, with GID ranges.

	* 1301-1334
	* 1352-1364 (blame legislation for this new range...)

Two rules, I'm stunned! :-)
