From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 004/103] netfilter: xtables: remove xt_connmark v0
Date: Mon, 10 Aug 2009 11:01:21 +0200
Message-ID: <4A7FE1E1.1020503@trash.net>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de> <1249370787-17583-5-git-send-email-jengelh@medozas.de> <4A7FDD46.30509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59399 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZHJJBZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:01:25 -0400
In-Reply-To: <4A7FDD46.30509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Superseded by xt_connmark v1 (v2.6.24-2919-g96e3227).
>>
>> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>> ---
>>  Documentation/feature-removal-schedule.txt |    3 -
>>  include/linux/netfilter/xt_connmark.h      |    5 --
>>  net/netfilter/xt_connmark.c                |  101 +++-------------------------
>>  3 files changed, 11 insertions(+), 98 deletions(-)
> 
> This does not apply. You seem to have based your patches on an
> old tree which doesn't include revision 2. Please use
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git
> 
> as base.

And please only the removal- and initial cleanup patches in your
first submission. We can continue with the real changes after that.
