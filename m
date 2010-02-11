From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/6] netfilter: xtables: add const qualifiers
Date: Thu, 11 Feb 2010 17:06:57 +0100
Message-ID: <4B742B21.9040300@trash.net>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de> <1265823547-10358-7-git-send-email-jengelh@medozas.de> <4B73C740.5020003@trash.net> <alpine.LSU.2.01.1002111427490.32310@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44967 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab0BKQHA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:07:00 -0500
In-Reply-To: <alpine.LSU.2.01.1002111427490.32310@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-02-11 10:00, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> +static inline const struct ip6t_entry_target *
>>> +ip6t_get_target_c(const struct ip6t_entry *e)
>>> +{
>>> +	return ip6t_get_target((struct ip6t_entry *)e);
>>> +}
>>> +
>> I would prefer a macro over these get_target_c functions.
> 
> Why so?

Because it avoids having a function for const and one for non-const.
