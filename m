From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: ebtables: fix one wrong return value
Date: Tue, 07 Oct 2008 15:02:57 +0200
Message-ID: <48EB5E01.1000300@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <1a68c9d72045f79f5b103da31beb8a3e120e9de2.1223294924.git.jengelh@medozas.de> <48EA3B7F.9000007@trash.net> <alpine.LNX.1.10.0810061232490.10698@fbirervta.pbzchgretzou.qr> <48EA4032.20300@trash.net> <alpine.LNX.1.10.0810061248240.10698@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45086 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbYJGNDF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:03:05 -0400
In-Reply-To: <alpine.LNX.1.10.0810061248240.10698@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-10-06 12:43, Patrick McHardy wrote:
>> The patchset you've sent is missing the patch "fix one wrong return
>> value" from your tree.
>>
>> Please send that one seperately.
>>
> Oh joy of git-format-patch <NOT_SO_INCLUSIVE_SHA>..HEAD!

That one has hit me multiple times as well :)

> Here's PATCH "-01/23":
> ===
> commit 9ea25486b5c9b3aed90525721fe598397a5e2581
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sun Oct 5 11:26:51 2008 -0400
> 
> netfilter: ebtables: fix one wrong return value
> 
> Usually -EINVAL is used when checkentry fails (see *_tables).

Applied, thanks.
