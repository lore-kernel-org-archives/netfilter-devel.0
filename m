From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: xtables: inclusion of xt_condition
Date: Tue, 13 Apr 2010 13:43:13 +0200
Message-ID: <4BC458D1.10506@trash.net>
References: <1270214599-22734-1-git-send-email-jengelh@medozas.de> <1270214599-22734-2-git-send-email-jengelh@medozas.de> <4BBB4134.2020007@trash.net> <alpine.LSU.2.01.1004131337180.16098@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47763 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0DMLnQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:43:16 -0400
In-Reply-To: <alpine.LSU.2.01.1004131337180.16098@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-04-06 16:12, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> +/* Defaults, these can be overridden on the module command-line. */
>>> +static unsigned int condition_list_perms = S_IRUSR | S_IWUSR;
>>> +static unsigned int condition_uid_perms;
>>> +static unsigned int condition_gid_perms;
>> I think it might be useful to make them overridable on a per-rule base
>> if it doesn't cause inconsistent behaviour when sharing a condition
>> variable.
> 
> That does not work; a condition variable can only be owned
> by one uid.

Yeah. We could allow just the creating rule to specify permissions.
But its not necessary.


