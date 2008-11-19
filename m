From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] netfilter: ip{,6}t_policy.h should include xp_policy.h
Date: Wed, 19 Nov 2008 19:38:34 +0100
Message-ID: <49245D2A.5090106@trash.net>
References: <1227111682-14073-1-git-send-email-apw@canonical.com> <49245611.1080905@trash.net> <alpine.LNX.1.10.0811191926590.4486@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andy Whitcroft <apw@canonical.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37264 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbYKSSil (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:38:41 -0500
In-Reply-To: <alpine.LNX.1.10.0811191926590.4486@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-11-19 19:08, Patrick McHardy wrote:
> 
>> Andy Whitcroft wrote:
>>> It seems that all of the include/netfilter_{ipv4,ipv6}/{ipt,ip6t}_*.h which
>>> share constants include the corresponding include/netfilter/xp_*.h files.
>>> Neither ipt_policy.h not ip6t_policy.h do.  Make these consistant with
>>> the norm.
>> Does this actually fix a bug, or is it just for added consistency?
> 
> This can only be consistency, because every compile error would
> be easy to fix by inclusion of xt_policy.h in the corresponding
> .c file.

It would also be easily fixed by this patch. Lets see what Andy
has to say.

> Which reminds me, when can we get rid of the ipt_*h files?

There is external code using these headers, so not at this point.
We could schedule them for removal, but I don't see point, keeping
those headers don't cause any maintenance work.

