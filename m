From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: Combine ipt_ttl and ip6t_hl source
Date: Wed, 18 Feb 2009 19:07:33 +0100
Message-ID: <499C4E65.3050609@trash.net>
References: <1234972949-12036-1-git-send-email-jengelh@medozas.de> <1234972949-12036-3-git-send-email-jengelh@medozas.de> <499C4813.8070102@trash.net> <alpine.LSU.2.00.0902181855570.8011@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59321 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZBRSHf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:07:35 -0500
In-Reply-To: <alpine.LSU.2.00.0902181855570.8011@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-02-18 18:40, Patrick McHardy wrote:
>> Also applied, thanks. How about a compat config option for one
>> or two releases to keep the make oldconfig annoyance down?
>>
> This has been previously discussed with Sam or Roman, the end result
> being that kbuild does not quite support option fowarding - every
> symbol (e.g. OLD_TTL) that has no text will only be enabled if another
> symbol references it (thru 'select' for example) and otherwise any
> value, even one from .config, will be discarded and set to =n instead.
> But when OLD_TTL=n, the 'select NEW_TTL' on OLD_TTL will not take
> effect, and so on..

The alternative is to keep the text at the old options and have
them select a new hidden one. After two releases we move the
text over and kill the old ones.

But we really should do something about the constant kconfig
annoyance caused by these renames, let alone people who really
drop an option by accident and start bug hunting.
