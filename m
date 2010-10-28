From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: change option precedence order to be
 intuitive
Date: Thu, 28 Oct 2010 12:54:00 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010281250120.2326@obet.zrqbmnf.qr>
References: <1287501388-5948-1-git-send-email-jengelh@medozas.de> <1287501388-5948-2-git-send-email-jengelh@medozas.de> <alpine.LNX.2.01.1010252357270.18188@obet.zrqbmnf.qr> <4CC94854.8010306@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40114 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab0J1KyB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Oct 2010 06:54:01 -0400
In-Reply-To: <4CC94854.8010306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-10-28 11:54, Patrick McHardy wrote:

>On 25.10.2010 23:57, Jan Engelhardt wrote:
>> On Tuesday 2010-10-19 17:16, Jan Engelhardt wrote:
>> 
>>> When using `-m mark --mark 2 -m connmark --mark 2`, the user currently
>>> gets an error about the (libxt_mark) --mark option being used twice.
>>> This is because libxt_connmark's option table does not override any
>>> previous options. This patch changes this behavior, since the current
>>> behavior does not allow connmark's option to be used at all, which is
>>> illogical.
>> 
>> As per fw's suggestion, I should nag you every 48 hours ;-)
>> 
>> Really, this should be in the next tag.
>
>This stuff is pretty fragile and whenever we changed it, something broke
>for users. Why not simply add new options  (--connmark etc). That would
>also be more consistent with the other extensions.

Adding new options does not fix the real problem, and you cannot easily 
ensure that no options will clash with another.
And what do you do when you use -m hashlimit --hashlimit-name abc -m 
hashlimit --hashlimit-name def? You can't use new options here.

