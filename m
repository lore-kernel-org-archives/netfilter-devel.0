From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxtables: change option precedence order to be intuitive
Date: Thu, 28 Oct 2010 11:54:28 +0200
Message-ID: <4CC94854.8010306@trash.net>
References: <1287501388-5948-1-git-send-email-jengelh@medozas.de> <1287501388-5948-2-git-send-email-jengelh@medozas.de> <alpine.LNX.2.01.1010252357270.18188@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44402 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0J1Jya (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Oct 2010 05:54:30 -0400
In-Reply-To: <alpine.LNX.2.01.1010252357270.18188@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.10.2010 23:57, Jan Engelhardt wrote:
> On Tuesday 2010-10-19 17:16, Jan Engelhardt wrote:
> 
>> When using `-m mark --mark 2 -m connmark --mark 2`, the user currently
>> gets an error about the (libxt_mark) --mark option being used twice.
>> This is because libxt_connmark's option table does not override any
>> previous options. This patch changes this behavior, since the current
>> behavior does not allow connmark's option to be used at all, which is
>> illogical.
> 
> As per fw's suggestion, I should nag you every 48 hours ;-)
> 
> Really, this should be in the next tag.

This stuff is pretty fragile and whenever we changed it, something broke
for users. Why not simply add new options  (--connmark etc). That would
also be more consistent with the other extensions.
