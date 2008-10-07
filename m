From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/23] netfilter: xtables: do centralized checkentry call
 (2/2)
Date: Tue, 07 Oct 2008 15:16:10 +0200
Message-ID: <48EB611A.8020402@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <4d1c693c1eeb16b8e66dfbfa1c43fe178ac4884b.1223294924.git.jengelh@medozas.de> <48EB5ED2.5000109@trash.net> <alpine.LNX.1.10.0810070912590.438@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45438 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYJGNQR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:16:17 -0400
In-Reply-To: <alpine.LNX.1.10.0810070912590.438@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-10-07 09:06, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> With the previous patch moving checks into xtables.c, the checks in
>>> *_tables can be cleaned out. Also propagate the error code from
>>> xt_{match,target}_check in the error case instead of always using
>>> -EINVAL.
>> It seems to me this part also belongs in patch 1/2 since we're
>> doing these checks twice for one revision?
>>
> Yes, this was split for easier review, but should ideally be folded
> or we might get a memory and ref leaks.

OK, done.

