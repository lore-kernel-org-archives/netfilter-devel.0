From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] netfilter: xtables: inclusion of xt_condition
Date: Tue, 13 Apr 2010 13:54:56 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004131354210.32000@obet.zrqbmnf.qr>
References: <1270214599-22734-1-git-send-email-jengelh@medozas.de> <1270214599-22734-2-git-send-email-jengelh@medozas.de> <4BBB4134.2020007@trash.net> <alpine.LSU.2.01.1004131337180.16098@obet.zrqbmnf.qr> <4BC458D1.10506@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46855 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab0DMLy6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:54:58 -0400
In-Reply-To: <4BC458D1.10506@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-04-13 13:43, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> On Tuesday 2010-04-06 16:12, Patrick McHardy wrote:
>>> Jan Engelhardt wrote:
>>>> +/* Defaults, these can be overridden on the module command-line. */
>>>> +static unsigned int condition_list_perms = S_IRUSR | S_IWUSR;
>>>> +static unsigned int condition_uid_perms;
>>>> +static unsigned int condition_gid_perms;
>>> I think it might be useful to make them overridable on a per-rule base
>>> if it doesn't cause inconsistent behaviour when sharing a condition
>>> variable.
>> 
>> That does not work; a condition variable can only be owned
>> by one uid.
>
>Yeah. We could allow just the creating rule to specify permissions.
>But its not necessary.

Well, don't forget that adding a rule means creating a new table
adding two rules and throwing away the old one.
